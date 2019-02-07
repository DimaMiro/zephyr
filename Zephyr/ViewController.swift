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
    fileprivate var city = ""
    fileprivate lazy var url = "https://api.waqi.info/feed/\(city)/?token=\(token)"
    
    fileprivate var dayData: DayData?
    
    var card =  MainInfoCard()

    override func viewDidLoad() {
        super.viewDidLoad()
        city = "here"
        fetchData(withUrl: url)
        view.backgroundColor = .white
        let guide = self.view.safeAreaLayoutGuide
        setupCardView(guide)
        
    }
    
    fileprivate func setupCardView(_ guide: UILayoutGuide) {
        view.addSubview(card)
        card.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16).isActive = true
        card.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16).isActive = true
        card.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16).isActive = true
        card.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        card.isHidden = true
    }
    
    fileprivate func updateCardData(_ data: DayData) {
        card.isHidden = false
        if let pm25Value = self.dayData?.pm25 {
            card.pm25Label.text = String(pm25Value)
            card.checkForCardColor(pm25value: pm25Value)
        } else { print("pm25Value is nil") }
        if let udatedTimeValue = self.dayData?.time {
            card.updatedTimeLabel.text = "Updated on \(udatedTimeValue)"
        } else { print("udatedTimeValue is nil") }
        if let temperatureValue = self.dayData?.temp {
            card.temperatureLabel.text = "Temperature: \(temperatureValue)°C"
        } else { print("temperatureValue is nil") }
    }
    
    fileprivate func fetchData(withUrl url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonData = JSON(response.result.value!)
                if jsonData["status"] == "error" {
                    print("Error")
                } else {
                    self.dayData = self.parseJson(jsonData)
                    DispatchQueue.main.async {
                        self.updateCardData(self.dayData!)
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
        parsedData.temp = json["data"]["iaqi"]["t"]["v"].int
        return parsedData
    }
}

