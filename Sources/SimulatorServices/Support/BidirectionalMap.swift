//
//  BidirectionalMap.swift
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

/// A one-to-one mapping that looks up in either direction.
///
/// Write a mapping once, as a dictionary literal, and look values up from
/// either side, instead of keeping two `switch` statements in step.
public struct BidirectionalMap<Left, Right>: Sendable
where Left: Hashable & Sendable, Right: Hashable & Sendable {
  private let rights: [Left: Right]
  private let lefts: [Right: Left]

  /// The left-hand values, in no particular order.
  public var leftValues: Dictionary<Left, Right>.Keys {
    rights.keys
  }

  /// The right-hand values, in no particular order.
  public var rightValues: Dictionary<Right, Left>.Keys {
    lefts.keys
  }

  /// Creates a mapping from left-to-right pairs.
  ///
  /// Each value must appear once on each side.
  public init(_ pairs: [Left: Right]) {
    rights = pairs
    lefts = Dictionary(pairs.map { ($1, $0) }) { first, _ in
      assertionFailure("A right-hand value appears twice.")
      return first
    }
  }

  /// The right-hand value for `left`, or `nil` if it isn't mapped.
  public subscript(left left: Left) -> Right? {
    rights[left]
  }

  /// The left-hand value for `right`, or `nil` if it isn't mapped.
  public subscript(right right: Right) -> Left? {
    lefts[right]
  }
}

extension BidirectionalMap: ExpressibleByDictionaryLiteral {
  /// Creates a mapping from a dictionary literal of left-to-right pairs.
  public init(dictionaryLiteral elements: (Left, Right)...) {
    let pairs = Dictionary(elements) { first, _ in
      assertionFailure("A left-hand value appears twice.")
      return first
    }
    self.init(pairs)
  }
}
