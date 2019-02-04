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
    
    private let token = SensitiveData.token
    private var city = ""
    private lazy var url = "https://api.waqi.info/feed/\(city)/?token=\(token)"
    
    private var dayData: DayData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        city = "here"
        fetchData(withUrl: url)
    }
    
    private func fetchData(withUrl url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonData = JSON(response.result.value!)
                if jsonData["status"] == "error" {
                    print("Error")
                } else {
                    self.dayData = self.parseJson(jsonData)
                }
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    private func parseJson(_ json: JSON) -> DayData? {
        var parsedData = DayData()
        parsedData.city = json["data"]["city"]["name"].string
        parsedData.time = json["data"]["time"]["s"].string
        parsedData.pm25 = json["data"]["iaqi"]["pm25"].double
        parsedData.pm10 = json["data"]["iaqi"]["pm10"].double
        parsedData.o3 = json["data"]["iaqi"]["o3"].double
        parsedData.no2 = json["data"]["iaqi"]["no2"].double
        parsedData.so2 = json["data"]["iaqi"]["so2"].double
        parsedData.co = json["data"]["iaqi"]["co"].double
        return parsedData
    }
}

