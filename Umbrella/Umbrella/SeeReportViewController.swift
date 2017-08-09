//
//  SeeReportViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 31/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Mapbox
class SeeReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //outlets
    @IBOutlet weak var agression: UILabel!
    @IBOutlet weak var editReportBtn: UIButton!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var violanceLocation: MGLMapView!
    @IBOutlet weak var violenceAproximateTime: UILabel!
    @IBOutlet weak var violenceDescription: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    
    
    //references
    var report:Report?
    let map = MapViewController()
    
    var refReport: DatabaseReference!
    var refComment: DatabaseReference!
    
    //comments to the report
    var comments:[Comment] = []
    
    
    override func viewDidLoad() {
        self.refComment =  Database.database().reference().child("comments")
        self.refReport =  Database.database().reference().child("reports")
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)

        
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        initLabels()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setObserverToFireBaseChanges()
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func initLabels() {
        self.agression.text = self.report?.violenceKind
        self.violenceDescription.text = self.report?.description
        self.violenceDescription.isEditable = false
        self.username.text = "Joelson"
        self.cityName.text = "Taguayork"
        self.initiateLocationOnMap(map: self.violanceLocation, latitude: (report?.latitude)!, longitude: (report?.longitude)!)
        self.formatDate()
    }
    
    func initiateLocationOnMap(map: MGLMapView,latitude: Double, longitude: Double) {
        
      var location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        map.setCenter(location, zoomLevel: 13, animated: true)
        
        map.showsUserLocation = false
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (self.report?.latitude)!, longitude: (self.report?.longitude)! )
        annotation.title = self.report?.title
        self.violanceLocation.addAnnotation(annotation)

    }
    
    func formatDate () {
        //getting the data to format the date
        let startDate = Date(timeIntervalSince1970: (self.report?.violenceAproximatedTime)!)
        
        //format
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"
        
        //setting the formated date
        self.violenceAproximateTime.text = dateFormat.string(from: startDate)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editReport" {
            if let editScreen = segue.destination as? RegisterReportViewController {
                editScreen.reportToEdit = self.report
            }
        }
    }

    
    
    @IBAction func editReport(_ sender: Any) {
        performSegue(withIdentifier: "editReport", sender: Any?.self)
    }
    
    @IBAction func deleteReport(_ sender: Any) {
        
        let deleteWarning = UIAlertController(title: "Delete",
                                              message: "Are you sure you want to delete it?",
                                              preferredStyle: .alert)
        deleteWarning.addAction(UIAlertAction(title: "Delete", style: .destructive,
                                              handler: { (action) in
                                                
                                                let reportToDelete = self.report?.id
                                                self.map.reports.remove(at: self.getReportIndexInArray(report: self.report!))
                                                self.refReport.child(reportToDelete!).setValue(nil)
        }))
        
        
        deleteWarning.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,
                                              handler:nil))
        
        self.present(deleteWarning, animated: true, completion: nil)

    }
    
    func getReportIndexInArray(report: Report) -> Int {
        
        var counter = 0
        
        for report in self.map.reports {
            if report.id == self.map.reports[counter].id {
                return counter
            } else {
                counter += 1
            }
            
        }
        //if there is an error it will crash because the report was not found and a negative value was returned 
        return -1
    }

    func setObserverToFireBaseChanges() {
        
        self.refComment.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.comments.removeAll()
                
                for comment in snapshot.children.allObjects as![DataSnapshot]{
                    let commentObj = comment.value as? [String: AnyObject]
                    
                    let id = commentObj?["commentId"]
                    let content = commentObj?["content"]
                    let reportId = commentObj?["reportId"]
                    let userId = commentObj?["userId"]
                    
                    if (reportId as! String) == self.report?.id {
                        
                        let comment = Comment(commentId: id as! String,
                                          content: content as! String,
                                          reportId: reportId as! String,
                                          userId: userId as! String)
                        self.comments.append(comment)
                        
                    } else {
                        //DOES NOTHING
                    }
                }
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                
            }
        })
        
        
    }
    
    @IBAction func sendComment(_ sender: Any) {
        
        addComent()
    
    }
    
    func addComent() {
        
        let id = refComment.childByAutoId().key
        let reportId = self.report?.id
        let userId = "userIdComing"
        let content = self.commentTextView.text
        
        let comment = Comment(commentId: id, content: content!, reportId: reportId!, userId: userId)
        
        print(comment.turnToDictionary())
        
        self.refComment.child(id).setValue(comment.turnToDictionary())
        self.commentTextView.text = ""

    }

}

extension SeeReportViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath)
        let commentTextField = tableView.viewWithTag(2) as! UITextView
        commentTextField.isEditable = false
        commentTextField.text = self.comments[indexPath.row].content
        
        let userPhoto = tableView.viewWithTag(1) as! UIImageView
        
        //colocar imagem do usuário
        //userPhoto.image =
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
