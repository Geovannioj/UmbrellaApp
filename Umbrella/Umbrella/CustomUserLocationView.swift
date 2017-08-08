//
//  CustomUserLocationView.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 04/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Mapbox

 class CustomUserLocationView: MGLUserLocationAnnotationView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        layer.contentsScale = UIScreen.main.scale
        layer.contentsGravity = kCAGravityCenter
        
        // Use your image here
        layer.contents = UIImage(named: "UserIndicator")?.cgImage
        
    }

}
