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
    let exampleArray = ["First","Second","Third","Fourth","Fifth"]

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
    
    fileprivate func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 390).isActive = true
        self.heightAnchor.constraint(equalToConstant: CGFloat(exampleArray.count * 54)).isActive = true
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.CustomColor.outlineGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InfoTableViewCell
        cell.valueLabel.text = exampleArray[indexPath.row]
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
