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

class MapViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    let image = UIImage(named: "CustomLocationPIN")
    var locationManager = CLLocationManager()

   // var mapDelegate = MapViewDelegate()
    let geocoder = Geocoder(accessToken: "pk.eyJ1IjoiZWR1YXJkb3RvcnJlcyIsImEiOiJjajVtcHlwczgydTk2MzFsbXlvZDNlM253In0.rVHnntpHbIO6bY3dKv4f6w")
    @IBOutlet weak var mapView: MGLMapView!
    var querryResults:[GeocodedPlacemark] = []
    var tableView:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView = UITableView(frame: CGRect(x: searchBar.frame.minX, y: searchBar.frame.maxY, width: searchBar.frame.width, height: searchBar.frame.width / 3))
        tableView.restorationIdentifier = "SearchTableView"
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.tableView.isHidden = true
        tableView.allowsSelection = false
    }
    //Objetivo: Função para centrar no usuario quando ocorre o request do GPS.
    func centerOnUser(){
        
        mapView.setCenter((locationManager.location?.coordinate)!, zoomLevel: 13, animated: true)
        mapView.showsUserLocation = true
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
        let cell = UITableViewCell(frame: CGRect(x: searchBar.frame.minX, y: searchBar.frame.minY*CGFloat(indexPath.row), width: searchBar.frame.width, height: searchBar.frame.height))
        
        let label = UILabel(frame: cell.frame)
        label.text = querryResults[indexPath.row].name
        cell.addSubview(label)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCel(sender:)))
        cell.addGestureRecognizer(gesture)
        
        return cell
    }
    func tapCel(sender:UITapGestureRecognizer)  {
        //using sender, we can get the point in respect to the table view
        let tapLocation = sender.location(in: self.tableView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        mapView.setCenter(querryResults[(indexPath?.row)! ].location.coordinate, zoomLevel: 10, animated: true)
        searchBar.text = querryResults[(indexPath?.row)! ].name
        
        
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
    
    @IBAction func addCenterAction(_ sender: Any) {
        addPoint(image: UIImage(named: "CustomLocationPIN")!)

    }
    
    @IBAction func heatMapButton(_ sender: UIButton) {
        heatAction()
        
    }
    @IBAction func pinAction(_ sender: UIButton) {
        addPin()
        
    }
    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        filterContentForSearchText(searchText: searchController.searchBar.text!)
//    }
    
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        let options = ForwardGeocodeOptions(query: searchText)
        _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            // self.querryResults = placemarks!
            if(placemarks != nil){
                self.querryResults = placemarks!
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }else{
                self.tableView.isHidden = true
            }
            
        }
        
        
        
        
    }
    
}


    
    

