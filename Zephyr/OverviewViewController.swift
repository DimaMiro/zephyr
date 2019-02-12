//
//  ViewController.swift
//  Zephyr
//
//  Created by Dima Miro on 03/02/2019.
//  Copyright © 2019 Dima Miro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class OverviewViewController: UIViewController {
    
    fileprivate let token = SensitiveData.aiqAPIToken
    fileprivate var city: String?
    
    var urlWithCity: String {
        return "https://api.waqi.info/feed/\(city ?? "here")/?token=\(token)"
    }
    
    var latitude: Double?
    var longitude: Double?
    
    var urlWithGeoPosition: String {
        return "https://api.waqi.info/feed/geo:\(latitude ?? 0.0);\(longitude ?? 0.0)/?token=\(token)"
    }
    
    fileprivate var dayData: DayData?
    
    var card = MainInfoCard()
    var infoTableView = InfoTableView()
    
    var locationManager = CLLocationManager()
    
    lazy var indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .gray
        return indicator
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 1000
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Refresh")
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresher
    }()
    
    lazy var searchController: UISearchController = {
        let searchbar = UISearchController(searchResultsController: nil)
        return searchbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLocationManager()
        navigationItem.title = "Loading..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by city"
        
    }
    
    fileprivate func setupView() {
        view.backgroundColor = UIColor.CustomColor.backgroundGray
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(refreshControl)
        
        scrollView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.startAnimating()
        
        setupCardView()
        
        scrollView.addSubview(infoTableView)
        infoTableView.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 16).isActive = true
        infoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        infoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }
    
    fileprivate func setupCardView() {
        scrollView.addSubview(card)
        card.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        
        card.isHidden = true
    }
    
    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func fetchData(withUrl url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonData = JSON(response.result.value!)
                if jsonData["status"] == "error" {
                    print(jsonData)
                    if let wrongData = jsonData["data"].string {
                        print("Error: \(String(describing: wrongData))")
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        self.presentAlert(withTitle: "Error", message: "\(String(describing: wrongData))", actions: [action], completion: nil)
                    } else if let errorMessage = jsonData["message"].string {
                        print("Error: \(String(describing: errorMessage))")
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        self.presentAlert(withTitle: "Error", message: "\(String(describing: errorMessage))", actions: [action], completion: nil)
                    } else {
                        print("Unknown error")
                    }
                    
                } else {
                    self.dayData = self.parseJson(jsonData)
                    print(jsonData)
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                        self.card.updateCardData(self.dayData)
                        self.infoTableView.updateTableViewData(self.dayData)
                        if let firstWordInLocation = self.dayData!.city!.components(separatedBy: ",").first {
                            self.navigationItem.title = firstWordInLocation
                        }
                    }
                }
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    fileprivate func parseJson(_ json: JSON) -> DayData? {
        var parsedData = DayData()
        parsedData.city = json["data"]["city"]["name"].string
        parsedData.time = json["data"]["time"]["s"].string
        parsedData.pm25 = json["data"]["iaqi"]["pm25"]["v"].int
        parsedData.pm10 = json["data"]["iaqi"]["pm10"]["v"].int
        parsedData.o3 = json["data"]["iaqi"]["o3"]["v"].double
        parsedData.no2 = json["data"]["iaqi"]["no2"]["v"].double
        parsedData.so2 = json["data"]["iaqi"]["so2"]["v"].double
        parsedData.co = json["data"]["iaqi"]["co"]["v"].double
        parsedData.temp = json["data"]["iaqi"]["t"]["v"].double
        return parsedData
    }
    
    @objc func refreshData() {
        fetchData(withUrl: urlWithGeoPosition)
        refreshControl.endRefreshing()
    }
    
    func presentAlert(withTitle title: String, message: String?, actions: [UIAlertAction], completion: (() -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { (action) in
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: completion)
    }
}

extension OverviewViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { print("Error detect location)"); return }
        if currentLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(currentLocation.coordinate.longitude), latitude = \(currentLocation.coordinate.latitude)")
            self.latitude = currentLocation.coordinate.latitude
            self.longitude = currentLocation.coordinate.longitude
            fetchData(withUrl: urlWithGeoPosition)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        city = "here"
        fetchData(withUrl: urlWithCity)
    }
}

extension OverviewViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("TextDidEndEditing")
        if let requestText = searchBar.text {
            if requestText != "" {
                city = requestText.lowercased()
                fetchData(withUrl: urlWithCity)
                searchController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

