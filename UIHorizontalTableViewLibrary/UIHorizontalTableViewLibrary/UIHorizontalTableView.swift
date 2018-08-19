//
//  UIHorizontalTableView.swift
//  UIHorizontalTableViewLibrary
//
//  Created by xiaoguang on 7/28/18.
//  Copyright © 2018 Ray. All rights reserved.
//

import UIKit

@objc protocol UIHorizontalTableViewDataSource: class {
    @objc optional func numberOfSections(in tableView: UIHorizontalTableView) -> Int
    func tableView(_ tableView: UIHorizontalTableView, numberOfColumnsInSection section: Int) -> Int
    func tableView(_ tableView: UIHorizontalTableView, cellForColumnsAt indexPath: MyIndexPath) -> UIHorizontalTableViewCell
}

@objc protocol UIHorizontalTableViewDelegate: UIScrollViewDelegate {
    @objc optional func tableView(_ tableView: UIHorizontalTableView, widthForColumnsAt indexPath: MyIndexPath) -> CGFloat
}

let kDefaulColumntWidth: CGFloat = 44.0

class UIHorizontalTableView: UIScrollView {
    var table: UITableView? //just in case
    weak var dataSource: UIHorizontalTableViewDataSource?
    weak var tableDelegate: UIHorizontalTableViewDelegate?
    
    var numerOfSections: Int {
        get {
            return self.dataSource?.numberOfSections?(in: self) ?? 1
        }
    }
    
    func numberOfColumns(inSection section: Int) -> Int {
        if section < self.numerOfSections {
            return self.dataSource?.tableView(self, numberOfColumnsInSection: section) ?? 0
        } else {
            return 0
        }
    }
    
    func widthForColumnsAt(indexPath: MyIndexPath) -> CGFloat {
        return self.tableDelegate?.tableView?(self, widthForColumnsAt: indexPath) ?? kDefaulColumntWidth
    }
    
    
    private var onScreenCells: Set<UIHorizontalTableViewCell> = []
    private var onScreenCellsIndexMap: [UIHorizontalTableViewCell: MyIndexPath] = [:]
    private var offScreenCells: [String: Set<UIHorizontalTableViewCell>] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    func setUp() {
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = true
        self.isDirectionalLockEnabled = true
        self.isPagingEnabled = true
        self.delegate = self
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.reloadData()
    }
    
    func reloadData() {
        let totalWidth = self.calculateTotalWidth()
        self.contentSize = CGSize(width: totalWidth, height: self.frame.origin.y)
        
        //Adjust contentOffset
        if contentOffset.x < 0 {
            self.contentOffset = CGPoint(x: 0.0, y: self.contentOffset.y)
        } else if self.contentOffset.x + self.frame.size.width > totalWidth {
            self.contentOffset = CGPoint(x: totalWidth - self.frame.size.width, y: self.frame.origin.y)
        }
        
        //Recycling all on screen cells
        
        for cell in self.onScreenCells {
            cell.removeFromSuperview()
            guard let reusedIdentifier = cell.reuseIdentifier else {
                continue
            }
            self.offScreenCells[reusedIdentifier, default: []].insert(cell)
        }
        self.onScreenCells.removeAll()
        self.onScreenCellsIndexMap.removeAll()
        
        //rendering cells on screen
        self.renderOnScreenCells()
    }
    
    func renderOnScreenCells() {
        let sections = self.numerOfSections
        if sections < 0 {
            print("no render need")
            return
        }
        
        let visibleRange = (left: self.contentOffset.x, right: self.contentOffset.x + self.frame.size.width)
        var offsetX: CGFloat = 0.0
        let y = self.frame.origin.y
        let height = self.frame.size.height
        var stop = false
        
        for i in 0..<sections {
            for j in 0..<self.numberOfColumns(inSection: i) {
                if visibleRange.left + offsetX >= visibleRange.right {
                    stop = true
                    break
                }
                
                let indexPath = MyIndexPath(columns: j, section: i)
                let cellWidth = self.widthForColumnsAt(indexPath: indexPath)
                if let cell = self.dataSource?.tableView(self, cellForColumnsAt: indexPath) {
                    self.onScreenCells.insert(cell)
                    self.onScreenCellsIndexMap[cell] = indexPath
                    cell.frame = CGRect(x: visibleRange.left + offsetX, y: y, width: cellWidth, height: height)
                    offsetX += cellWidth
                    self.addSubview(cell)
                }
            }
            
            if stop {
                break
            }
        }
    }
    
    func recycleOffScreenCells() {
        for view in self.subviews {
            guard let cellView = view as? UIHorizontalTableViewCell else {
                continue
            }
            if cellView.frame.origin.x + cellView.frame.size.width <= self.contentOffset.x {
                cellView.prepareForReuse()
                cellView.removeFromSuperview()
                self.onScreenCells.remove(cellView)
                self.onScreenCellsIndexMap.removeValue(forKey: cellView)
                self.offScreenCells[cellView.reuseIdentifier ?? "", default: []].insert(cellView)
            }
        }
    }
    
    func calculateTotalWidth() -> CGFloat {
        var total: CGFloat = 0.0
        for i in 0..<self.numerOfSections {
            for j in 0..<self.numberOfColumns(inSection: i) {
                total += self.widthForColumnsAt(indexPath: MyIndexPath(columns: j, section: i))
            }
        }
        return total
    }
    
    public func dequeueReusableCell(identifer: String) -> UIHorizontalTableViewCell? {
        if var cellSet = self.offScreenCells[identifer], let cell = cellSet.first {
            cell.prepareForReuse()
            cellSet.removeFirst()
            return cell
        } else {
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIHorizontalTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        defer {
            self.tableDelegate?.scrollViewDidScroll?(scrollView)
        }
        
        self.recycleOffScreenCells()
        if self.onScreenCells.count == 0 {
            self.renderOnScreenCells()
            return
        }

        let leftestCell = self.subviews.reduce(self.onScreenCells.first!) {result, view in
            if view is UIHorizontalTableViewCell {
                if view.frame.origin.x < result.frame.origin.x {
                    return view as! UIHorizontalTableViewCell
                }
            }
            return result
        }
        
        self.renderLeftestCell(leftestCell)
        
        let rightestCell = self.subviews.reduce(self.onScreenCells.first!) {result, view in
            if view is UIHorizontalTableViewCell {
                if view.frame.origin.x > result.frame.origin.x {
                    return view as! UIHorizontalTableViewCell
                }
            }
            return result
        }
        
        self.renderRightestCell(rightestCell)
    }
    
    func renderLeftestCell(_ currentLeftestCell: UIHorizontalTableViewCell) {
        if currentLeftestCell.frame.origin.x <= self.contentOffset.x {
            return
        }
        
        if let currentIndexPath = self.onScreenCellsIndexMap[currentLeftestCell] {
            var leftIndexPath: MyIndexPath?
            if currentIndexPath.columns > 0 {
                leftIndexPath = MyIndexPath(columns: currentIndexPath.columns - 1, section: currentIndexPath.section)
            } else if currentIndexPath.section > 0 {
                let leftSection = currentIndexPath.section - 1
                leftIndexPath = MyIndexPath(columns: self.numberOfColumns(inSection: leftSection) - 1, section: leftSection)
            }
            
            if let leftIndexPath = leftIndexPath {
                if let cellWidth = self.tableDelegate?.tableView?(self, widthForColumnsAt: leftIndexPath),
                    let cell = self.dataSource?.tableView(self, cellForColumnsAt: leftIndexPath) {
                    self.onScreenCells.insert(cell)
                    self.onScreenCellsIndexMap[cell] = leftIndexPath
                    cell.frame = CGRect(x: currentLeftestCell.frame.origin.x - currentLeftestCell.frame.size.width,
                                        y: currentLeftestCell.frame.origin.y,
                                        width: cellWidth,
                                        height: currentLeftestCell.frame.size.height)
                    renderLeftestCell(cell)
                }
            }
        } else {
            print("no index found")
        }
    }
    
    func renderRightestCell(_ currentRightestCell: UIHorizontalTableViewCell) {
        if currentRightestCell.frame.origin.x + currentRightestCell.frame.size.width >= self.contentOffset.x + self.frame.size.width {
            return
        }
        
        if let currentIndexPath = self.onScreenCellsIndexMap[currentRightestCell] {
            var rightIndexPath: MyIndexPath?
            if currentIndexPath.columns < self.numberOfColumns(inSection: currentIndexPath.section) - 1 {
                rightIndexPath = MyIndexPath(columns: currentIndexPath.columns + 1, section: currentIndexPath.section)
            } else if currentIndexPath.section < self.numerOfSections - 1 {
                let rightSection = currentIndexPath.section + 1
                rightIndexPath = MyIndexPath(columns: 0, section: rightSection)
            }
            
            if let rightIndexPath = rightIndexPath {
                if let cellWidth = self.tableDelegate?.tableView?(self, widthForColumnsAt: rightIndexPath),
                    let cell = self.dataSource?.tableView(self, cellForColumnsAt: rightIndexPath) {
                    self.onScreenCells.insert(cell)
                    self.onScreenCellsIndexMap[cell] = rightIndexPath
                    cell.frame = CGRect(x: currentRightestCell.frame.origin.x + currentRightestCell.frame.size.width,
                                        y: currentRightestCell.frame.origin.y,
                                        width: cellWidth,
                                        height: currentRightestCell.frame.size.height)
                    renderRightestCell(cell)
                }
            }
        } else {
            print("no index found")
        }
    }
}


