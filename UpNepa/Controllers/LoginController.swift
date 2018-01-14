//
//  LoginController.swift
//  UpNepa
//
//  Created by Sagaya Abdulhafeez on 1/14/18.
//  Copyright © 2018 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension LoginController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.view.backgroundColor = Constant.shared.PRIMARY_COLOR
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.lightGray
    }
    override func viewDidLayoutSubviews() {
        self.view.addSubview(logoLabel)
        self.view.addSubview(holderView)
        self.holderView.addSubview(welcomeLabel)
        self.holderView.addSubview(messageLabel)
        self.holderView.addSubview(usernameTextfield)
        self.holderView.addSubview(loginButton)
        view.addSubview(activityIndicator)
        view.bringSubview(toFront: activityIndicator)
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 5),
            logoLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            holderView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 80),
            holderView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -55),
            holderView.heightAnchor.constraint(equalToConstant: 240),
            holderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 15),
            welcomeLabel.widthAnchor.constraint(equalTo: holderView.widthAnchor),
            welcomeLabel.leftAnchor.constraint(equalTo: holderView.leftAnchor, constant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10),
            messageLabel.widthAnchor.constraint(equalTo: holderView.widthAnchor),
            messageLabel.leftAnchor.constraint(equalTo: holderView.leftAnchor, constant: 20),
            messageLabel.heightAnchor.constraint(equalToConstant: 50),
            
            usernameTextfield.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            usernameTextfield.widthAnchor.constraint(equalTo: holderView.widthAnchor, constant: -35),
            usernameTextfield.heightAnchor.constraint(equalToConstant:50),
            usernameTextfield.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: usernameTextfield.bottomAnchor, constant: 15),
            loginButton.rightAnchor.constraint(equalTo: holderView.rightAnchor, constant: -25),
            loginButton.heightAnchor.constraint(equalToConstant: 36),
            loginButton.widthAnchor.constraint(equalToConstant: 36)
            
        ])
    }
    @objc func login(){
        guard let username = usernameTextfield.text else{
            return
        }
        activityIndicator.startAnimating()
        let params:Parameters = ["username": username]
        Alamofire.request("\(Constant.shared.BASE)/register", method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: nil).responseJSON { (response) in
            if response.response?.statusCode == 200{
                self.activityIndicator.stopAnimating()
                let jsonObject = JSON(response.result.value)
                guard let token = jsonObject["token"].string, let username = jsonObject["user"]["username"].string else{
                    return
                }
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(username, forKey: "username")
                self.present(UINavigationController(rootViewController: UpdatesController()), animated: true, completion: nil)
            }else{
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
