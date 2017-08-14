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
class MapViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var msgsButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var perfilButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var filterTable: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var HorizontalStackButtons: UIStackView!
    
    var filtros:[String] = []
    let image = UIImage(named: "CustomLocationPIN")
    var locationManager = CLLocationManager()
    var reports: [Report] = []
    var refReports : DatabaseReference!
    var reportToSend:Report?
    var containerViewController: FilterTableViewControlleTableViewController?
    var buttonDistance:CGFloat = CGFloat()
    var msgCenter:CGPoint = CGPoint()
    var perfilCenter:CGPoint = CGPoint()
    var reportCenter:CGPoint = CGPoint()
    
    @IBOutlet weak var bannerView: GADBannerView!
   // var mapDelegate = MapViewDelegate()
    let geocoder = Geocoder(accessToken: "pk.eyJ1IjoiaGVsZW5hc2ltb2VzIiwiYSI6ImNqNWp4bDBicDJpOTczMm9kaDJqemprbDcifQ.vdd9cfGAwcSXh1I7pq1mvA")
    @IBOutlet weak var mapView: MGLMapView!
    var querryResults:[GeocodedPlacemark] = []
    //var tableView:UITableView = UITableView()
    
    @IBOutlet weak var searchTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDistance = HorizontalStackButtons.spacing
        
        self.msgCenter = msgsButton.center
        self.perfilCenter = perfilButton.center
        self.reportCenter = reportButton.center
        
        self.perfilButton.center = self.expandButton.center
        self.perfilButton.alpha = 0
        
        self.reportButton.center = self.expandButton.center
        self.reportButton.alpha = 0
        
        self.msgsButton.center = self.expandButton.center
        self.msgsButton.alpha = 0
        
        mapView.compassView.removeFromSuperview()
        
        // utilizado para apps em desenvolvimento para teste.Sem isso a conta pode ser banina.
        self.refReports =  Database.database().reference().child("reports")
        setObserverToFireBaseChanges()
        let request = GADRequest()
        filterTable.isHidden = true
        request.testDevices = [kGADSimulatorID]
        bannerView.adUnitID = "ca-app-pub-1296835094216265/5601148764"
        bannerView.rootViewController = self
        bannerView.load(request)
        
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
  //      mapDelegate = MapViewDelegate(mapView: mapView, view: self.view)
      
        //Adiciona observer para authorização do GPS

        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // searchBar.barTintColor = UIColor.clear
        centerOnUser()
        
    }
    func hideButtons(){
        UIView.animate(withDuration: 1, animations:{
//            self.expandButton.isSelected = false
          //  self.verticalStackButtons.spacing = 0
           
           // self.perfilButton.center = self.expandButton.center

            
            self.HorizontalStackButtons.spacing = 0
            self.reportButton.center = self.expandButton.center
            
            self.reportButton.alpha = 0
            self.msgsButton.alpha = 0
            self.perfilButton.alpha = 0
           // self.msgsButton.center = self.expandButton.center
            
            
            
            }, completion: nil)
        
        
    }
    func showButtons(){
      self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, animations:{
            //self.expandButton.isSelected = true
            
          //  self.perfilButton.center = self.perfilCenter
            self.perfilButton.alpha = 1
            self.HorizontalStackButtons.spacing = self.buttonDistance
           // self.verticalStackButtons.spacing = 28
            self.reportButton.center = self.reportCenter
            self.reportButton.alpha = 1
            
           // self.msgsButton.center = self.msgCenter
            self.msgsButton.alpha = 1
            
            
        }, completion: nil)
        
    }
    func addPin(new:Report){
        
            let annotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees.init(new.latitude), longitude: .init(new.longitude))
            annotation.title = new.title
            annotation.subtitle = new.violenceKind
        
        mapView.addAnnotation(annotation)
    }
    func addPins(reports:[Report]){
        for report in reports {
            filter(new: report)
        }
    }
    func removePins(){
        if mapView.annotations != nil {
        mapView.removeAnnotations(mapView.annotations!)
        }
    }
    func searchBarConfig(){
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
        //searchBar.layer.cornerRadius = 100
    }
    func locationCheck(){
        locationManager.delegate = self
        self.authorizationStatusCheck()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
    }
    func tableViewConstruct(){
        //tableView = UITableView(frame: CGRect(x: searchBar.frame.minX , y: searchBar.frame.maxY , width: searchBar.frame.width * 0.9, height: searchBar.frame.height * 3))
        //tableView.center = searchBar.centerCGPoint(x: searchBar.center.x, y: (searchBar.center.y + tableView.frame.height/2) )
        searchTableView.restorationIdentifier = "SearchTableView"
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //self.view.addSubview(tableView)
        self.searchTableView.isHidden = true
        searchTableView.allowsSelection = false
        searchTableView.layer.cornerRadius = 10
    }
    //Objetivo: Função para centrar no usuario quando ocorre o request do GPS.
    func centerOnUser(){
        
        mapView.setCenter((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        //mapView.showsUserLocation = true
    }
    //Objetivo: mover a camera para as coordenadas informadas com o zoom imformado
    func centerOnPoint(latitude:Double,longitude:Double,zoomLevel:Double){
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        mapView.setCenter(location, zoomLevel: zoomLevel, animated: true)
        
    }
    //Objetivo:Instanciar uma view com a imagem fornecida no centro do mapa .
    func addPoint(image:UIImage) {
        let view = self.view.subviews.first { (i) -> Bool in
            i.restorationIdentifier == "pinPoint"
        }
        if view != nil {
            view?.removeFromSuperview()
            
        }else{
            let imageView = UIImageView(image: image)
            
            imageView.center = CGPoint(x: mapView.center.x, y: (mapView.center.y - imageView.frame.height/2))
            imageView.restorationIdentifier = "pinPoint"
            self.view.addSubview(imageView)
        }
        
  
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return querryResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchBarCellTableViewCell
        
//        let label = UILabel(frame: cell.frame)
//        label.text = querryResults[indexPath.row].name
//        cell.addSubview(label)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewSegue" {
            containerViewController = segue.destination as? FilterTableViewControlleTableViewController
            containerViewController!.containerToMaster = self
        }
    }
   


    func filterContentForSearchText(searchText: String, scope: String = "All") {
        let options = ForwardGeocodeOptions(query: searchText)
                _ = geocoder.geocode(options) { (placemarks, attribution, error) in
                   // self.querryResults = placemarks!
                    self.querryResults = placemarks!.filter { placemark in
                        return placemark.name.lowercased().contains(searchText.lowercased())
                    }
                }
        
        
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
    
    @IBAction func filterActivate(_ sender: UIButton) {

        NotificationCenter.default.addObserver(self, selector: #selector(self.closeFilter), name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)
        
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController")
        
//        NotificationCenter.default.addObserver(controller, selector: #selector(self.filter), name: NSNotification.Name.init(rawValue: "Filter"), object: self.filtros)
        filterTable.isHidden = false
    }
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
    func closeFilter(){
        filterTable.isHidden = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)
        
    }
    
    @IBAction func expandAction(_ sender: UIButton) {
        
        if UserInteractor.getCurrentUserUid() == nil {
            let alertControler = UIAlertController(title: "Por favor faça o login para poder acessar as opçoes de relato", message: nil, preferredStyle: .alert)
            
            alertControler.addAction(UIAlertAction(title: "Logar", style: .default, handler: { (UIAlertAction) in
                
            self.performSegue(withIdentifier: "goToLogin", sender: nil)
                
              
                
            }))
            alertControler.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { (UIAlertAction) in
                
               
                
                
                
            }))
            // Perguntar pro usuario pra logar
            // Sim -> mandar tela de login
            
            self.present(alertControler, animated: true, completion: nil)
        }else{
            if !sender.isSelected {
                showButtons()
                sender.isSelected = true
            }else{
                hideButtons()
                sender.isSelected = false
            }
        }
        
        
        
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        let options = ForwardGeocodeOptions(query: searchText)
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            // self.querryResults = placemarks!
            if(placemarks != nil){
                self.querryResults = placemarks!
                self.searchTableView.reloadData()
                self.searchTableView.isHidden = false
            }else{
                self.searchTableView.isHidden = true
            }
            
        }
        
        
        
        
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
                    
                    let reportAtt = Report(id: id as! String, userId: userId as! String, title: title as! String, description: description as! String, violenceKind: violenceKind as! String, violenceAproximatedTime: violenceAproximatedTime as! Double, latitude: latitude as! Double, longitude: longitude as! Double, personGender: personGender as! String)
                    
                    
                    self.reports.append(reportAtt)
                    self.filter(new: reportAtt)
                   // self.filter()
                }
                
            }
        })
        
        
    }
    
}


    
    

