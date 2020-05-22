//
//  ViewController.swift
//  UIHorizontalTableViewLibrary
//
//  Created by xiaoguang on 7/28/18.
//  Copyright © 2018 Ray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var hTableView: UIHorizontalTableView!
    var dataNums: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataNums = (0...50).map{$0}
        
        self.hTableView = UIHorizontalTableView(frame: CGRect(x: self.view.frame.origin.x,
                                                              y: self.view.frame.origin.y + 100,
                                                              width: self.view.frame.size.width,
                                                              height: CGFloat(100.0)))
        self.hTableView.dataSource = self
        self.view.addSubview(self.hTableView)
        
    }
}

extension ViewController: UIHorizontalTableViewDataSource {
    func tableView(_ tableView: UIHorizontalTableView, numberOfColumnsInSection section: Int) -> Int {
        return self.dataNums.count
    }
    
    func tableView(_ tableView: UIHorizontalTableView, cellForColumnsAt indexPath: MyIndexPath) -> UIHorizontalTableViewCell {
        let reusedIdentifier = "randomNumber"
        var cell = tableView.dequeueReusableCell(identifer: reusedIdentifier)
        if cell == nil {
            cell = UIHorizontalTableViewCell(reusedIdentifier)
            cell!.label?.text = "a\n\(self.dataNums[indexPath.columns])"
            cell!.label?.backgroundColor = .black
            cell!.label?.textColor = .white
        }
        return cell!
    }
    
    func numberOfSections(in tableView: UIHorizontalTableView) -> Int {
        return 1
    }
}

