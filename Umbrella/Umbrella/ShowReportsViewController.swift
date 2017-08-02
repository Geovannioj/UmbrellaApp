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
    var refReports : DatabaseReference!
    var reportToSend:Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refReports =  Database.database().reference().child("reports");
        setObserverToFireBaseChanges()
        
        
    }
    
    func setObserverToFireBaseChanges() {
        
        self.refReports.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.reports.removeAll()
                
                for report in snapshot.children.allObjects as![DataSnapshot]{
                    let reportObj = report.value as? [String: AnyObject]
                    
                    let id = reportObj?["id"]
                    let userId = reportObj?["userId"]
                    let description = reportObj?["description"]
                    let violenceKind = reportObj?["violenceKind"]
                    let userStatus = reportObj?["userStatus"]
                    let violenceStartTime = reportObj?["violenceStartTime"]
                    let violenceFinishTime = reportObj?["violenceFinishTime"]
                    let latitude = reportObj?["latitude"]
                    let longitude = reportObj?["longitude"]
                    
                    let reportAtt = Report(id: id as! String, userId: userId as! String, description: description as! String, violenceKind: violenceKind as! String, userStatus: userStatus as! String, violenceStartTime: violenceStartTime as! Double, violenceFinishTime: violenceFinishTime as! Double, latitude: latitude as! String, longitude: longitude as! String)
                    
                    self.reports.append(reportAtt)
                    
                }
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                
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
        self.reportToSend = self.reports[indexPath.row]
        performSegue(withIdentifier: "SeeReport", sender: Any.self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        let deleteWarning = UIAlertController(title: "Delete",
                                              message: "Are you sure you want to delete it?",
                                              preferredStyle: .alert)
        deleteWarning.addAction(UIAlertAction(title: "Delete", style: .destructive,
                                              handler: { (action) in
                                                
            let reportToDelete = self.reports[indexPath.row].id
            self.reports.remove(at: indexPath.row)
            self.refReports.child(reportToDelete).setValue(nil)
            tableView.reloadData()
        }))

        
        deleteWarning.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,
                                              handler:nil))
        
        self.present(deleteWarning, animated: true, completion: nil)

        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SeeReport" {
            if let seeReportScreen = segue.destination as? SeeReportViewController {
                seeReportScreen.report = self.reportToSend
            }
        }
    }
    
    
}
