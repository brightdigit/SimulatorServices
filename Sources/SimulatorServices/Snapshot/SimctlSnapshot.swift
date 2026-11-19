//
//  SimctlSnapshot.swift
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

import Foundation

/// What `simctl` reported in one read: `simctl runtime list -j` and
/// `simctl list -j` together.
///
/// Read both lists, measure the images ``imagesNeedingMeasurement`` names,
/// and build what you show from the rest. Keeping the two lists in one value
/// lets that mapping be tested against recorded output without running
/// `simctl`.
public struct SimctlSnapshot: Sendable {
  /// The images from `simctl runtime list -j`.
  public let images: [RuntimeImage]
  /// The output of `simctl list -j`.
  public let list: SimulatorList

  /// The images whose `sizeBytes` can't be their size
  /// (``RuntimeImage/reportedSizeBytes`` is `nil`), so they need measuring
  /// on disk, for example with `DirectorySizeMeasurer` (macOS).
  public var imagesNeedingMeasurement: [RuntimeImage] {
    images.filter { $0.reportedSizeBytes == nil }
  }

  /// Creates a snapshot.
  /// - Parameters:
  ///   - images: The images from `simctl runtime list -j`.
  ///   - list: The output of `simctl list -j`.
  public init(images: [RuntimeImage], list: SimulatorList) {
    self.images = images
    self.list = list
  }
}
