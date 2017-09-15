//
//  MapViewController.swift
//  Umbrella
//
//  Created by Geovanni Oliveira de Jesus on 27/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import Foundation
import UIKit
import Mapbox
import MapboxGeocoder
import GoogleMobileAds
import Firebase

class MapViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var msgsButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var perfilButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var filterTable: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var searchTableView: UITableView!
    
    //MARK: - Constrains
    @IBOutlet weak var horizontalMsgContrain: NSLayoutConstraint!
    @IBOutlet weak var spaceToBanner: NSLayoutConstraint!
    
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var horizontalProfileConstrain: NSLayoutConstraint!
    @IBOutlet weak var verticalMsgConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var verticalProfileConstrain: NSLayoutConstraint!
    @IBOutlet weak var verticalReportConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var verticalExpadButtonConstrain: NSLayoutConstraint!
    
    var horizontalMsgButtonValue:CGFloat = CGFloat()
    var verticalMsgButtonValue:CGFloat = CGFloat()
    
    var verticalReportButtonValue:CGFloat = CGFloat()
    
    var horizontalProfileButtonValue:CGFloat = CGFloat()
    var verticalProfileButtonValue:CGFloat = CGFloat()
    //MARK: - others
    
    var querryResults:[GeocodedPlacemark] = []
    var filtros:[String] = []
    var locationManager = CLLocationManager()
    var reports: [Report] = []
    var refReports : DatabaseReference!
    var reportToSend:Report?
    var containerViewController: FilterTableViewControlleTableViewController?
    var buttonDistance:CGFloat = CGFloat()
    var msgCenter:CGPoint = CGPoint()
    var perfilCenter:CGPoint = CGPoint()
    var reportCenter:CGPoint = CGPoint()
    
    var gestures: [UIGestureRecognizer] = []
    let firstPopup = PopUpPresenter()
    let secondPopup = PopUpPresenter()
    let reportPopup = PopUpPresenter()
    
    let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
    let geocoder = Geocoder(accessToken: "pk.eyJ1IjoiaGVsZW5hc2ltb2VzIiwiYSI6ImNqNWp4bDBicDJpOTczMm9kaDJqemprbDcifQ.vdd9cfGAwcSXh1I7pq1mvA")
    let image = UIImage(named: "CustomLocationPIN")
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
       
      
        getPrimaryConstantsValue()
        dismissKayboardInTapGesture()
        bannerView.delegate = self
 
       
        filterTable.isHidden = true
        hide(duration: 0)
        //Remove bussola do mapa
        mapView.compassView.removeFromSuperview()
        
        self.refReports =  Database.database().reference().child("reports")
        setObserverToFireBaseChanges()
       
        //Requisitando propagandas e setando os devices
        let request = GADRequest()
        filterTable.isHidden = true
        request.testDevices = ["asdasd"]
        bannerView.adUnitID = "ca-app-pub-1296835094216265/5601148764"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        //Configurando searchBar e cllocation
        locationCheck()
        tableViewConstruct()
        searchBarConfig()
        
        mapView.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.centerOnUser),
            name:NSNotification.Name.init(rawValue: "AuthorizationAccepted"),
            object: nil
        )
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            centerOnUser()
        }
        
        addBlurView()
        setPopUp()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        
    }
    //MARK: - Buttons functions
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hide(duration: 0.5)
        self.expandButton.isSelected = false
    }
    
//    func snapShotImage() -> UIImage {
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        if let context = UIGraphicsGetCurrentContext() {
//            self.view.layer.render(in: context)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return image!
//        }
//        
//        return UIImage()
//    }
    
    func addBlurView() {
        
        self.blurEffectView.frame = self.view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.subviews.last?.isHidden = true
    }
    
    @IBAction func expandAction(_ sender: UIButton) {
        //Verifica se o Usuario ja está logado.
        if UserInteractor.getCurrentUserUid() == nil {
            //Adiciona Alerta para redirecionar ao login.
            let alertControler = UIAlertController(title: "Atenção", message: "Por favor faça o login para poder acessar as opçoes de relato.", preferredStyle: .alert)
            
            alertControler.addAction(UIAlertAction(title: "Logar", style: .default, handler: { (UIAlertAction) in
                
                let controller = LoginRouter.assembleModule()
                self.present(controller, animated: true, completion: nil)
                //                self.performSegue(withIdentifier: "goToLogin", sender: nil)
                
            }))
            alertControler.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { (UIAlertAction) in
                
            }))
            
            self.present(alertControler, animated: true, completion: nil)
        }else{
            //Faz animação caso esteja logado.
            if !sender.isSelected {
                expand(duration: 0.5)
                sender.isSelected = true
            }else{
                hide(duration: 0.5)
                sender.isSelected = false
            }
        }
    }
    
    
    func expand(duration:Double){
        expandButton.isEnabled = false
        
        self.verticalReportConstrain.constant = self.verticalReportButtonValue
        
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            self.reportButton.alpha = 1
            
            
        }) { (sucess) in
            self.verticalProfileConstrain.constant = self.verticalProfileButtonValue
            self.horizontalProfileConstrain.constant = self.horizontalProfileButtonValue
            
            self.verticalMsgConstrain.constant = self.verticalMsgButtonValue
            self.horizontalMsgContrain.constant = self.horizontalMsgButtonValue
            
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
                
                self.msgsButton.alpha = 1
                self.perfilButton.alpha = 1
                
            }){ (sucess) in
                self.expandButton.isEnabled = true
                
            }
        }
    }
    
    
    func getPrimaryConstantsValue(){
        horizontalMsgButtonValue = horizontalMsgContrain.constant
        verticalMsgButtonValue = verticalMsgConstrain.constant
        
        verticalReportButtonValue = verticalReportConstrain.constant
        
        horizontalProfileButtonValue = horizontalProfileConstrain.constant
        verticalProfileButtonValue = verticalProfileConstrain.constant
        
    }
    
    
    func hide(duration:Double){
        expandButton.isEnabled = false
        
        verticalProfileConstrain.constant = 0 - perfilButton.frame.height
        horizontalProfileConstrain.constant = 0 - perfilButton.frame.width
        
        verticalMsgConstrain.constant = 0 - msgsButton.frame.height
        horizontalMsgContrain.constant = 0 - msgsButton.frame.width
        
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            
            self.msgsButton.alpha = 0
            self.perfilButton.alpha = 0
            
        }) { (sucess) in
            self.verticalReportConstrain.constant = 0 - self.reportButton.frame.height
            
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
                self.reportButton.alpha = 0
            }){ (sucess) in
                self.expandButton.isEnabled = true
                
            }
        }
        
    }

    @IBAction func profileButtonAction(_ sender: Any) {
        
        performSegue(withIdentifier: "ProfileSegue", sender: nil)
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {

        let view = MessagesRouter.assembleModule()
        present(view, animated: true, completion: nil)
    }
    
    @IBAction func locatioButtonAction(_ sender: UIButton) {
        centerOnUser()
    }
    //MARK: - config functions
    func setUpExpandConstrain(){
        if bannerView.isHidden {
            //verticalExpadButtonConstrain.constant -= bannerView.frame.height
            spaceToBanner.constant = -1 * bannerHeight.constant
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            spaceToBanner.constant = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    
    func searchBarConfig(){
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
    }
    
    func locationCheck(){
        locationManager.delegate = self
        self.authorizationStatusCheck()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
    }
    
    func tableViewConstruct(){

        searchTableView.restorationIdentifier = "SearchTableView"
        searchTableView.delegate = self
        searchTableView.dataSource = self
        self.searchTableView.isHidden = true
        searchTableView.allowsSelection = false
        searchTableView.layer.cornerRadius = 10
    }
    
    
    
    func tapCel(sender:UITapGestureRecognizer)  {
        //using sender, we can get the point in respect to the table view
        let tapLocation = sender.location(in: self.searchTableView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.searchTableView.indexPathForRow(at: tapLocation)
        mapView.setCenter(querryResults[(indexPath?.row)! ].location.coordinate, zoomLevel: 10, animated: true)
        searchBar.text = querryResults[(indexPath?.row)! ].name
        
        
    }
    


//    func filterContentForSearchText(searchText: String, scope: String = "All") {
//        let options = ForwardGeocodeOptions(query: searchText)
//                _ = geocoder.geocode(options) { (placemarks, attribution, error) in
//                   // self.querryResults = placemarks!
//                    self.querryResults = placemarks!.filter { placemark in
//                        return placemark.name.lowercased().contains(searchText.lowercased())
//                    }
//                }
//        
//        
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Transforma o texto do usuario em coordenadas e da reload na table.
        let options = ForwardGeocodeOptions(query: searchText)
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            if(placemarks != nil){
                self.querryResults = placemarks!
                self.searchTableView.reloadData()
                self.searchTableView.isHidden = false
            }else{
                self.searchTableView.isHidden = true
            }
            
        }
    
    }
    
    
    func handleMsgsButtonAction(){
        
        let navigation = UINavigationController(rootViewController: MessagesTableViewController())
        present(navigation, animated: true, completion: nil)
    }
    
    /**
     Funcao para ativar interação com o mapa atrás do filtro,esconder a view e que remove o observer para escondelo.
     */
    func closeFilter(){
        filterTable.isHidden = true
        self.mapView.allowsZooming = true
        self.mapView.allowsRotating = true
        self.mapView.allowsScrolling = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)
            
    }

    /**
     Funcao para desativar interação com o mapa atrás do filtro e que cria um observer para escondelo.
     
     - parameter sender: Botão de filtro.
     
     */
    @IBAction func filterActivate(_ sender: UIButton) {
        self.mapView.allowsZooming = false
        self.mapView.allowsRotating = false
        self.mapView.allowsScrolling = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeFilter), name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)
        
        filterTable.isHidden = false
    }
    /**
     Funcao para adicionar somente pins filtrados
     
     - parameter new: Report a ser verificado.
 
     */
    func filter(new:Report){
    
        if(!filtros.isEmpty){
            
          //  removePins()
            for filtro in filtros{
               // for report in reports{
                    if new.violenceKind.lowercased() == filtro.lowercased(){
                        addPin(new: new)
                        
                    }
               // }
            
            }
        }else{
           addPin(new: new)
        }
        
        
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
            if error != nil{
                guard let placemark = placemarks?.first else {
                    return
                }
                
                let auxString = placemark.administrativeRegion?.code?.characters.split(separator: Character.init("-")).map(String.init)
                returnStringArray = [placemark.administrativeRegion?.name ?? "",auxString?[1] ?? "",auxString?[0] ?? ""]
                
                
                
                onComplete(returnStringArray)
            }
            
        }
       
    }
    
    
    @IBAction func reportButtonAction(_ sender: UIButton) {
        self.firstPopup.isHidden = false
        self.secondPopup.isHidden = false
        changeBannerVisibility()
        changeBlurViewVisibility()
        insertFirstReportView()
        insertSecondReportView()
    }
    
    func showReport() {
        self.reportPopup.isHidden = false
        changeBannerVisibility()
        changeBlurViewVisibility()
        insertSeeReportView()
    }

    
    func setPopUp() {
        firstPopup.prepare(view: view,
                      popUpFrame: CGRect(x: 10, y: 26, width: self.view.frame.width - 20, height: self.view.frame.height - 36),
                      blurFrame: nil,
                      popUpColor: UmbrellaColors.blackPurple.color.withAlphaComponent(0.7))
        firstPopup.isHidden = true
        
        secondPopup.prepare(view: view,
                        popUpFrame: CGRect(x: self.view.frame.width + 10, y: 26, width: self.view.frame.width - 20, height: self.view.frame.height - 36),
                        blurFrame: nil,
                        popUpColor: UmbrellaColors.blackPurple.color.withAlphaComponent(0.7))
        secondPopup.isHidden = true
        
        reportPopup.prepare(view: view,
                        popUpFrame: CGRect(x: 10, y: 26, width: self.view.frame.width - 20, height: self.view.frame.height - 36),
                        blurFrame: nil,
                        popUpColor: UmbrellaColors.blackPurple.color.withAlphaComponent(0.7))
        reportPopup.isHidden = true
        
        let firstGesture = UIPanGestureRecognizer(target: self, action: #selector(firstPopupWasDragged(gestureRecognizer:)))
        firstPopup.popUpView.addGestureRecognizer(firstGesture)
        firstGesture.delegate = self
        firstPopup.popUpView.isUserInteractionEnabled = true
        gestures.append(firstGesture)
        
        let secondGesture = UIPanGestureRecognizer(target: self, action: #selector(secondPopupWasDragged(gestureRecognizer:)))
        secondPopup.popUpView.addGestureRecognizer(secondGesture)
        secondPopup.popUpView.isUserInteractionEnabled = true
        secondGesture.delegate = self
        gestures.append(secondGesture)
    }
    
    func firstPopupWasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: self.view)
        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            
            //print(gestureRecognizer.view!.center.x)
            gestureRecognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            
            if(gestureRecognizer.view!.center.x < 200) {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
                secondPopup.popUpView.center = CGPoint(x: secondPopup.popUpView.center.x + translation.x, y: secondPopup.popUpView.center.y)
            }else {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x - (translation.x / 1.5), y: gestureRecognizer.view!.center.y)
                secondPopup.popUpView.center = CGPoint(x: secondPopup.popUpView.center.x + translation.x + self.view.frame.size.width - (translation.x / 1.5), y: secondPopup.popUpView.center.y)
            }
        
        }
        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                if(gestureRecognizer.view!.center.x < 0) {
                    gestureRecognizer.view!.center = CGPoint(x: self.view.center.x - self.view.frame.size.width, y: gestureRecognizer.view!.center.y)
                    self.secondPopup.popUpView.center = CGPoint(x: self.view.center.x, y: self.secondPopup.popUpView.center.y)
                }
                else {
                    gestureRecognizer.view!.center = CGPoint(x: self.view.center.x, y: gestureRecognizer.view!.center.y)
                    self.secondPopup.popUpView.center = CGPoint(x: self.view.center.x + self.view.frame.size.width, y: self.secondPopup.popUpView.center.y)
                    
                }
            }, completion: nil)
        }
        
    }

    func secondPopupWasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)

        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            
            //print(gestureRecognizer.view!.center.x)
            gestureRecognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            
            if(gestureRecognizer.view!.center.x > 185) {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
                firstPopup.popUpView.center = CGPoint(x: firstPopup.popUpView.center.x + translation.x, y: firstPopup.popUpView.center.y)
            }else {
                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x - (translation.x / 1.5), y: gestureRecognizer.view!.center.y)
                firstPopup.popUpView.center = CGPoint(x: firstPopup.popUpView.center.x + translation.x - self.view.frame.size.width - (translation.x / 1.5), y: firstPopup.popUpView.center.y)
            }
            
        }
        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                if(gestureRecognizer.view!.center.x > 375) {
                    gestureRecognizer.view!.center = CGPoint(x: self.view.center.x + self.view.frame.size.width, y: gestureRecognizer.view!.center.y)
                    self.firstPopup.popUpView.center = CGPoint(x: self.view.center.x, y: self.firstPopup.popUpView.center.y)
                }
                else {
                    gestureRecognizer.view!.center = CGPoint(x: self.view.center.x, y: gestureRecognizer.view!.center.y)
                    self.firstPopup.popUpView.center = CGPoint(x: self.view.center.x - self.view.frame.size.width, y: self.firstPopup.popUpView.center.y)
                }
            }, completion: nil)
        }
        
        
        
    }
    
    func insertFirstReportView() {
        
        if let reportController = UIStoryboard(name: "RegisterReportFirst", bundle: nil).instantiateViewController(withIdentifier: "RegisterReportViewController") as? RegisterReportViewController {
            
            addChildViewController(reportController)
            reportController.delegate = self
            
            let reportView = (reportController.view)!
            firstPopup.popUpView.addSubview(reportView)
            
            reportController.didMove(toParentViewController: self)
            
            reportView.translatesAutoresizingMaskIntoConstraints = false
            reportView.topAnchor.constraint(equalTo: firstPopup.popUpView.topAnchor).isActive = true
            reportView.leftAnchor.constraint(equalTo: firstPopup.popUpView.leftAnchor).isActive = true
            reportView.widthAnchor.constraint(equalTo: firstPopup.popUpView.widthAnchor).isActive = true
            reportView.heightAnchor.constraint(equalTo: firstPopup.popUpView.heightAnchor).isActive = true
            reportView.backgroundColor = .clear

        }
    }
    
    
    func insertSecondReportView() {
        
        if let reportController = UIStoryboard(name: "RegisterReportSecond", bundle: nil).instantiateViewController(withIdentifier: "RegisterReportSecondViewController") as? RegisterReportSecondViewController {
            
            addChildViewController(reportController)
            reportController.delegate = self
            
            let reportView = (reportController.view)!
            secondPopup.popUpView.addSubview(reportView)
            
            reportController.didMove(toParentViewController: self)
            
            reportView.translatesAutoresizingMaskIntoConstraints = false
            reportView.topAnchor.constraint(equalTo: secondPopup.popUpView.topAnchor).isActive = true
            reportView.leftAnchor.constraint(equalTo: secondPopup.popUpView.leftAnchor).isActive = true
            reportView.widthAnchor.constraint(equalTo: secondPopup.popUpView.widthAnchor).isActive = true
            reportView.heightAnchor.constraint(equalTo: secondPopup.popUpView.heightAnchor).isActive = true
            reportView.backgroundColor = .clear
            
        }
    }
    
    func insertSeeReportView() {
        if let reportController = UIStoryboard(name: "SeeReport", bundle: nil).instantiateViewController(withIdentifier: "SeeReportViewController") as? SeeReportViewController {
            
            addChildViewController(reportController)
            reportController.delegate = self
            reportController.report = self.reportToSend
            
            let reportView = (reportController.view)!
            reportPopup.popUpView.addSubview(reportView)
            
            reportController.didMove(toParentViewController: self)
            
            reportView.translatesAutoresizingMaskIntoConstraints = false
            reportView.topAnchor.constraint(equalTo: reportPopup.popUpView.topAnchor).isActive = true
            reportView.leftAnchor.constraint(equalTo: reportPopup.popUpView.leftAnchor).isActive = true
            reportView.widthAnchor.constraint(equalTo: reportPopup.popUpView.widthAnchor).isActive = true
            reportView.heightAnchor.constraint(equalTo: reportPopup.popUpView.heightAnchor).isActive = true
            reportView.backgroundColor = .clear
            
        }

    }
    

    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "containerViewSegue" {
            containerViewController = segue.destination as? FilterTableViewControlleTableViewController
            containerViewController!.containerToMaster = self
        }
//        else if segue.identifier == "seeReport"{
//            if let seeScreen = segue.destination as? SeeReportViewController {
//                seeScreen.report = self.reportToSend
//            }
//            
//        }
    }
    func setChangedObserver(){
        self.refReports.observe(.childChanged, with: { (snapShot) in
            let snapShotValue = snapShot.value as! Dictionary<String,Any>
            
            let id = snapShotValue["id"]! as! String
        
            let element:Report? = self.reports.first(){
                $0.id == id
            }
            if element != nil {
                element?.userId = snapShotValue["userId"]! as! String
                element?.title = snapShotValue["title"]! as! String
                element?.description =  snapShotValue["description"]! as! String
                element?.violenceKind = snapShotValue["violenceKind"]! as! String
                element?.violenceAproximatedTime = snapShotValue["violenceAproximatedTime"] as! Double
                element?.latitude = snapShotValue["latitude"] as! Double
                element?.longitude = snapShotValue["longitude"] as! Double
                element?.personGender = snapShotValue["personGender"]! as! String
                element?.supports = snapShotValue["supports"]! as! Int
                element?.isActive = snapShotValue["isActive"]! as! Int
            }
          
            
            
                
            
            //self.reports = newArray
        })
    }
    func setAddObserverFireBase(){
        
        self.refReports.observe(.childAdded, with: { (snapShot) in
            let snapShotValue = snapShot.value as! Dictionary<String,Any>
            
            if let isActive = snapShotValue["isActive"] {
                let newReport = Report(id: snapShotValue["id"]! as! String,
                                       userId: snapShotValue["userId"]! as! String,
                                       title: snapShotValue["title"]! as! String,
                                       description: snapShotValue["description"]! as! String,
                                       violenceKind: snapShotValue["violenceKind"]! as! String,
                                       violenceAproximatedTime: snapShotValue["violenceAproximatedTime"] as! Double,
                                       latitude: snapShotValue["latitude"] as! Double,
                                       longitude: snapShotValue["longitude"] as! Double,
                                       personGender: snapShotValue["personGender"]! as! String,
                                       supports: snapShotValue["supports"]! as! Int,
                                       isActive: snapShotValue["isActive"]! as! Int)
                
                self.reports.append(newReport)
                self.filter(new:newReport)
            }
           

        })
    }
    func setRemoveObserver(){
        self.refReports.observe(.childRemoved, with: { (snapShot) in
            let snapShotValue = snapShot.value as! Dictionary<String,Any>
            let id = snapShotValue["id"] as! String
            let newArray = self.reports.filter(){
               $0.id != id
            }
            
            self.reports = newArray
            self.removePins()
            self.addPins(reports: newArray)
        })
    }
    func getReports(){
        
    }
    

    func setObserverToFireBaseChanges() {
//        self.refReports.observe(DataEventType.value, with: {(snapshot) in
//            if snapshot.childrenCount > 0 {
//                self.reports.removeAll()
//                self.removePins()
//                for report in snapshot.children.allObjects as![DataSnapshot]{
//                    let reportObj = report.value as? [String: AnyObject]
//                    
//                    let id = reportObj?["id"]
//                    let userId = reportObj?["userId"]
//                    let title = reportObj?["title"]
//                    let description = reportObj?["description"]
//                    let violenceKind = reportObj?["violenceKind"]
//                    let violenceAproximatedTime = reportObj?["violenceAproximatedTime"]
//                    let latitude = reportObj?["latitude"]
//                    let longitude = reportObj?["longitude"]
//                    let personGender = reportObj?["personGender"]
//                    let supports = reportObj?["supports"]
//                    
//                    var reportAtt:Report?
//                    
//                    if supports != nil {
//                        
//                        reportAtt = Report(id: id as! String,
//                                           userId: userId as! String,
//                                           title: title as! String,
//                                           description: description as! String,
//                                           violenceKind: violenceKind as! String,
//                                           violenceAproximatedTime: violenceAproximatedTime as! Double,
//                                           latitude: latitude as! Double, longitude: longitude as! Double,
//                                           personGender: personGender as! String,
//                                           supports: supports as! Int)
//                    } else {
//                        reportAtt = Report(id: id as! String,
//                                           userId: userId as! String,
//                                           title: title as! String,
//                                           description: description as! String,
//                                           violenceKind: violenceKind as! String,
//                                           violenceAproximatedTime: violenceAproximatedTime as! Double,
//                                           latitude: latitude as! Double,
//                                           longitude: longitude as! Double,
//                                           personGender: personGender as! String)
//                    }
//                    
//                    
//                    self.reports.append(reportAtt!)
//                    self.filter(new: reportAtt!)
//                }
//                
//            }
//        })
        setChangedObserver()
        setAddObserverFireBase()
        setRemoveObserver()
    }
    

}

extension MapViewController: ReportDelegate {
    func changeBannerVisibility() {
        if bannerView.isHidden == true {
            self.bannerView.isHidden = false
        }
        else {
            self.bannerView.isHidden = true
        }
    }
    
    func changeBlurViewVisibility() {
        if blurEffectView.isHidden == false {
            blurEffectView.isHidden = true
        }
        else {
            blurEffectView.isHidden = false
        }
        
    }
    
    func getFirstPopup() -> UIView {
        return self.firstPopup.popUpView
    }
    
    func getSecondPopup() -> UIView {
        return self.secondPopup.popUpView
    }
    
    func getReportPopup() -> UIView {
        return self.reportPopup.popUpView
    }
    
    func closeReport() {
        changeBannerVisibility()
        changeBlurViewVisibility()
        
        if firstPopup.isHidden == false {
            firstPopup.isHidden = true
            secondPopup.isHidden = true
            for sub in firstPopup.popUpView.subviews {
                sub.removeFromSuperview()
            }
            for sub in secondPopup.popUpView.subviews {
                sub.removeFromSuperview()
            }
        }
        else if reportPopup.isHidden == false {
            reportPopup.isHidden = true
            for sub in reportPopup.popUpView.subviews {
                sub.removeFromSuperview()
            }
        }
        
    }
    
    func getChildViewControllers() -> [UIViewController] {
        return self.childViewControllers
    }
    
    func getMapViewController() -> UIViewController {
        return self
    }
    
    func getGestures() -> [UIGestureRecognizer] {
        return gestures
    }
}
