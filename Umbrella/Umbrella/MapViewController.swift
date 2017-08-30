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

class MapViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var msgsButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var perfilButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var filterTable: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var HorizontalStackButtons: UIStackView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var searchTableView: UITableView!
    
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
   
    let geocoder = Geocoder(accessToken: "pk.eyJ1IjoiaGVsZW5hc2ltb2VzIiwiYSI6ImNqNWp4bDBicDJpOTczMm9kaDJqemprbDcifQ.vdd9cfGAwcSXh1I7pq1mvA")
    let image = UIImage(named: "CustomLocationPIN")
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBlurView()
        
        buttonDistance = HorizontalStackButtons.spacing
      
        dismissKayboardInTapGesture()
        
        self.msgCenter = msgsButton.center
        self.perfilCenter = perfilButton.center
        self.reportCenter = reportButton.center
       
        filterTable.isHidden = true
        hideButtons(duration: 0)
        //Remove bussola do mapa
        mapView.compassView.removeFromSuperview()
        
        self.refReports =  Database.database().reference().child("reports")
        setObserverToFireBaseChanges()
       
        //Requisitando propagandas e setando os devices
        let request = GADRequest()
        filterTable.isHidden = true
        request.testDevices = ["ed38a929ee1c81d9bdfdd596a77be9e0"]
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
           centerOnUser() 
        }
        
        
    }
    
    func addBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.subviews.last?.isHidden = true
    }
    
    //MARK: Buttons functions
    func hideButtons(duration:Double){
        UIView.animate(withDuration: duration, animations:{
            
            self.HorizontalStackButtons.spacing = 0
            self.reportButton.center = self.expandButton.center
            
            self.reportButton.alpha = 0
            self.msgsButton.alpha = 0
            self.perfilButton.alpha = 0
            
            }, completion: nil)
        
        
    }
    func showButtons(duration:Double){
      self.view.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations:{
 
            self.perfilButton.alpha = 1
           
            self.HorizontalStackButtons.spacing = self.buttonDistance

            self.reportButton.center = self.reportCenter
            self.reportButton.alpha = 1
            
            self.msgsButton.alpha = 1
            
            
        }, completion: nil)
        
    }

    @IBAction func profileButtonAction(_ sender: Any) {
        
        performSegue(withIdentifier: "ProfileSegue", sender: nil)
    }
    
    @IBAction func messageButtonAction(_ sender: Any) {
        
        let navigation = UINavigationController(rootViewController: MessagesTableViewController())
        present(navigation, animated: true, completion: nil)
    }
    
    @IBAction func locatioButtonAction(_ sender: UIButton) {
        centerOnUser()
    }
    //MARK: config functions
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
    // MARK:Table VIew Delegate (searchBarResults)
    
    
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
    
    
    @IBAction func expandAction(_ sender: UIButton) {
        //Verifica se o Usuario ja está logado.
        if UserInteractor.getCurrentUserUid() == nil {
            //Adiciona Alerta para redirecionar ao login.
            let alertControler = UIAlertController(title: "Atenção", message: "Por favor faça o login para poder acessar as opçoes de relato.", preferredStyle: .alert)
            
            alertControler.addAction(UIAlertAction(title: "Logar", style: .default, handler: { (UIAlertAction) in
                
            self.performSegue(withIdentifier: "goToLogin", sender: nil)
                
            }))
            alertControler.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { (UIAlertAction) in

            }))
            
            self.present(alertControler, animated: true, completion: nil)
        }else{
            //Faz animação caso esteja logado.
            if !sender.isSelected {
                showButtons(duration: 0.5)
                sender.isSelected = true
            }else{
                hideButtons(duration: 0.5)
                sender.isSelected = false
            }
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewSegue" {
            containerViewController = segue.destination as? FilterTableViewControlleTableViewController
            containerViewController!.containerToMaster = self
        } else if segue.identifier == "seeReport"{
            if let seeScreen = segue.destination as? SeeReportViewController {
                seeScreen.report = self.reportToSend
            }
            
        } else if segue.identifier == "registerReportSegue" {
            if let reportScreen = segue.destination as? RegisterReportViewController {
                
                UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
                    reportScreen.modalPresentationStyle = UIModalPresentationStyle.popover
                    reportScreen.preferredContentSize = CGSize(width: 365, height: 670)
                }, completion: nil)
                
                reportScreen.popoverPresentationController!.delegate = self
                reportScreen.popoverPresentationController!.sourceView = self.view
                reportScreen.popoverPresentationController!.popoverBackgroundViewClass = PopoverBackgroundView.self
                reportScreen.popoverPresentationController!.sourceRect = CGRect(x: 0, y: 0, width: self.view.bounds.size.width - 10, height: self.view.bounds.size.height)
                reportScreen.popoverPresentationController!.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                reportScreen.view.backgroundColor = UIColor(r: 27, g: 2, b: 37).withAlphaComponent(0.7)
            }

        }
    }
   
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        if let blurView = (self.view.subviews.filter{$0 is UIVisualEffectView}.first) {
            blurView.isHidden = false
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func setObserverToFireBaseChanges() {
        
        self.refReports.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.reports.removeAll()
                self.removePins()
                for report in snapshot.children.allObjects as![DataSnapshot]{
                    let reportObj = report.value as? [String: AnyObject]
                    
                    let id = reportObj?["id"]
                    let userId = reportObj?["userId"]
                    let title = reportObj?["title"]
                    let description = reportObj?["description"]
                    let violenceKind = reportObj?["violenceKind"]
                    let violenceAproximatedTime = reportObj?["violenceAproximatedTime"]
                    let latitude = reportObj?["latitude"]
                    let longitude = reportObj?["longitude"]
                    let personGender = reportObj?["personGender"]
                    let supports = reportObj?["supports"]
                    
                    var reportAtt:Report?
                    
                    if supports != nil {
                        
                        reportAtt = Report(id: id as! String,
                                           userId: userId as! String,
                                           title: title as! String,
                                           description: description as! String,
                                           violenceKind: violenceKind as! String,
                                           violenceAproximatedTime: violenceAproximatedTime as! Double,
                                           latitude: latitude as! Double, longitude: longitude as! Double,
                                           personGender: personGender as! String,
                                           supports: supports as! Int)
                    } else {
                        reportAtt = Report(id: id as! String,
                                           userId: userId as! String,
                                           title: title as! String,
                                           description: description as! String,
                                           violenceKind: violenceKind as! String,
                                           violenceAproximatedTime: violenceAproximatedTime as! Double,
                                           latitude: latitude as! Double,
                                           longitude: longitude as! Double,
                                           personGender: personGender as! String)
                    }
                    
                    
                    self.reports.append(reportAtt!)
                    self.filter(new: reportAtt!)
                   // self.filter()
                }
                
            }
        })
        
        
    }
    
}
