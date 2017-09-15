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
import MGSwipeTableCell

class ReportTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userReports:[Report] = []
    let mapController = MapViewController()
    let seeReport = SeeReportViewController()
    var userId: String?
    var reportToEdit:Report?
    var refReports:DatabaseReference!
    var refUserReport: DatabaseReference!
    var refUserSupport: DatabaseReference!
    var refCommentReport: DatabaseReference!
    
    override func viewDidLoad() {
        self.userId = UserInteractor.getCurrentUserUid()
        self.refUserReport = Database.database().reference().child("user-reports").child(userId!)
        self.refReports =  Database.database().reference().child("reports");
        self.refUserSupport = Database.database().reference().child("user-support")
        self.refCommentReport = Database.database().reference().child("comments")
        
        self.tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        super.viewDidLoad()
        setObserverToFireBaseChanges()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.reportToEdit = self.userReports[indexPath.row]
        performSegue(withIdentifier: "seeMyReport", sender: Any.self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReports.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //setting the cell up
        let cell = Bundle.main.loadNibNamed("ReportTableViewCell", owner: self, options: nil)?.first as! ReportTableViewCell
        
        //sets the label of title of the report
        cell.reportTitle.text = self.userReports[indexPath.row].title
        
        //it sets the label of description of the report
        cell.reportDescription.text = self.userReports[indexPath.row].description
        
        //it sets the view as a MapView
        cell.map.isZoomEnabled = false
        cell.map.isRotateEnabled = false
        cell.map.isScrollEnabled = false
        cell.map.isUserInteractionEnabled = false

        //it gets the coordinates
        let latitude = self.userReports[indexPath.row].latitude
        let longitude = self.userReports[indexPath.row].longitude
        
        //it sets pin to the location of the report and center the map on it
        setMapLocation(location: cell.map, latitude: latitude, longitude: longitude)
        
        let editButton = MGSwipeButton(title:"            ", backgroundColor: UIColor(patternImage: UIImage(named: "editReport")!)){
            (sender: MGSwipeTableCell!) -> Bool in
            
            self.reportToEdit = self.userReports[indexPath.row]
            self.performSegue(withIdentifier: "goToEditReport", sender: tableView)
            
            return true
        }

        let deleteButton = MGSwipeButton(title:"            ", backgroundColor: UIColor(patternImage: UIImage(named: "deleteReport")!)){
            (sender: MGSwipeTableCell!) -> Bool in
            
            let deleteWarning = UIAlertController(title: "Deletar relato",
                                                  message: "Você tem certeza que deseja excluir este relato?",
                                                  preferredStyle: .alert)
            deleteWarning.addAction(UIAlertAction(title: "Deletar", style: .destructive,
                                                  handler: { (action) in
                                                    
                    // report to be deleted
                    let reportToDelete = self.userReports[indexPath.row]
                    
                    //remove the report from the report table
                    self.refReports.child(reportToDelete.id).setValue(nil)
                    
                    //remove from the user-report table
                    self.refUserReport.child(reportToDelete.id).removeValue()
                                                    
                    //remove from the user-support table
                    self.refUserSupport.child(reportToDelete.id).removeValue()
                    
                    //remove comments
                    self.setObserverToFireBaseCommentTable(report: reportToDelete)
                                                    
                    self.userReports.remove(at: indexPath.row)
                    self.tableView.reloadData()
                      
                                                    
            }))
            
            
            deleteWarning.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel,
                                                  handler:nil))
            
            self.present(deleteWarning, animated: true, completion: nil)
            
            
            return true
        }
    
        cell.rightButtons = [editButton, deleteButton]
        cell.rightSwipeSettings.transition = .border

        
        return cell
    }
    
    func setObserverToFireBaseCommentTable(report: Report) {
    
        
        self.refCommentReport.observe(.childAdded, with: { (snapshot) in
            
           // let singleComment = self.refCommentReport.child(snapshot.key)
            
                if let comment = snapshot.value as? [String: Any] {
                    let reportId = comment["reportId"]
                    
                    if  report.id == reportId as! String {
                        print("comentário do repport")
                        self.refCommentReport.child(snapshot.key).setValue(nil)
                    }
                }
            
        })
    }

    
    func getReportIndexInArray(report: Report) -> Int {
        
        var counter = 0
        
        for report in self.mapController.reports {
            if report.id == self.mapController.reports[counter].id {
                return counter
            } else {
                counter += 1
            }
            
        }
        //if there is an error it will crash because the report was not found and a negative value was returned
        return -1
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditReport" {
            if let editScreen = segue.destination as? RegisterReportViewController {
                editScreen.reportToEdit = self.reportToEdit
            }
        } else if segue.identifier == "seeMyReport" {
            if let seeScreen = segue.destination as? SeeReportViewController {
                seeScreen.report = self.reportToEdit
            }
        }
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
                    
                    let reportAtt = Report(id: id as! String,
                                           userId: userId as! String,
                                           title: title as! String,
                                           description: description as! String,
                                           violenceKind: violenceKind as! String,
                                           violenceAproximatedTime: violenceAproximatedTime as! Double,
                                           latitude: latitude as! Double,
                                           longitude: longitude as! Double,
                                           personGender: personGender as! String)
                    
                    self.userReports.append(reportAtt)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        })
    }
}
