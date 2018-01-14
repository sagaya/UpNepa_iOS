//
//  ViewController.swift
//  UpNepa
//
//  Created by Sagaya Abdulhafeez on 1/14/18.
//  Copyright © 2018 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginController: UIViewController {
    lazy var logoLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.text = "UpNepa"
        lab.textColor = .white
        lab.font = UIFont(name: "ChalkboardSE-Bold", size: 30)
        lab.textAlignment = .center
        return lab
    }()
    lazy var holderView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.gray.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = CGSize.zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 8.0
        v.layer.masksToBounds = true
        return v
    }()
    lazy var welcomeLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = UIColor(red:0.32, green:0.87, blue:0.33, alpha:1.0)
        lab.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        lab.text = "Welcome!"
        lab.textAlignment = .left
        return lab
    }()
    lazy var messageLabel: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = UIColor(red:0.58, green:0.60, blue:0.60, alpha:1.0)
        lab.font = UIFont(name: "AvenirNext-Regular", size: 18)
        lab.text = "Enter your telegram \nusername"
        lab.numberOfLines = 0
        lab.textAlignment = .left
        return lab
    }()
    
    lazy var usernameTextfield: SkyFloatingLabelTextField = {
        let txt = SkyFloatingLabelTextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Username"
        txt.title = "Username"
        txt.lineColor = Constant.shared.PRIMARY_COLOR
        txt.selectedLineColor = Constant.shared.PRIMARY_COLOR
        txt.textColor = .gray
        txt.lineHeight = 1.0
        txt.selectedLineHeight = 1.0
        txt.placeholderColor = .gray
        txt.placeholderFont = UIFont(name: "RobotoMono-medium", size: 15)
        txt.selectedTitleColor = .white
        return txt
    }()
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "right_circular"), for: .normal)
        btn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return btn
    }()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

