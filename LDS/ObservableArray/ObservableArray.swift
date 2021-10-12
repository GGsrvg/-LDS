//
//  ObservableArray.swift
//  LDS
//
//  Created by GGsrvg on 10.11.2020.
//

import Foundation

public class ObservableArray<SI: SectionItemPrototype>: ObservableArrayAbstract<SI.Row> {
//    public typealias SI = SectionItem<Header, Row, Footer>
    
    public private(set) var array: [SI] = []
    
    public override init() { }
    
    public override func numberOfSections() -> Int {
        return array.count
    }
    
    public override func numberOfRowsInSection(_ section: Int) -> Int {
        guard section >= 0 && section < self.array.count else {
            return 0
        }
        
        return array[section].rows.count
    }
    
    public override func getRow(at indexPath: IndexPath) -> SI.Row? {
        guard indexPath.section >= 0 && indexPath.section < self.array.count else {
            return nil
        }
        
        guard indexPath.row >= 0 && indexPath.row < self.array[indexPath.section].rows.count else {
            return nil
        }
        
        return self.array[indexPath.section].rows[indexPath.row]
    }
}

// work with array
extension ObservableArray {
    public func set(_ elements: [SI]) {
        array = elements
        notifyReload()
    }
    
    public func clear() {
        array = []
        notifyReload()
    }
    
    public func reload() {
        notifyReload()
    }
    
    public func addSections(_ elements: [SI]) {
        let beforeCount = array.count
        array.append(contentsOf: elements)
        let afterCout = array.count
        
        let indexSet = IndexSet(integersIn: beforeCount..<afterCout)
        notifyAdd(at: indexSet)
    }
    
    public func insertSections(_ elements: [SI], at index: Int) {
        array.insert(contentsOf: elements, at: index)
        let indexSet = IndexSet(integersIn: index..<(elements.count + index))
        notifyInsert(at: indexSet)
    }
    
    public func updateSection(_ element: SI, at index: Int) {
        array[index] = element
        notifyUpdate(at: IndexSet(integer: index))
    }
    
    public func removeSections(at indexSet: IndexSet) {
        array.remove(at: indexSet)
        notifyRemove(at: indexSet)
    }
    
    public func header(_ header: SI.Header, section: Int) {
        array[section].header = header
        notifyHeader(section: section)
    }
    
    public func footer(_ footer: SI.Footer, section: Int) {
        array[section].footer = footer
        notifyFooter(section: section)
    }
    
    public func addRows(_ elements: [SI.Row], section: Int) {
        let indexPath = IndexPath(row: array[section].rows.count, section: section)
//        array[section].rows += elements
        var addIndexPaths: [IndexPath] = []
        for (index, _) in elements.enumerated() {
            var addIndexPath = indexPath
            addIndexPath.row += index
            addIndexPaths.append(addIndexPath)
        }
        notifyAddRow(at: addIndexPaths)
    }
    
    public func insertRows(_ elements: [SI.Row], indexPath: IndexPath) {
//        array[indexPath.section].rows.insert(contentsOf: elements, at: indexPath.row)
//        var insertIndexPaths: [IndexPath] = []
//        for (index, _) in elements.enumerated() {
//            var insertIndexPath = indexPath
//            insertIndexPath.row += index
//            insertIndexPaths.append(insertIndexPath)
//        }
//        notifyInsertRow(at: insertIndexPaths)
    }
    
    public func updateRow(_ element: SI.Row, indexPath: IndexPath) {
//        array[indexPath.section].rows[indexPath.row] = element
//        notifyUpdateRow(at: [
//            indexPath
//        ])
    }
    
    public func removeRow(indexPath: IndexPath) {
//        array[indexPath.section].rows.remove(at: indexPath.row)
//        notifyRemoveRow(at: [
//            indexPath
//        ])
    }
    
    
    public func moveRow(from: IndexPath, to: IndexPath) {
//        guard let row = getRow(at: from) else { return }
//        self.removeRow(indexPath: from)
//        self.insertRows([row], indexPath: to)
        
        
    }
}

// sugar
extension ObservableArray {
    public func findSection(_ elementSection: SI) -> IndexSet? {
        for (sectionIndex, section) in self.array.enumerated() {
            if section == elementSection {
                return IndexSet(integer: sectionIndex)
            }
        }
        return nil
    }
    
    public func findRow(_ elementRow: SI.Row) -> IndexPath? {
        for (sectionIndex, section) in self.array.enumerated() {
            for (rowIndex, row) in section.rows.enumerated() {
                if row == elementRow {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
    @discardableResult
    @available(*, deprecated, message: "Need use RowItem.update()")
    public func updateRow(_ row: SI.Row) -> Bool {
        guard let indexPath = findRow(row) else { return false }
        
        self.updateRow(row, indexPath: indexPath)
        return true
    }
    
}
