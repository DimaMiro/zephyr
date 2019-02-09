//
//  InfoTableViewCell.swift
//  Zephyr
//
//  Created by Dima Miro on 08/02/2019.
//  Copyright © 2019 Dima Miro. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    lazy var propertyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.CustomColor.darkGray
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.CustomColor.lightGray
        return label
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.CustomColor.darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(propertyNameLabel)
        propertyNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        propertyNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26).isActive = true
        
        addSubview(statusLabel)
        statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26).isActive = true
        
        addSubview(valueLabel)
        valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
