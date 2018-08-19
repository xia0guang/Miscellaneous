//
//  UIHorizontalTableViewCell.swift
//  UIHorizontalTableViewLibrary
//
//  Created by xiaoguang on 7/28/18.
//  Copyright © 2018 Ray. All rights reserved.
//

import UIKit

class UIHorizontalTableViewCell: UIView {
    var reuseIdentifier: String?
    var imageView: UIImageView?
    var label: UILabel?
    
    func prepareForReuse() {
        self.imageView?.removeFromSuperview()
        self.label?.removeFromSuperview()
        //Subclass can clear the view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.label = UILabel(frame: frame)
        self.imageView = UIImageView(frame: frame)
    }
    
    convenience init(_ identifier: String) {
        self.init(frame: CGRect.zero)
        self.reuseIdentifier = identifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implementated")
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        print("added to superView \(type(of: newSuperview))")
        if self.label?.text != nil {
            self.addSubview(self.label!)
            if let label = self.label {
                let height = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: self.frame.size.height)
            }
        } else if self.imageView?.image != nil {
            self.addSubview(self.imageView!)
        }
    }
}
