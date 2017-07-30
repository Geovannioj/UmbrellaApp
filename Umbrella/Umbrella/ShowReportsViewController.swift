//
//  ShowReportsViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 30/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ShowReports: UITableViewController {
    
    var reports: [Report] = []
    var refReports : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refReports =  FIRDatabase.database().reference().child("reports");
        
        self.refReports.observe(FIRDataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.reports.removeAll()
                
                for report in snapshot.children.allObjects as![FIRDataSnapshot]{
                    let reportObj = report.value as? [String: AnyObject]
                    
                    let id = reportObj?["id"]
                    let description = reportObj?["description"]
                    let violenceKind = reportObj?["violenceKind"]
                    let userStatus = reportObj?["userStatus"]
                    let violenceStartTime = reportObj?["violenceStartTime"]
                    let violenceFinishTime = reportObj?["violenceFinishTime"]
                    let latitude = reportObj?["latitude"]
                    let longitude = reportObj?["longitude"]
                    
                    let reportAtt = Report(id: id as! String, description: description as! String, violenceKind: violenceKind as! String, userStatus: userStatus as! String, violenceStartTime: violenceStartTime as! String, violenceFinishTime: violenceFinishTime as! String, latitude: latitude as! String, longitude: longitude as! String)
                    
                    self.reports.append(reportAtt)

                }
                self.tableView.reloadData()
            
            }
            })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "report", for: indexPath)
        let identifierCell = cell.viewWithTag(1) as! UILabel
        identifierCell.text = self.reports[indexPath.row].id
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
