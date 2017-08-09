//
//  Extensions.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 05/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension UIButton {
    
    open override var isEnabled: Bool {
        didSet{
            self.alpha = isEnabled ? 1.0 : 0.3
        }
    }
}

extension UIView {
    
    open func backgroundImage(named : String){
        
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage(named: named)
        imageView.contentMode = .scaleAspectFill
        imageView.center = self.center
        self.addSubview(imageView)
        self.sendSubview(toBack: imageView)
    }
}
