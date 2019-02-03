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
    
    let token = SensitiveData.token
    var city = ""
    lazy var url = "https://api.waqi.info/feed/\(city)/?token=\(token)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        city = "here"
        fetchData(withUrl: url)
    }
    
    func fetchData(withUrl url: String) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let respond = JSON(response.result.value!)
                if respond["status"] == "error" {
                    print("Error")
                } else {
                    print(respond)
                }
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }

}

