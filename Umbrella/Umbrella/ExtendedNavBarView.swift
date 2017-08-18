/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Demonstrates vertically extending the navigation bar.
 */

import UIKit

class ExtendedNavBarView: UIView {
    
    /**
     *  Called when the view is about to be displayed.  May be called more than
     *  once.
     */
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        // Use the layer shadow to draw a one pixel hairline under this view.
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        layer.shadowRadius = 0
        layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        
        // UINavigationBar's hairline is adaptive, its properties change with
        // the contents it overlies.  You may need to experiment with these
        // values to best match your content.
        
        let rect = CGRect(x: 1, y: self.bounds.size.height, width: self.bounds.size.width, height: 1)
        let line = UIView(frame: rect)
        line.backgroundColor = UIColor(r: 165, g: 146, b: 173)
        self.addSubview(line)
        
        
    }
    
}
