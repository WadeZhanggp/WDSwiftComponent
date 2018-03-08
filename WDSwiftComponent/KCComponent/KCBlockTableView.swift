//
//  KCBlockTableView.swift
//  KCUIKitAddtion
//
//  Created by karsa on 16/10/26.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation

public final class KCBlockSimpleTableView : UITableView, UITableViewDataSource, UITableViewDelegate  {
    public var items : [[Any]]? {
        didSet {
            self.dataSource = self
            self.delegate = self
        }
    }
    public var cellHeight : ((IndexPath) -> CGFloat) = { _ in
        return 44
    }
    public var cellGeneration : (UITableView, IndexPath) -> UITableViewCell = { (table, indexPath) in
        if let cell = table.dequeueReusableCell(withIdentifier: "") {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: "")
    }
    public var cellConfig : ((UITableViewCell, IndexPath) -> Void) = {(_, _) in }
    public var indexPathSelected : ((UITableView, IndexPath) -> Void) = {(tableView, _) in
    }
    public var indexPathDeselected : ((UITableView, IndexPath) -> Void) = {(tableView, _) in
    }
    public var sectionHeaderHight : ((UITableView, Int) -> CGFloat) = { _, _ in
        return CGFloat(0)
    }
    public var sectionHeaderView :  ((UITableView, Int) -> UIView?) = { _, _ in
        return nil
    }
    public var sectionFooterHight : ((UITableView, Int) -> CGFloat) = { _, _ in
        return CGFloat(0)
    }
    public var sectionFooterView :  ((UITableView, Int) -> UIView?) = { _, _ in
        return nil
    }
    public var willDisplayCell : (UITableView, UITableViewCell, IndexPath) -> Void = { _, _, _ in
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let count = items?.count {
            return count
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = items?[section].count {
            return count
        }
        return 0
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView(tableView, section)
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHight(tableView, section)
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionFooterHight(tableView, section)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionFooterView(tableView, section)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cellGeneration(tableView, indexPath)
        self.cellConfig(cell, indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathSelected(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        indexPathDeselected(tableView, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell(tableView, cell, indexPath)
    }
}
