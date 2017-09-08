//
//  MySupportTableViewController.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 17/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import Firebase

class MySupportTableViewController: UITableViewController {
    
    var myReportSupported:[Report] = []
    var refMySupport: DatabaseReference!
    
    override func viewDidLoad() {
        self.refMySupport = Database.database().reference().child("my-support").child(UserInteractor.getCurrentUserUid()!)
        super.viewDidLoad()
        
       setObserverToFireBaseChanges()
        
        print(myReportSupported.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myReportSupported.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "supportCell", for: indexPath) as! MySupportTableViewCell

        cell.titleLabel.text = myReportSupported[indexPath.row].title
        cell.descriptionLabel.text = myReportSupported[indexPath.row].description
        let latitude = myReportSupported[indexPath.row].latitude
        let longitude = myReportSupported[indexPath.row].longitude
        
        setMapLocation(location: cell.mapView, latitude: latitude, longitude: longitude)
        
        cell.mapView.isUserInteractionEnabled = false
        
        //PEGAR NOME E LOCALIDADE DO USUARIO
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.reportToEdit = self.userReports[indexPath.row]
//        performSegue(withIdentifier: "seeMyReport", sender: Any.self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
    func setMapLocation(location:MGLMapView, latitude: Double, longitude: Double){
        
        let locationCoodenate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        location.setCenter(locationCoodenate, zoomLevel: 13, animated: true)
        
        location.showsUserLocation = false
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude) )
        
        location.addAnnotation(annotation)
        
    }

    //It observers the firebase database to get the newly changes
    func setObserverToFireBaseChanges() {
        
        self.refMySupport.observe(.childAdded, with: {(snapshot) in
            
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
                    
                    let reportAtt = Report(id: id as! String,
                                           userId: userId as! String,
                                           title: title as! String,
                                           description: description as! String,
                                           violenceKind: violenceKind as! String,
                                           violenceAproximatedTime: violenceAproximatedTime as! Double,
                                           latitude: latitude as! Double,
                                           longitude: longitude as! Double,
                                           personGender: personGender as! String)
                    
                    self.myReportSupported.append(reportAtt)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        })
    }

}
