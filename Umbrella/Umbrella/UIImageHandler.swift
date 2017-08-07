//
//  UIImageRealmHandler.swift
//  Umbrella
//
//  Created by Bruno Chagas on 03/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func data() -> Data? {

        guard var imageData = UIImagePNGRepresentation(self) else {
            return nil
        }
        
        if imageData.count > 2097152 {
            let oldSize = self.size
            let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            let newImage = self.resizeImage(self, size: newSize)
            return UIImageJPEGRepresentation(newImage, 0.7)
        }
        
        return imageData
    }
    
    func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func base64EncodedString() -> String? {
        let imageData = self.data()
        let stringData = imageData?.base64EncodedString(options: .endLineWithCarriageReturn)
        return stringData
    }
}
