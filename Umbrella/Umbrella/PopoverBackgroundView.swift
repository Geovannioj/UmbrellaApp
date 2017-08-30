//
//  PopoverBackgroundView.swift
//  Umbrella
//
//  Created by Bruno Chagas on 30/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class PopoverBackgroundView: UIPopoverBackgroundView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    override class func arrowBase() -> CGFloat {
        return 0.0
    }
    
    override class func arrowHeight() -> CGFloat {
        return 0.0
    }
    
    override var arrowOffset: CGFloat {
        get {
            return 0.0
        }
        set {
        }
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return UIPopoverArrowDirection.up
        }
        set {
        }
    }
    
    override class var wantsDefaultContentAppearance: Bool {
        return false
    }

}
