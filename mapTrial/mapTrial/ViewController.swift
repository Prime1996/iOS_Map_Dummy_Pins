//
//  ViewController.swift
//  mapTrial
//
//  Created by Mahedi Hassan on 18/11/19.
//  Copyright © 2019 Mahedi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct location: Decodable {
    let name: String
    let lattitude: Double
    let longtitude: Double
    
    init(json: [String: Any]) {
        name = json["name"] as? String ?? ""
        lattitude = json["lattitude"] as? Double ?? -1.0
        longtitude = json["longtitude"] as? Double ?? -1.0
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPin()
        checkLocationServices()
        
    }
    
    func addPin() {
        let jsonURL = "https://api.myjson.com/bins/11xrp2"
        guard let url = URL(string: jsonURL) else { return }
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            guard let data = data else { return }
            //      let dataAsString = String(data: data, encoding: .utf8)
            //    print(dataAsString)
            do {
                let loc = try JSONDecoder().decode([location].self, from: data)
                for locns in loc {
                    let annotation = MKPointAnnotation()
                    let centerCoordinate = CLLocationCoordinate2D(latitude: locns.lattitude, longitude: locns.longtitude)
                    annotation.coordinate = centerCoordinate
                    annotation.title = locns.name
                    self.mapView.addAnnotation(annotation)
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            }.resume()
        
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
            
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}


