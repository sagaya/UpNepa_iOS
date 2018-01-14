//
//  UpdatesController+Views.swift
//  UpNepa
//
//  Created by Sagaya Abdulhafeez on 1/14/18.
//  Copyright © 2018 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit

class UpdatesController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    var updates = Array<Update>()
    var timer = Timer()
    var state:UIDeviceBatteryState = UIDevice.current.batteryState
}

class UpdateCell: UICollectionViewCell {
    override func prepareForReuse() {
        self.statusLabel.text = "Loading....."
        self.backgroundColor = .clear
    }
    var update: Update?{
        didSet{
            guard let status = update?.status, let date = update?.time else{
                return
            }
            
            if status == true{
                self.statusLabel.text = "Power Restored"
                self.backgroundColor = UIColor(red:0.25, green:0.76, blue:0.50, alpha:1.0)
            }else{
                self.statusLabel.text = "Power Interrupted"
                self.backgroundColor = UIColor(red:0.93, green:0.39, blue:0.29, alpha:1.0)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let todaysDate = dateFormatter.string(from: date)
            self.dateLabel.text = todaysDate
        }
    }
    lazy var statusLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.text = "Power Restored"
        lab.textColor = .white
        lab.textAlignment = .left
        lab.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        return lab
    }()
    lazy var dateLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.text = "Jan 20, 12 04 tme black"
        lab.textColor = .white
        lab.textAlignment = .left
        lab.font = UIFont(name: "AvenirNext-Regular", size: 16)
        return lab
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        addSubview(statusLabel)
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            statusLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
