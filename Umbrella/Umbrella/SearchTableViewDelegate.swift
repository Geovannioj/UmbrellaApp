//
//  SearchTableViewDelegate.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 01/09/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return querryResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchBarCellTableViewCell
        
        cell.searchCellLabel.text = querryResults[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCel(sender:)))
        cell.addGestureRecognizer(gesture)
        
        return cell
    }
}
