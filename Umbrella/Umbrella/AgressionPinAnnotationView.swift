//
//  AgressionPinAnnotationView.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 08/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import Mapbox

 class AgressionPinAnnotationView: MGLAnnotationView {
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.

        layer.contents = UIImage(named: "indicador_crime")?.cgImage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
//        let animation = CABasicAnimation(keyPath: "borderWidth")
//        animation.duration = 0.1
//        layer.borderWidth = selected ? frame.width / 4 : 2
//        layer.add(animation, forKey: "borderWidth")
        
        
    }
    
}
