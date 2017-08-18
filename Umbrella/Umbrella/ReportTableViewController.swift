//
//  ReportTableViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 14/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import Firebase

class ReportTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userReports:[Report] = []
    let mapController = MapViewController()
    let seeReport = SeeReportViewController()
    var userId: String?
    var refUserReport: DatabaseReference!
    
    override func viewDidLoad() {
        self.userId = UserInteractor.getCurrentUserUid()
        self.refUserReport = Database.database().reference().child("user-reports").child(userId!)
        
        self.tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        super.viewDidLoad()
        setObserverToFireBaseChanges()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReports.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       

        let cell = tableView.dequeueReusableCell(withIdentifier: "report", for: indexPath)
        let title = tableView.viewWithTag(3) as! UILabel
        title.text = self.userReports[indexPath.row].title
        
        let description = tableView.viewWithTag(4) as! UILabel
        description.text = self.userReports[indexPath.row].description
        
//        let location = tableView.viewWithTag(5) as! MGLMapView
//        
//        let latitude = self.userReports[indexPath.row].latitude
//        let longitude = self.userReports[indexPath.row].longitude
//        
//        self.seeReport.initiateLocationOnMap(map: location, latitude: latitude, longitude: longitude)
        
        
        return cell
    }
    
    
    func setObserverToFireBaseChanges() {
        
        self.refUserReport.observe(.childAdded, with: {(snapshot) in
            
            let ref =  Database.database().reference().child("reports").child(snapshot.key)
            
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let dictonary = snapshot.value as? [String : Any] {
                    
                    let id = dictonary["id"]
                    let userId = dictonary["userId"]
                    let title = dictonary["title"]
                    let description = dictonary["description"]
                    let violenceKind = dictonary["violenceKind"]
                    let violenceAproximatedTime = dictonary["violenceAproximatedTime"]
                    let latitude = dictonary["latitude"]
                    let longitude = dictonary["longitude"]
                    let personGender = dictonary["personGender"]
                    
                    let reportAtt = Report(id: id as! String, userId: userId as! String, title: title as! String, description: description as! String, violenceKind: violenceKind as! String, violenceAproximatedTime: violenceAproximatedTime as! Double, latitude: latitude as! Double, longitude: longitude as! Double, personGender: personGender as! String)
                    
                    self.userReports.append(reportAtt)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        })
    }
}
