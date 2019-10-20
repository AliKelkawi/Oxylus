//
//  Network.swift
//  FireWatch2.0
//
//  Created by mac on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import Foundation
import Firebase
import FireStore

class Network {
    
    //    static var singleton = Network()
    
    var db = Firestore.firestore()
    
    var fires = [Fire]()
    var shelters = [Shelter]()
    
    func upload(shelter: Shelter) {
        print("uploading a shelter")
        print(shelter)
        
        let name = shelter.name
        let mobile = shelter.mobile
        let latitude = shelter.latitude
        let longitude = shelter.longitude
        
        
        db.collection("Shelters").addDocument(data: [
            "name": name,
            "mobile": mobile,
            "latitude": latitude,
            "longitude": longitude
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Added data")
            }
        }
    }
    
    func downloadFires() {
        print("downloading fires")
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("Fire").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let basicInfo = document.get("BasicInformation") as! NSDictionary
                    
                    
                    let latitude = basicInfo["latitude"] as! String
                    let longitude = basicInfo["longitude"] as! String
                    let title = document.documentID
                    let dateOrigin = basicInfo["DateofOrigin"] as? String
                    let update = basicInfo["Currentasof"] as? String
                    let currentSit = document.get("CurrentSituation") as! NSDictionary
                    let cause = basicInfo["Cause"] as? String
                    
                    let infos = document.get("informations") as! NSDictionary
                    let contained = infos["Contained"] as? String
                    var size = infos["Size"] as? String
                    let image = document.get("Image") as? String
                    
                    if size == nil {
                        size = "300"
                    }else{
                        size = size?.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    
                    let fire = Fire(Latitude: Double(latitude)!, Longitude: Double(longitude)!, title: title, DateofOrigin: dateOrigin, lastUpdated: update, size: size!, cause: cause, contained: contained, image: image)
                    
                    self.fires.append(fire)
                    //                    print("Cause: \(cause.childSnapshot(forPath: "Cause"))")
                    
                }
            }
        }
    }
    
    func downloadShelters() {
        print("downloading shelters")
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("Shelters").getDocuments() { (querySnapshot, err) in
            print("downloaded shelters")
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    let latitude = document.get("latitude") as? Double
                    let longitude = document.get("longitude") as? Double
                    let name = document.get("name") as! String
                    let phone = document.get("mobile") as! String
                    
                    let shelter = Shelter(name: name, longitude: longitude, latitude: latitude, mobile: phone)
                    
                    self.shelters.append(shelter)
                }
            }
        }
    }
    
    init() {
        
        print("init network")
        
        downloadFires()
        downloadShelters()
    }
    
    
    
}
