//
//  ListUtility.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

public class TableDataState<T, D: Equatable>: Equatable {
    let type: T
    var currentPage: Int
    var nextPage: Int
    var total: Int
    var isLoading: Bool
    var list: [D]
    var canDisplayEmptyView: Bool
    
    private var rawValue: String {
        return "\(self.type)"
    }
    
    init(type: T) {
        self.type = type
        self.currentPage = 0
        self.nextPage = 1
        self.total = 0
        self.isLoading = false
        self.list = []
        self.canDisplayEmptyView = false
    }
    
    func getItemAt(_ index: Int) -> D? {
        if list.count > index {
            return list[index]
        }
        return nil
    }
    
    func reset() {
        self.currentPage = 0
        self.nextPage = 1
        self.isLoading = false
        self.list = []
    }
    
    func isNeedLoadFirstTime() -> Bool {
        if !isLoading && list.isEmpty {
            return true
        }
        return false
    }
    
    func isNeedLoadNextPage(index: Int) -> Bool {
        if !isLoading && index == list.count - 1 && list.count < total {
            return true
        }
        return false
    }
    
    func update(page: Int, data: [D], total: Int) {
        if page == 1 {
            self.list.removeAll()
            self.list.append(contentsOf: data)
        } else if page == self.currentPage {
            for item in data {
                if let index = self.findIndexOf(item) {
                    self.list[index] = item
                } else {
                    self.list.append(item)
                }
            }
        } else {
            self.list.append(contentsOf: data)
        }
        self.currentPage = page
        self.nextPage = page
        self.total = total
    }
    
    private func findIndexOf(_ object: D) -> Int? {
        for (index, item) in self.list.enumerated() {
            if item == object {
                return index
            }
        }
        return nil
    }
    
    static public func == (lhs: TableDataState<T, D>, rhs: TableDataState<T, D>) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
