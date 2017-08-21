//
//  ReportTableViewCell.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 20/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import Mapbox

class ReportTableViewCell: MGSwipeTableCell {

    
    @IBOutlet weak var map: MGLMapView!
    @IBOutlet weak var reportDescription: UILabel!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var mapView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
