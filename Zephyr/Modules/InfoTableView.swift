//
//  InfoTableView.swift
//  Zephyr
//
//  Created by Dima Miro on 07/02/2019.
//  Copyright © 2019 Dima Miro. All rights reserved.
//

import UIKit

class InfoTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let cellID = "cellID"
    
    var dataArray: [(name: String, value: Any?)] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func updateTableViewData(_ data: DayData?) {
        guard let data = data else { return }
        dataArray = [(name: "PM2.5", value: data.pm25),
                    (name: "PM10", value: data.pm10),
                    (name: "O3", value: data.o3),
                    (name: "NO2", value: data.no2),
                    (name: "SO2", value: data.so2),
                    (name: "CO", value: data.co)]
        print("I'm here: \(dataArray.count)")
        self.heightAnchor.constraint(equalToConstant: CGFloat(dataArray.count * 54)).isActive = true
        tableView.reloadData()
    }
    
    fileprivate func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 390).isActive = true
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.CustomColor.outlineGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection: \(dataArray.count)")
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InfoTableViewCell
        cell.propertyNameLabel.text = dataArray[indexPath.row].name
        cell.statusLabel.text = "(Moderate)"
        cell.valueLabel.text = "\(dataArray[indexPath.row].value ?? "-")"
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
