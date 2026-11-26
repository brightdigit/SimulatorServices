//
//  FSEventsPathWatch.swift
//  SimulatorServices
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if os(macOS)

  import CoreServices
  import Foundation

  /// Owns one `FSEventStreamRef`.
  ///
  /// The actor runs on the dispatch queue FSEvents delivers to, so the
  /// stream is created, stopped and released in the actor's isolation.
  internal actor FSEventsPathWatch: PathWatch {
    /// What the C callback reaches through the context's `info` pointer.
    private final class Callback {
      let paths: WatchedPaths
      private let onChange: @Sendable () -> Void

      init(paths: WatchedPaths, onChange: @escaping @Sendable () -> Void) {
        self.paths = paths
        self.onChange = onChange
      }

      func handle(_ eventPaths: [String]) {
        if eventPaths.contains(where: paths.matches) {
          onChange()
        }
      }
    }

    private static let flags =
      FSEventStreamCreateFlags(kFSEventStreamCreateFlagWatchRoot)
      | FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents)
      | FSEventStreamCreateFlags(kFSEventStreamCreateFlagUseCFTypes)

    private let queue = DispatchSerialQueue(
      label: "com.brightdigit.SimulatorServices.FSEventsPathWatch"
    )
    private var stream: FSEventStreamRef?

    /// Runs the actor on `queue`, where FSEvents calls back.
    nonisolated internal var unownedExecutor: UnownedSerialExecutor {
      queue.asUnownedSerialExecutor()
    }

    internal init?(
      paths: WatchedPaths,
      latency: TimeInterval,
      onChange: @escaping @Sendable () -> Void
    ) {
      let callback = Unmanaged.passRetained(Callback(paths: paths, onChange: onChange))
      guard let stream = Self.makeStream(callback, latency: latency) else {
        callback.release()
        return nil
      }
      FSEventStreamSetDispatchQueue(stream, queue)
      guard FSEventStreamStart(stream) else {
        // Invalidating and releasing the stream releases `callback` too.
        FSEventStreamInvalidate(stream)
        FSEventStreamRelease(stream)
        return nil
      }
      self.stream = stream
    }

    /// A context whose `info` is `callback`, released with the stream.
    private static func makeContext(
      _ callback: Unmanaged<Callback>
    ) -> FSEventStreamContext {
      FSEventStreamContext(
        version: 0,
        info: callback.toOpaque(),
        retain: nil,
        release: { info in
          guard let info else {
            return
          }
          Unmanaged<Callback>.fromOpaque(info).release()
        },
        copyDescription: nil
      )
    }

    /// Creates a stream for the callback's paths.
    ///
    /// The stream releases `callback` when it's released.
    private static func makeStream(
      _ callback: Unmanaged<Callback>,
      latency: TimeInterval
    ) -> FSEventStreamRef? {
      var context = makeContext(callback)
      let handler: FSEventStreamCallback = { _, info, _, eventPaths, _, _ in
        guard let info else {
          return
        }
        let array = Unmanaged<CFArray>.fromOpaque(eventPaths).takeUnretainedValue()
        let paths = (array as NSArray).compactMap { $0 as? String }
        Unmanaged<Callback>.fromOpaque(info).takeUnretainedValue().handle(paths)
      }
      return FSEventStreamCreate(
        kCFAllocatorDefault,
        handler,
        &context,
        callback.takeUnretainedValue().paths.streamPaths as CFArray,
        FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
        latency,
        flags
      )
    }

    private static func tearDown(_ stream: FSEventStreamRef) {
      FSEventStreamStop(stream)
      FSEventStreamInvalidate(stream)
      FSEventStreamRelease(stream)
    }

    /// Stops watching. Safe to call more than once.
    nonisolated internal func cancel() {
      queue.async { [self] in
        assumeIsolated { $0.stop() }
      }
    }

    private func stop() {
      guard let stream else {
        return
      }
      Self.tearDown(stream)
      self.stream = nil
    }

    isolated deinit {
      stop()
    }
  }
#endif
