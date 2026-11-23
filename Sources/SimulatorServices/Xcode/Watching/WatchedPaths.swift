//
//  WatchedPaths.swift
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

  import Foundation

  /// What to watch: directories, where any change at any depth counts, and
  /// single files, where only that path counts.
  ///
  /// A file is watched through its parent directory, because tools such as
  /// `xcode-select -s` replace the file rather than write to it. Paths are
  /// kept both as given and with symlinks resolved, since FSEvents reports
  /// real paths (`/private/var/db/…` for `/var/db/…`).
  internal struct WatchedPaths: Sendable, Hashable {
    /// The directories, as given.
    internal let directories: [URL]
    /// The files, as given.
    internal let files: [URL]

    private let directoryPaths: Set<String>
    private let filePaths: Set<String>

    /// The directories to hand to FSEvents: each watched directory and each
    /// file's parent, with symlinks resolved.
    internal let streamPaths: [String]

    /// - Parameters:
    ///   - directories: Watched at any depth.
    ///   - files: Watched by exact path. A symlink itself is watched, not
    ///     its target.
    ///   - canonicalURL: Resolves symlinks.
    internal init(
      directories: [URL],
      files: [URL],
      canonicalURL: (URL) -> URL = XcodeLocator.canonicalURL
    ) {
      self.directories = directories
      self.files = files
      let canonicalDirectories = directories.map { Self.path(canonicalURL($0)) }
      let canonicalFiles = files.map { file in
        Self.path(canonicalURL(file.deletingLastPathComponent()))
          + "/" + file.lastPathComponent
      }
      directoryPaths = Set(directories.map(Self.path) + canonicalDirectories)
      filePaths = Set(files.map(Self.path) + canonicalFiles)
      var stream: [String] = []
      for path in canonicalDirectories + canonicalFiles.map(Self.parent)
      where !stream.contains(path) {
        stream.append(path)
      }
      streamPaths = stream
    }

    private static func path(_ url: URL) -> String {
      // Not `standardizedFileURL`: it turns `/private/var/…` back into
      // `/var/…`, and FSEvents reports the `/private` form.
      trimmed(url.path(percentEncoded: false))
    }

    private static func trimmed(_ path: String) -> String {
      guard path.count > 1, path.hasSuffix("/") else {
        return path
      }
      return String(path.dropLast())
    }

    private static func parent(_ file: String) -> String {
      Self.path(URL(filePath: file).deletingLastPathComponent())
    }

    /// Whether an event at `eventPath` is a change worth reporting.
    internal func matches(_ eventPath: String) -> Bool {
      let path = Self.trimmed(eventPath)
      if filePaths.contains(path) {
        return true
      }
      return directoryPaths.contains { directory in
        path == directory || path.hasPrefix(directory + "/")
      }
    }
  }
#endif
