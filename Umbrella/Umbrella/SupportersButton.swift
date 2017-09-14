//
//  SupportersButton.swift
//  Umbrella
//
//  Created by Bruno Chagas on 13/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class SupportersButton: UIView {

    @IBOutlet weak var firstPhoto: UIImageView!
    @IBOutlet weak var secondPhoto: UIImageView!
    @IBOutlet weak var thirdPhoto: UIImageView!
    @IBOutlet weak var supportCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstPhoto.layer.cornerRadius = firstPhoto.bounds.size.width / 2
        secondPhoto.layer.cornerRadius = secondPhoto.bounds.size.width / 2
        thirdPhoto.layer.cornerRadius = thirdPhoto.bounds.size.width / 2
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
