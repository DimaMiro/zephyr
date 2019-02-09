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

class ViewController: UIViewController {
    
    fileprivate let token = SensitiveData.token
    fileprivate var city: String?
    fileprivate lazy var url = "https://api.waqi.info/feed/\(city ?? "here")/?token=\(token)"
    
    fileprivate var dayData: DayData?
    
    var card = MainInfoCard()
    var infoTableView = InfoTableView()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        fetchData(withUrl: url)
        view.backgroundColor = UIColor.CustomColor.backgroundGray
        
        navigationItem.title = "Loading..."
        
        setupCardView()
        
        scrollView.addSubview(infoTableView)
        infoTableView.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 16).isActive = true
        infoTableView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
    }
    
    fileprivate func setupCardView() {
        scrollView.addSubview(card)
        card.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        card.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        
        card.isHidden = true
    }
    
    fileprivate func fetchData(withUrl url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonData = JSON(response.result.value!)
                if jsonData["status"] == "error" {
                    print("Error")
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
        fetchData(withUrl: url)
        refreshControl.endRefreshing()
    }
}

