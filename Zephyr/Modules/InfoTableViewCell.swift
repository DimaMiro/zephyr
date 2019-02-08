//
//  InfoTableViewCell.swift
//  Zephyr
//
//  Created by Dima Miro on 08/02/2019.
//  Copyright © 2019 Dima Miro. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(valueLabel)
        valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
