//
//  Array_Extension.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

// MARK: - Methods
public extension Array {

    /// NCanUtils: Insert an element at the beginning of array.
    ///
    ///        [2, 3, 4, 5].prepend(1) -> [1, 2, 3, 4, 5]
    ///        ["e", "l", "l", "o"].prepend("h") -> ["h", "e", "l", "l", "o"]
    ///
    /// - Parameter newElement: element to insert.
    mutating func prepend(_ newElement: Element) {
        insert(newElement, at: 0)
    }

    /// NCanUtils: Safely swap values at given index positions.
    ///
    ///        [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///        ["h", "e", "l", "l", "o"].safeSwap(from: 1, to: 0) -> ["e", "h", "l", "l", "o"]
    ///
    /// - Parameters:
    ///   - index: index of first element.
    ///   - otherIndex: index of other element.
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
    
    /// NCanUtils: return an new array with split & swape the array at index position.
    ///
    ///        [1, 2, 3, 4, 5].swapeToFirstFrom(index: 3) -> [4, 5, 1, 2, 3]
    ///        ["h", "e", "l", "l", "o"].swapeToFirstFrom(index: 2) -> ["l", "l", "o", "h", "e"]
    ///
    /// - Parameters:
    ///   - index: index of start element.
    func swapeToFirstFrom(index: Int) -> Array {
        var result: Array = []
        var position: Int = self.count - 1
        while position >= index {
            result.prepend(self[position])
            position -= 1
        }
        if self.count > index {
            position = 0
            while position < index {
                result.append(self[position])
                position += 1
            }
        }
        return result
    }

    /// NCanUtils: Sort an array like another array based on a key path. If the other array doesn't contain a certain value, it will be sorted last.
    ///
    ///        [MyStruct(x: 3), MyStruct(x: 1), MyStruct(x: 2)].sorted(like: [1, 2, 3], keyPath: \.x)
    ///            -> [MyStruct(x: 1), MyStruct(x: 2), MyStruct(x: 3)]
    ///
    /// - Parameters:
    ///   - otherArray: array containing elements in the desired order.
    ///   - keyPath: keyPath indiciating the property that the array should be sorted by
    /// - Returns: sorted array.
    func sorted<T: Hashable>(like otherArray: [T], keyPath: KeyPath<Element, T>) -> [Element] {
        let dict = otherArray.enumerated().reduce(into: [:]) { $0[$1.element] = $1.offset }
        return sorted {
            guard let thisIndex = dict[$0[keyPath: keyPath]] else { return false }
            guard let otherIndex = dict[$1[keyPath: keyPath]] else { return true }
            return thisIndex < otherIndex
        }
    }
    
    /// NCanUtils: Returns an array without first element.
    ///
    ///         [1, 2, 3, 4, 5].copyWithoutLast() -> [2, 3, 4, 5]
    ///
    func copyWithoutFirst() -> Array {
        var result: Array = []
        for (index, item) in self.enumerated() {
            if index > 0 {
                result.append(item)
            }
        }
        return result
    }
    
    /// NCanUtils: Returns an array without last element.
    ///
    ///         [1, 2, 3, 4, 5].copyWithoutLast() -> [1, 2, 3, 4]
    ///
    func copyWithoutLast() -> Array {
        var result: Array = []
        var lastIndex = self.count - 1
        if lastIndex < 0 {
            lastIndex = 0
        }
        for (index, item) in self.enumerated() {
            if index != lastIndex {
                result.append(item)
            }
        }
        return result
    }
}

// MARK: - Methods (Equatable)
public extension Array where Element: Equatable {

    /// NCanUtils: Remove all instances of an item from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll(2) -> [1, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"].removeAll("l") -> ["h", "e", "o"]
    ///
    /// - Parameter item: item to remove.
    /// - Returns: self after removing all instances of item.
    @discardableResult
    mutating func removeAll(_ item: Element) -> [Element] {
        removeAll(where: { $0 == item })
        return self
    }

    /// NCanUtils: Remove all instances contained in items parameter from array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeAll([2,5]) -> [1, 3, 4]
    ///        ["h", "e", "l", "l", "o"].removeAll(["l", "h"]) -> ["e", "o"]
    ///
    /// - Parameter items: items to remove.
    /// - Returns: self after removing all instances of all items in given array.
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }

    /// NCanUtils: Remove all duplicate elements from Array.
    ///
    ///        [1, 2, 2, 3, 4, 5].removeDuplicates() -> [1, 2, 3, 4, 5]
    ///        ["h", "e", "l", "l", "o"]. removeDuplicates() -> ["h", "e", "l", "o"]
    ///
    /// - Returns: Return array with all duplicate elements removed.
    @discardableResult
    mutating func removeDuplicates() -> [Element] {
        // Thanks to https://github.com/sairamkotha for improving the method
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return self
    }

    /// NCanUtils: Return array with all duplicate elements removed.
    ///
    ///     [1, 1, 2, 2, 3, 3, 3, 4, 5].withoutDuplicates() -> [1, 2, 3, 4, 5])
    ///     ["h", "e", "l", "l", "o"].withoutDuplicates() -> ["h", "e", "l", "o"])
    ///
    /// - Returns: an array of unique elements.
    ///
    func withoutDuplicates() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }

    /// NCanUtils: Returns an array with all duplicate elements removed using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Equatable.
    /// - Returns: an array of unique elements.
    func withoutDuplicates<E: Equatable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { (result, element) in
            if !result.contains(where: { $0[keyPath: path] == element[keyPath: path] }) {
                result.append(element)
            }
        }
    }

    /// NCanUtils: Returns an array with all duplicate elements removed using KeyPath to compare.
    ///
    /// - Parameter path: Key path to compare, the value must be Hashable.
    /// - Returns: an array of unique elements.
    func withoutDuplicates<E: Hashable>(keyPath path: KeyPath<Element, E>) -> [Element] {
        var set = Set<E>()
        return filter { set.insert($0[keyPath: path]).inserted }
    }
    
    /// NCanUtils: Returns an array without element in items parameter.
    ///
    ///         [1, 2, 3, 4, 5].copyWithout([2, 3]) -> [1, 4, 5]
    ///
    func copyWithout(_ items: [Element]) -> Array {
        var result: Array = []
        for item in self {
            if !items.contains(item) {
                result.append(item)
            }
        }
        return result
    }
}
