//
//  Extensions.swift
//  TelasUmbrella
//
//  Created by Jonas de Castro Leitao on 05/08/17.
//  Copyright © 2017 jonasLeitao. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadCacheImage(_ url: String){
        
        self.image = nil
        
        if let cache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cache
            return
        }
        
        if let realUrl = URL(string: url) {
            URLSession.shared.dataTask(with: realUrl, completionHandler: { (data, response, error) in
                
                if error != nil {
                    return // Tratar erros
                }
                
                DispatchQueue.main.async {
                    
                    if let dowload = UIImage(data: data!) {
                        
                        self.image = dowload
                        imageCache.setObject(dowload, forKey: url as AnyObject)
                    }
                }
            }).resume()
        }
    }
}

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
        
        let background = UIImage(named: named)
        
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = self.center
        self.addSubview(imageView)
        self.sendSubview(toBack: imageView)
    }
}

extension UITextField {
    
    func estimateFrame(width : CGFloat) -> CGRect {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: self.text!).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : self.font!.pointSize], context: nil)
        
    }
}

extension String {
    
    func estimateFrame(width : CGFloat, sizeFont : CGFloat) -> CGRect {
        
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: sizeFont)], context: nil)
        
    }
}











