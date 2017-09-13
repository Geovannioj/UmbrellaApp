//
//  Color.swift
//  Umbrella
//
//  Created by Bruno Chagas on 12/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit

enum UmbrellaColors {
    case red
    case orange
    case yellow
    case green
    case blue
    case lightPurple
    case darkPurple
    case smoothGrayPurple
    case grayPurple
    case blackPurple
    case lightGray
    case gray
    case darkGray
    
    var color: UIColor {
        switch self {
        case .red:
            return UIColor(r: 230, g: 80, b: 80)
        case .orange:
            return UIColor(r: 253, g: 167, b: 90)
        case .yellow:
            return UIColor(r: 248, g: 111, b: 28)
        case .green:
            return UIColor(r: 151, g: 203, b: 89)
        case .blue:
            return UIColor(r: 52, g: 175, b: 224)
        case .lightPurple:
            return UIColor(r: 170, g: 10, b: 234)
        case .darkPurple:
            return UIColor(r: 74, g: 3, b: 103)
        case .smoothGrayPurple:
            return UIColor(r: 184, g: 172, b: 190)
        case .grayPurple:
            return UIColor(r: 165, g: 146, b: 173)
        case .blackPurple:
            return UIColor(r: 27, g: 2, b: 37)
        case .lightGray:
            return UIColor(r: 230, g: 228, b: 230)
        case .gray:
            return UIColor(r: 155, g: 155, b: 155)
        case .darkGray:
            return UIColor(r: 74, g: 74, b: 74)
        }
    }
}
