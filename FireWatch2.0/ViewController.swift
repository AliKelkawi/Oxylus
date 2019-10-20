//
//  ViewController.swift
//  FireWatch2.0
//
//  Created by Abdalwahab on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit
import NMAKit
import CoreFoundation

var network = Network()

class ViewController: UIViewController {
    
    var coreRouter: NMACoreRouter!
    var mapRouts = [NMAMapRoute]()
    var progress: Progress? = nil
    
    @IBOutlet weak var mapView: NMAMapView!
    var firesClusterLayer = NMAClusterLayer()
    var sheltersClusterLayer = NMAClusterLayer()
    
    var reportMarker: NMAMapMarker!
    @IBOutlet var reportBtn: UIButton!
    @IBOutlet var closeReportBtn: UIButton!
    
    @IBOutlet var card: UIView!
    @IBOutlet var cardTopConst: NSLayoutConstraint!
    
    var didStartPos = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "Fullname") == nil {
            print("[resent")
            let enterName = EnterNameViewController()
            self.present(enterName, animated: true, completion: nil)
        }
        
        mapView.delegate = self
        mapView.gestureDelegate = self
        
        mapView.positionIndicator.isVisible = true
        didStartPos = NMAPositioningManager.sharedInstance().startPositioning()
        print("user location: \(didStartPos)")
        
        addFirePins()
        addShelterPins()

        initValues()
    }
    
    
    // Initialize CoreRouter and set center for map.
    private func initValues() {
        coreRouter = NMACoreRouter()
        let pen = NMADynamicPenalty()
        
        for fire in network.fires {
            var avoid = [NMAGeoCoordinates]()
            
            for i in -1...1 {
                for j in -1...1 {
                    if i == 0 || j == 0 {
                        continue
                    }
                    
                    let radius = Double(Int(fire.size)!/6378137)
                    let radKM = sqrt(radius/247.0)/2.0
                    
                    let mypi = (180/Double.pi)
                    let lat = fire.Latitude + (mypi*radKM)*Double(j)*(-1.0)
                    let lon = fire.Longitude + mypi*radKM/cos(fire.Latitude)*Double(i)
                    
                    avoid.append(NMAGeoCoordinates(latitude: lat, longitude: lon))
                }
            }
            
            pen.addBannedArea(NMAMapPolygon(vertices: avoid))
        }
        
        coreRouter.dynamicPenalty = pen
        
        mapView.set(
            geoCenter: NMAGeoCoordinates(latitude: 37.7604929, longitude: -122.4008690),
            zoomLevel: 10, animation: NMAMapAnimation.linear
        )
    }
    
    func clearMap() {
        // remove all routes from mapView.
        for route in mapRouts {
            mapView.remove(mapObject: route)
        }
    }
    
    func addRoute(to: NMAGeoCoordinates) {
        if !didStartPos {
            print("enable location")
            return
        }
        
        print("routing")
        
        self.closeCard()
        
        let routingMode = NMARoutingMode.init(
            routingType: NMARoutingType.balanced,
            transportMode: NMATransportMode.car,
            routingOptions: NMARoutingOption.avoidTunnel
        )
        
        // check if calculation completed otherwise cancel.
        if !(self.progress?.isFinished ?? false) {
            self.progress?.cancel()
        }
        
        var route = [NMAGeoCoordinates]()
//        var avoid = [NMAGeoCoordinates]()
        
        let from = (NMAPositioningManager.sharedInstance().currentPosition?.coordinates)!
        route.append(from)
        route.append(to)
        
        print(route)
        
        // store progress.
        self.progress = self.coreRouter.calculateRoute(withStops: route, routingMode: routingMode, { (routeResult, error) in
            if (error != NMARoutingError.none) {
                NSLog("Error in callback: \(error)")
                
                return
            }
            
            guard let route = routeResult?.routes?.first else {
                print("Empty Route result")
                return
            }
            
            guard let box = route.boundingBox, let mapRoute = NMAMapRoute.init(route) else {
                print("Can't init Map Route")
                return
            }
            
            if (self.mapRouts.count != 0) {
                for route in self.mapRouts {
                    self.mapView.remove(mapObject: route)
                }
                self.mapRouts.removeAll()
            }
            
            self.mapRouts.append(mapRoute)
            
            self.mapView.set(boundingBox: box, animation: NMAMapAnimation.bow)
            self.mapView.add(mapObject: mapRoute)
        })
        
    }
    
    func addFirePins() {
        if network.fires.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
                self.addFirePins()
            }
            return
        }
        
        var markers = [NMAMapMarker]()
        let markerIcon = UIImage(named: "fire")!
        
        for fire in network.fires {
            let mm = MapMarker(geoCoordinates: NMAGeoCoordinates(latitude: fire.Latitude, longitude: fire.Longitude),
                               image: markerIcon)
            mm.isFire = true
            mm.fireData = fire
            mm.shelterData = nil
            markers.append(mm)
        }
        
        firesClusterLayer.addMarkers(markers)
        
        
        mapView.add(clusterLayer: firesClusterLayer)
    }
    
    func addShelterPins() {
        
        if network.shelters.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
                self.addShelterPins()
            }
            return
        }
        
//        print("adding shelters pins")
//        print(network.shelters)
        
//        markersLayer = NMAClusterLayer()
        var markers = [NMAMapMarker]()
        
        for shelter in network.shelters {
            if shelter.latitude == nil || shelter.longitude == nil {
                print("can't add a shelter with name: " + shelter.name)
                continue
            }
            
            let mm = MapMarker(geoCoordinates: NMAGeoCoordinates(latitude: shelter.latitude!, longitude: shelter.longitude!),
                               image: UIImage(named: "shelter")!)
            mm.isFire = false
            mm.fireData = nil
            mm.shelterData = shelter
            markers.append(mm)
        }
        
        // clusters style
        let clusterStyle = NMABasicClusterStyle.init(strokeColor: .white, fillColor: #colorLiteral(red: 0.3109423518, green: 0.4222553372, blue: 0.2739658356, alpha: 1), fontColor: .white)
        let theme = NMAClusterTheme()
        theme.setStyle(clusterStyle, range: NSRange(location: 1, length: 10000))
        sheltersClusterLayer.theme = theme
        
        sheltersClusterLayer.addMarkers(markers)
        
        mapView.add(clusterLayer: sheltersClusterLayer)
    }
}

extension ViewController: NMAMapViewDelegate {
    func mapView(_ mapView: NMAMapView, didSelect objects: [NMAViewObject]) {
        print("object tap")
        
        for object in objects {
            if object is NMAClusterViewObject {
                let cluster = object as! NMAClusterViewObject
                let boundingBox = cluster.boundingBox;
                
                mapView.set(boundingBox: boundingBox, animation: NMAMapAnimation.bow)
                
            }else if object is MapMarker {
                let marker = object as! MapMarker
                
                var cardTypeView: UIView!
                if marker.isFire {
                    let fireView = FireView()
                    fireView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: card.frame.height)
                    
                    fireView.setData(fire: marker.fireData!)
//                    let circle = NMAMapCircle(NMAGeoCoordinates(latitude: marker.fireData!.Latitude, longitude: marker.fireData!.Longitude),
//                                              radius: 400.0)
//                    circle.fillColor = #colorLiteral(red: 1, green: 0.4106767744, blue: 0.2980590334, alpha: 0.5)
//                    mapView.add(mapObject: circle)
                    
                    cardTypeView = fireView
                }else{
                    let shelterView = ShelterView()
                    shelterView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: card.frame.height)
                    
                    shelterView.name.text = marker.shelterData?.name
                    shelterView.phone.text = marker.shelterData?.mobile
                    clearMap()
                    shelterView.route = {
                        self.addRoute(to: NMAGeoCoordinates(latitude: marker.shelterData!.latitude!,
                                                            longitude: marker.shelterData!.longitude!))
                    }
                    
                    cardTypeView = shelterView
                }
                
                cardTypeView.alpha = 0
                
//                print("card subviews: \(card.subviews)")
                card.addSubview(cardTypeView)
//                print("card subviews: \(card.subviews)")
                
                UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self.cardTopConst.constant = -100
                    cardTypeView.alpha = 1
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
}

// -MARK: map gestures
extension ViewController: NMAMapGestureDelegate {
    func mapView(_ mapView: NMAMapView, didReceiveLongPressAt location: CGPoint) {
        print("long tap")
        
        let pinCord = mapView.geoCoordinates(from: location)
        
        if reportMarker != nil {
            firesClusterLayer.removeMarker(reportMarker)
        }
        
        reportMarker = NMAMapMarker(geoCoordinates: pinCord!,
                                    image: UIImage(systemName: "mappin")!.withTintColor(.red))
        firesClusterLayer.addMarker(reportMarker)
        
        UIView.animate(withDuration: 0.2) {
            self.reportBtn.alpha = 1
            self.closeReportBtn.alpha = 1
        }
    }
    
    @IBAction func closeReport() {
        if reportMarker != nil {
            firesClusterLayer.removeMarker(reportMarker)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.reportBtn.alpha = 0
            self.closeReportBtn.alpha = 0
        }
    }
}

// -MARK: card methods
extension ViewController {
    @IBAction func swipeCardUp() {
        print("swipe card up")
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.cardTopConst.constant = (self.view.frame.height - 130) * -1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func swipeCardDown() {
        closeCard()
    }
    
    func closeCard() {
        print("closing card")
        
        if card.subviews.isEmpty {
            print("no card to close")
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.cardTopConst.constant = 0
            self.view.layoutIfNeeded()
//            print(self.card.subviews)
            self.card.subviews[0].alpha = 0
        }, completion: { _ in
            self.card.subviews[0].removeFromSuperview()
//            print(self.card.subviews)
        })
        
        
    }
}
