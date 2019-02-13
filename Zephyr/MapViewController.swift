//
//  MapViewController.swift
//  Zephyr
//
//  Created by Dima Miro on 10/02/2019.
//  Copyright © 2019 Dima Miro. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    fileprivate let aqiToken = SensitiveData.aiqAPIToken
    fileprivate let gmAPIKey = SensitiveData.googleMapsAPIKey
    
    var overviewVCInstance = OverviewViewController()
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey(gmAPIKey)
        latitude = overviewVCInstance.latitude
        longitude = overviewVCInstance.longitude
        if let latitude = self.latitude, let longitude = self.longitude {
            setupMapView(latitude, longitude)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        latitude = overviewVCInstance.latitude
        longitude = overviewVCInstance.longitude
        if let latitude = self.latitude, let longitude = self.longitude {
            setupMapView(latitude, longitude)
        }
    }
    
    fileprivate func setupMapView(_ latitude: Double, _ longitude: Double) {
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 13)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let urls: GMSTileURLConstructor = {(latitude, longitude, zoom) in
            let url = "https://tiles.waqi.info/tiles/usepa-pm25/\(zoom)/\(latitude)/\(longitude).png?token=\(self.aqiToken)"
            return URL(string: url)
        }
        let layer = GMSURLTileLayer(urlConstructor: urls)
        
        layer.zIndex = 1000
        layer.map = mapView
    }

}
