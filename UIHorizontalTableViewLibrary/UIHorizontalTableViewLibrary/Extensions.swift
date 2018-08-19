//
//  Extensions.swift
//  UIHorizontalTableViewLibrary
//
//  Created by xiaoguang on 7/30/18.
//  Copyright © 2018 Ray. All rights reserved.
//
import Foundation
class MyIndexPath: NSObject {
    var columns: Int
    var section: Int
    init(columns: Int, section: Int) {
        self.columns = columns
        self.section = section
    }
}
