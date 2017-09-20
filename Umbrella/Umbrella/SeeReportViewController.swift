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
import MapboxGeocoder
class SeeReportViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var violenceTitleLbl: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPlace: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var violenceLocation: MGLMapView!
    @IBOutlet weak var violenceAproximateTime: UILabel!
    @IBOutlet weak var violenceDescription: UITextView!
    @IBOutlet weak var supportBtn: UIButton!
    @IBOutlet weak var supportersBtn: UIButton!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var comentaryCamp: UITextField!
    
    @IBOutlet weak var violenceDescriptionHeightConstraint: NSLayoutConstraint!
    
    
    //references
    var report:Report?
    let map = MapViewController()
    
    var refReport: DatabaseReference!
    var refComment: DatabaseReference!
    var refUser: DatabaseReference!
    var refUserSupport: DatabaseReference!
    var refMySupport: DatabaseReference!
    var refReportSupport: DatabaseReference!
    var refReportComplaint: DatabaseReference!
    var refInativeReport: DatabaseReference!
    
    var delegate: ReportDelegate?
    
    //comments to the report
    var comments:[Comment] = []
    
    let geocoder = Geocoder(accessToken: "pk.eyJ1IjoiaGVsZW5hc2ltb2VzIiwiYSI6ImNqNWp4bDBicDJpOTczMm9kaDJqemprbDcifQ.vdd9cfGAwcSXh1I7pq1mvA")
    
    override func viewDidLoad() {
        //database reference
        self.refComment =  Database.database().reference().child("comments")
        self.refReport =  Database.database().reference().child("reports")
        self.refUser = Database.database().reference().child("user")
        self.refUserSupport = Database.database().reference().child("user-support")
        self.refMySupport = Database.database().reference().child("my-support")
        self.refReportSupport = Database.database().reference().child("report-support")
        
        self.refReportComplaint = Database.database().reference().child("report-complaint")
        self.refInativeReport = Database.database().reference().child("inative-report")

        super.viewDidLoad()
        
        setSupportersButton()

        //recognizer para sumir o teclado quando o usuário clicar na tela
        dismissKayboardInTapGesture()

        //change the background color for the two views
        self.view.backgroundColor = .clear
        
        //init the components of the screen
        initLabels()
        
        // set the delegate of textFields
        self.comentaryCamp.delegate = self
        
        // sets the delegate to textView and tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //sets the color of the table to the same as the view
        self.tableView.backgroundColor = .clear
        //self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        self.violenceDescription.backgroundColor = .clear
        
        //observes the changes on the database
        setObserverToFireBaseChanges()
        
        //check if the user has already supported the report
        observeIfUserHasAlreadySupported()
        
        checkReportComplaint()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.inputAccessoryView?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.delegate?.getReportPopup().center = CGPoint(x: (self.delegate?.getReportPopup().center.x)!, y: (self.delegate?.getMapViewController().view.center.y)! - keyboardHeight)
            }, completion: nil)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.delegate?.getReportPopup().center = CGPoint(x: (self.delegate?.getReportPopup().center.x)!, y: (self.delegate?.getMapViewController().view.center.y)!)
        }, completion: nil)
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setSupportersButton() {
        if let xibView = Bundle.main.loadNibNamed("SupportersButton", owner: self, options: nil)?.first as? SupportersButton {
            
            supportersBtn.addSubview(xibView)
            xibView.translatesAutoresizingMaskIntoConstraints = false
            xibView.topAnchor.constraint(equalTo: supportersBtn.topAnchor).isActive = true
            xibView.leftAnchor.constraint(equalTo: supportersBtn.leftAnchor).isActive = true
            xibView.widthAnchor.constraint(equalTo: supportersBtn.widthAnchor).isActive = true
            xibView.heightAnchor.constraint(equalTo: supportersBtn.heightAnchor).isActive = true
        }
       
    }
    
    func initLabels() {
    
        let ref = self.refUser.child((self.report?.userId)!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let user = snapshot.value as? [String: Any] {
                self.username.text = user["nickname"] as? String
                
                if let url = user["urlPhoto"] as? String {
                    self.userPhoto.loadCacheImage(url)
                } else {
                    self.userPhoto.image = UIImage(named: "emailIcon")
                }
            }
        })
        self.userPhoto.layer.cornerRadius = userPhoto.bounds.size.width / 2
        
        self.violenceTitleLbl.text = self.report?.title
        
        self.violenceDescription.text = self.report?.description
        
        if let heightText = (violenceDescription.constraints.filter{$0.identifier == "violenceDescriptionHeightConstraint"}.first) {
            if self.violenceDescription.contentSize.height < 95 {
                heightText.constant = violenceDescription.contentSize.height
            }
            else {
                heightText.constant = 95
            }
        }
        self.violenceLocation.delegate = self
        self.getPlace(latitude: (report?.latitude)!, longitude: (report?.longitude)!) { (texts) in
            self.userPlace.text = "\(texts.first ?? "") - \(texts[1])"
        }
        self.violenceDescription.isEditable = false
        
        self.initiateLocationOnMap(map: self.violenceLocation, latitude: (report?.latitude)!, longitude: (report?.longitude)!)
        self.formatDate()
        
        setObserveToReportSupports(completion: { (usersId) in
            UserInteractor.getUsers(withIds: usersId!, completion: { (users) in
                self.report?.supporters = users!
                if let sub = self.supportersBtn.subviews.first as? SupportersButton {
                    sub.firstPhoto.isHidden = true
                    sub.secondPhoto.isHidden = true
                    sub.thirdPhoto.isHidden = true
                    let photos = [sub.firstPhoto, sub.secondPhoto, sub.thirdPhoto]
                    
                    if let supporters = self.report?.supporters {
                        let count = supporters.count < 3 ? supporters.count : 3 // aplicar mod de 3
                        
                        for aux in 0..<count {
                            
                            if let urlPhoto = supporters[aux].urlPhoto {
                                photos[aux]?.isHidden = false
                                photos[aux]?.loadCacheImage(urlPhoto)
                            }
                            sub.supportCount.text = count > 3 ? "+" + String(supporters.count - 3) : ""
                        }
                    }
                }
            })
        })

    }

    @IBAction func showAllSupports(_ sender: Any) {
     
        print("All sup = \(String(describing: self.report?.supporters))")
    }
    
    func initiateLocationOnMap(map: MGLMapView,latitude: Double, longitude: Double) {
        
      let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        map.setCenter(location, zoomLevel: 13, animated: true)
        
        map.showsUserLocation = false
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (latitude), longitude: (longitude) )
        annotation.title = self.report?.title
        self.violenceLocation.addAnnotation(annotation)
        

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

    @IBAction func closeButtonAction(_ sender: UIButton) {
        delegate?.closeReport()
    }
    
    //observer to the comment table on Firebase
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
        let content = self.comentaryCamp.text
        
        let comment = Comment(commentId: id, content: content!, reportId: reportId!, userId: userId!)
        
        print(comment.turnToDictionary())
        
        self.refComment.child(id).setValue(comment.turnToDictionary())

    }
    
    @IBAction func sendPrivateMessagesAction(_ sender: UIButton) {
        
        if UserInteractor.getCurrentUserUid() != nil {
            
            let sendMessage = UIAlertController(title: "Enviar Mensagem",
                                                message: "Você deseja mandar mensagem para a pessoa?",
                                                preferredStyle: .alert)
            
            sendMessage.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
                if let partnerId = self.report?.userId {
                    UserInteractor.getUser(withId: partnerId, completion: { (user) in
                        let chatController = ChatRouter.assembleModule()
                        chatController.presenter.partner = user
                        chatController.chatInputView.textField.text = "Eu estava presente no momento e gostaria de ajudar, posso?"
                        self.present(chatController, animated: true, completion: nil)
                    })
                }
            }))
            
            sendMessage.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(sendMessage, animated: true, completion: nil)
            
            
        } else {
            
            let logginAlert = UIAlertController(title: "E necessario loging",
                                                message: " Para poder mandar mensagens e necessario fazer login",
                                                preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "login", style: .default, handler: { (action) in
                
                self.performSegue(withIdentifier: "goToLogin", sender: Any.self)
                
            })
            
            logginAlert.addAction(loginAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            logginAlert.addAction(cancelAction)
            self.present(logginAlert, animated: true, completion: nil)
        }

        
    }
    
    /**
        Observer to the number of supports that a report has
    */
    
    func setObserverToFireBaseUserSupportTable() {
        //report id
        let reportId = self.report?.id
        
        //user id
        let userId = UserInteractor.getCurrentUserUid()
    
        //reference to the database table
        let databaseRef = self.refUserSupport.child(reportId!)
        
        self.refUserSupport.observe(.childAdded, with: { (snapshot) in
            
            let ref =  Database.database().reference().child("user-support").child(reportId!)
           
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let userSupport = snapshot.value as? [String : Any] {
                    do {
                            
                        guard let user =  userSupport[userId!] else {
                        
                                throw UserError.noUser
                            }
                    
                        if (user as! String)  == userId {
                        
                            //REMOVE A SUPPORT
                           
                            
                            //remove user to the user-support table
                            
                            databaseRef.child(userId!).removeValue()
                            self.refMySupport.child(userId!).child(reportId!).removeValue()
                            self.refReportSupport.child(reportId!).child(userId!).removeValue()
                            self.report?.supports = Int(snapshot.childrenCount) - 2
//                            self.supportLbl.text = String(describing:(self.report?.supports)!)
                            
                            //if the amount of support is = 0 the label should be hidden
                            if (self.report?.supports)! > 0 {
                                
//                                self.supportLbl.isHidden = false
                                
                            } else {
//                                self.supportLbl.isHidden = true
                            }
                            
                            self.refReport.child(reportId!).updateChildValues(self.report?.turnToDictionary() as! [AnyHashable : Any])
                            
                            let imageBtnBackground1 = UIImage(named: "heart-1") as UIImage?
                            self.supportBtn.setImage(imageBtnBackground1, for: .normal)

                            
                        }
                    } catch {
                        
                        //ADD A SUPPORT!
                        
                        // put the user into the user-support table
                        databaseRef.updateChildValues([userId!: userId!])
                        self.refMySupport.child(userId!).updateChildValues([reportId!: reportId!])
                        self.refReportSupport.child(reportId!).updateChildValues([userId!: userId!])
                        //incrise the amount of supports
                        self.report?.supports = Int(snapshot.childrenCount)
                        
                        self.refReport.child(reportId!).updateChildValues(self.report?.turnToDictionary() as! [AnyHashable : Any])
                        let imageBtnBackground = UIImage(named: "heart") as UIImage?
                        self.supportBtn.setImage(imageBtnBackground, for: .normal)
                    }
                }

            })
        })
    }
    
    /**
     Funcao para pegar as regiões de uma determinada coordenada
     
     - parameter latitude: Latitude em Double.
     - parameter longitude: Longitude em Double.
     - parameter onComplete: Bloco a ser executado ao fim da thread
     */
    func getPlace(latitude:Double,longitude:Double,onComplete: @escaping ([String]) -> ()){
        //
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        var returnStringArray:[String] = []
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            if error == nil{
                guard let placemark = placemarks?.first else {
                    return
                }
                
                let auxString = placemark.administrativeRegion?.code?.characters.split(separator: Character.init("-")).map(String.init)
                returnStringArray = [placemark.administrativeRegion?.name ?? "",auxString?[1] ?? "",auxString?[0] ?? ""]
                
                
                
                onComplete(returnStringArray)
            }
            
        }
        
    }
    
    func setObserveToReportSupports(completion: @escaping ([String]?) -> () = {_ in }) {
        var users: [String] = []
        
        self.refReportSupport.child((report?.id)!).observe(.value, with: { (snapshot) in
            if snapshot.value is NSNull {
                return
            }
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                users.append(snap.key)
            }
            completion(users)
            
        })
    }
    
    func observeIfUserHasAlreadySupported() {
        //report id
        let reportId = self.report?.id
        
        //user id
        let userId = UserInteractor.getCurrentUserUid()
        
        if userId != nil {
            
            self.refUserSupport.observe(.childAdded, with: { (snapshot) in
                
                let ref =  Database.database().reference().child("user-support").child(reportId!)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let userSupport = snapshot.value as? [String : Any] {
                        do {
                            
                            guard let user =  userSupport[userId!] else {
                                //print( "not here")
                                throw UserError.noUser
                            }
                            
                            if (user as! String)  == userId {
                                
                                
                                let imageBtnBackground = UIImage(named: "heart") as UIImage?
                                self.supportBtn.setImage(imageBtnBackground, for: .normal)
                                // self.supportLbl.text = String(describing: snapshot.childrenCount)
                                
                            }
                        } catch {
                        
                            
                        }
                    }
                    
                })
            })
        }
        
    }
    
    func checkReportComplaint() {
        
        self.refReportComplaint.observe(.childAdded, with: { (snapshot) in
            
            if snapshot.key == self.report?.id {
                
                if snapshot.childrenCount >= 1 {
                    //inativate Report
                    
                    self.report?.isActive = 1 // inactivate report
                    
                    //updateReportValue
                    self.refReport.child((self.report?.id)!).updateChildValues(self.report?.turnToDictionary() as! [AnyHashable : Any])
                    
                    //add report to the innactivated reports
                    self.refInativeReport.updateChildValues([(self.report?.id)!: (self.report?.id)!])
                
                    
                }

            }
        })
    }

    enum UserError: Error {
        case noUser
    }
   
    @IBAction func supportReportAction(_ sender: UIButton) {
        if UserInteractor.getCurrentUserUid() != nil {
            
            setObserverToFireBaseUserSupportTable()
            
        } else {
            
            let logginAlert = UIAlertController(title: "E necessario loging",
                                                message: " Para poder dar supporte para esse reporte e necessario fazer login",
                                                preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "login", style: .default, handler: { (action) in
                
                self.performSegue(withIdentifier: "goToLogin", sender: Any.self)
                
            })
            
            logginAlert.addAction(loginAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            logginAlert.addAction(cancelAction)
            self.present(logginAlert, animated: true, completion: nil)
        }
    }
    
     // MARK: - SupportAction
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
       
        let alert = UIAlertController(title: "Opções", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UmbrellaColors.lightPurple.color
        if UserInteractor.getCurrentUserUid() == self.report?.userId {
            alert.addAction(UIAlertAction(title: "Editar", style: .default, handler: { (alertAction) in
                
                self.performSegue(withIdentifier: "editReport", sender: Any.self)
            
            }))
        }else{
            alert.addAction(UIAlertAction(title: "Ligar Notificações", style: .default, handler: { (alertAction) in
                
            }))
            alert.addAction(UIAlertAction(title: "Reportar", style: .destructive, handler: { (alertAction) in
                
                self.complaintAReport()
                
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (alertAction) in
            self.removeFromParentViewController()
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    /**
        function to complaint about a report
     */
    func complaintAReport() {
        let userId = UserInteractor.getCurrentUserUid()
        
        if userId != nil {
            
            let reportAlert = UIAlertController(title: "Denunciar Relato", message: "Voce deseja realmente denunciar este relato?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Sim", style: .default) { (obj) in
                
                
                self.refReportComplaint.child((self.report?.id)!).updateChildValues([userId!:userId!])
                self.checkReportComplaint()
            }
            
            reportAlert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
            
            reportAlert.addAction(cancelAction)
            
            self.present(reportAlert, animated: true)
            
        } else {
            
            let logginAlert = UIAlertController(title: "E necessario loging",
                                                message: " Para poder dar supporte para esse reporte e necessario fazer login",
                                                preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "login", style: .default, handler: { (action) in
                
                self.performSegue(withIdentifier: "goToLogin", sender: Any.self)
                
                
                
            })
            
            logginAlert.addAction(loginAction)
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            logginAlert.addAction(cancelAction)
            self.present(logginAlert, animated: true, completion: nil)
            
            
        }
    }

}

extension SeeReportViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //setting cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as!
            CommentTableViewCell
        cell.backgroundColor = .clear
        //comment text
        let commentTextField = cell.commentContentView
        commentTextField?.isEditable = false
        commentTextField?.text = self.comments[indexPath.row].content
        commentTextField?.textColor = UIColor.white
        commentTextField?.backgroundColor = .clear
        
        //user photo to put into the comment cell
        let userPhoto = cell.userImage
        
        //comment nickname
        let userNickName = cell.userNameLabel
        userNickName?.textColor = UIColor.white
        
        
        let ref = self.refUser.child(self.comments[indexPath.row].userId)
        
        //setting user image and name to each comment
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
            if let user = snapshot.value as? [String: Any] {
                userNickName?.text = user["nickname"] as? String
                
                if let url = user["urlPhoto"] as? String {
                    userPhoto?.loadCacheImage(url)
                } else {
                    userPhoto?.image = UIImage(named: "emailIcon")
                }
            }
        })
        
        

        return cell
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if self.comments[indexPath.row].userId == UserInteractor.getCurrentUserUid() || self.report?.userId == UserInteractor.getCurrentUserUid() {
        
            let deleteWarning = UIAlertController(title: "Apagar Comentário",
                                              message: "Você realmente deseja apagar esse comentário?",
                                              preferredStyle: .alert)
        
            deleteWarning.addAction(UIAlertAction(title: "Deletar", style: .destructive,
                                              handler: { (action) in
                                                
                                                let commentToDelete = self.comments[indexPath.row].commentId
                                                self.comments.remove(at: indexPath.row)
                                                self.refComment.child(commentToDelete).setValue(nil)
                                                tableView.reloadData()
            }))
        
        
            deleteWarning.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel,
                                              handler:nil))
        
            self.present(deleteWarning, animated: true, completion: nil)

        
        } else {
            
            let imposibleToDeleteWarning = UIAlertController(title: "O comentário não é seu",
                                                             message: "Você só pode deletar os seus comentários!",
                                                             preferredStyle: .alert)
            
            imposibleToDeleteWarning.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(imposibleToDeleteWarning, animated: true, completion: nil)
        }
    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SeeReportViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == comentaryCamp {
            addComent()
        }
        
        textField.text?.removeAll()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
