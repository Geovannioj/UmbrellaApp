//
//  MapViewDelegate.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 28/07/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit
import Mapbox

class MapViewDelegate: NSObject,MGLMapViewDelegate {
    let mapView:MGLMapView
    let mainView:UIView
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    init(mapView:MGLMapView,view: UIView) {
        self.mapView = mapView
        mainView = view
        super.init()
        self.mapView.delegate = self
    }
     override init() {
        mapView = MGLMapView()
        mainView = UIView()
        super.init()
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        return nil
    }
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        
        let view = mainView.subviews.first { (i) -> Bool in
            i.restorationIdentifier == "heatmap"
        }
        if view != nil {
            printHeatmap(imageView: view as! UIImageView)
            
        }
        
    }

    //Entrada: UIimageView
    //Saída:Nenhuma
    //Objetivo:Adicionar o mapa termico a UIImageView fornecida.
    
    func printHeatmap(imageView:UIImageView){
        var pontos:[CGPoint] = []
        var weights:[CGFloat] = []
        
        let xDistanceAll = distance(d1: (CGFloat(mapView.visibleCoordinateBounds.ne.longitude)), d2: (CGFloat(mapView.visibleCoordinateBounds.sw.longitude)))
        
        let yDistanceAll = distance(d1: (CGFloat(mapView.visibleCoordinateBounds.ne.latitude)), d2: (CGFloat(mapView.visibleCoordinateBounds.sw.latitude)))

        if  mapView.visibleAnnotations != nil {
            
            for i in mapView.visibleAnnotations! {
                
                
                let pinXDistance = distance(d1:CGFloat((i.coordinate.longitude)), d2: CGFloat((mapView.visibleCoordinateBounds.sw.longitude)))
                let pinYDistance = distance(d1:CGFloat(i.coordinate.latitude), d2: CGFloat(mapView.visibleCoordinateBounds.ne.latitude))
                
                
                let x = (CGFloat(mapView.frame.width) * pinXDistance)/xDistanceAll
                let y = (CGFloat(mapView.frame.height) * pinYDistance/yDistanceAll) + CGFloat(mapView.frame.minY - mainView.frame.minY)
                
                let ponto = CGPoint(x:CGFloat(x) + mapView.frame.width/2, y:CGFloat(y) + mapView.frame.height/2 )
                pontos.append(ponto)
                //Peso dos ponto a ser testado
                weights.append(10)
            }
        }
        
        let rect = CGRect(x: mapView.frame.minX, y: mapView.frame.minY, width: mapView.frame.width * 2 , height: mapView.frame.height * 2 )
        
        
        let heatMap = LFHeatMap.heatMap(with: rect, boost: 1, points: pontos, weights: weights, weightsAdjustmentEnabled: true, groupingEnabled: true)
        
        
        imageView.image = heatMap
        var degree = CGFloat(mapView.camera.heading)
        
        degree = degree*CGFloat.pi/180
        imageView.transform = CGAffineTransform(rotationAngle: -degree)
        imageView.center = mapView.center
        //                imageView.backgroundColor = UIColor.cyan
        
        
    }
    //Entrada:2 valores Double
    //Saída:Distancia entre esses valores
    func distance(d1:CGFloat,d2:CGFloat)->CGFloat{
        
        if d1>d2{
            
            return d1 - d2
        }else{
            return d2 - d1
        }
        
    }
    //Objetivo:Instanciar UIImageView e printar mapa de calor
    func heatAction() {
        
        let view = mainView.subviews.first { (i) -> Bool in
            i.restorationIdentifier == "heatmap"
        }
        if view != nil {
            
            view?.removeFromSuperview()
            
            
            
        }else{
            let heatView = UIImageView(frame: CGRect(x: mapView.frame.minX, y: mapView.frame.minY, width: mapView.frame.width * 2 , height: mapView.frame.height * 2))
            heatView.restorationIdentifier = "heatmap"
            printHeatmap(imageView: heatView)
            mainView.addSubview(heatView)
            
        }
        
    }
    func addPin() {
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: mapView.camera.centerCoordinate.latitude, longitude: mapView.camera.centerCoordinate.longitude)
        annotation.title = "teste"
        annotation.subtitle = "ënois"
        mapView.addAnnotation(annotation)
        self.latitude = annotation.coordinate.latitude
        self.longitude = annotation.coordinate.longitude
    }
    
    

}
