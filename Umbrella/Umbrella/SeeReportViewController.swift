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

class SeeReportViewController: UIViewController {
    
    //outlets
    
//    @IBOutlet var commentView: UIView!
//    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var violenceTitleLbl: UILabel!
    @IBOutlet weak var agression: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var violanceLocation: MGLMapView!
    @IBOutlet weak var violenceAproximateTime: UILabel!
    @IBOutlet weak var violenceDescription: UITextView!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var commentTextView: UITextView!
//    @IBOutlet weak var sendComment: UIButton!
//    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    
    //references
    var report:Report?
    let map = MapViewController()
    let commentView = CommentView()
    
    var refReport: DatabaseReference!
    var refComment: DatabaseReference!
    var refUser: DatabaseReference!
    
    //comments to the report
    var comments:[Comment] = []
    
    
    override func viewDidLoad() {
        //database reference
        self.refComment =  Database.database().reference().child("comments")
        self.refReport =  Database.database().reference().child("reports")
        self.refUser = Database.database().reference().child("user")
        super.viewDidLoad()
        
        
        //recognizer para sumir o teclado quando o usuário clicar na tela
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        //change the background color for the two views
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
        //init the components of the screen
        initLabels()
        initTexViewLabel()
        
        // sets the delegate to textView and tableView
        self.commentView.textView.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //sets the color of the table to the same as the view
        self.tableView.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        self.headerView.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
//        self.footerView.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
        //observes the changes on the database
        setObserverToFireBaseChanges()
        
    }
    
    override var inputAccessoryView: UIView? {
        get{
            
            commentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            commentView.sendCommentButton.addTarget(self, action: #selector(addComent), for: .touchUpInside)
            
            return self.commentView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func initLabels() {
    
        let ref = self.refUser.child((self.report?.userId)!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let user = snapshot.value as? [String: Any]
            self.username.text = user?["nickname"] as? String
            self.userPhoto.loadCacheImage((user?["urlPhoto"] as? String)!)
        })

        self.username.textColor = UIColor.white
        
        self.violenceTitleLbl.text = self.report?.title
        self.violenceTitleLbl.textColor = UIColor.white
        
        self.agression.text = self.report?.violenceKind
        self.agression.textColor = UIColor.white
        
        self.violenceDescription.text = self.report?.description
        //self.violenceDescription.textColor = UIColor.white
        
        self.violenceDescription.isEditable = false
        self.violenceDescription.backgroundColor = UIColor(colorLiteralRed: 0.107,
                                                           green: 0.003,
                                                           blue: 0.148,
                                                           alpha: 1)
        
        self.initiateLocationOnMap(map: self.violanceLocation, latitude: (report?.latitude)!, longitude: (report?.longitude)!)
        self.formatDate()
    }
    
    //initial placeholder to the textView of comments
    func initTexViewLabel() {
        self.commentView.textView.text = "Insira um comentário"
        self.commentView.textView.textColor = UIColor.lightGray
    }
    
    
    func initiateLocationOnMap(map: MGLMapView,latitude: Double, longitude: Double) {
        
      let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
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
        self.violenceAproximateTime.textColor = UIColor.white
        
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
    
    func addComent() {
        
        let id = refComment.childByAutoId().key
        let reportId = self.report?.id
        let userId = UserInteractor.getCurrentUserUid()
        let content = self.commentView.textView.text
        
        let comment = Comment(commentId: id, content: content!, reportId: reportId!, userId: userId!)
        
        print(comment.turnToDictionary())
        
        self.refComment.child(id).setValue(comment.turnToDictionary())
        self.commentView.textView.text = ""

    }

}

extension SeeReportViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //setting cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath)
        cell.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
        //comment text
        let commentTextField = tableView.viewWithTag(2) as! UITextView
        commentTextField.isEditable = false
        commentTextField.text = self.comments[indexPath.row].content
        commentTextField.textColor = UIColor.white
        commentTextField.backgroundColor = UIColor(colorLiteralRed: 0.107, green: 0.003, blue: 0.148, alpha: 1)
        
        //user photo to put into the comment cell
        let userPhoto = tableView.viewWithTag(1) as! UIImageView
        
        //comment nickname
        let userNickName = tableView.viewWithTag(8) as! UILabel
        userNickName.textColor = UIColor.white
        
        
        let ref = self.refUser.child(self.comments[indexPath.row].userId)
        
        //setting user image and name to each comment
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
            let user = snapshot.value as? [String: Any]
                userNickName.text = user?["nickname"] as? String
                userPhoto.loadCacheImage((user?["urlPhoto"] as? String)!)
        })
        
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

//extension to the textView get a placeHolder
extension SeeReportViewController: UITextViewDelegate {
 
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            
            textView.text = "Insira seu comentário"
            textView.textColor = UIColor.lightGray
            
        }
    }
}
