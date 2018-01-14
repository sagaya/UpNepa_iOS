//
//  UpdatesController.swift
//  UpNepa
//
//  Created by Sagaya Abdulhafeez on 1/14/18.
//  Copyright © 2018 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit

struct Update {
    let status: Bool?
    let time: Date?
}
import Alamofire
import SwiftyJSON

extension UpdatesController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title  = "Log"
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        self.navigationController?.navigationBar.isTranslucent = false
        collectionView.register(UpdateCell.self, forCellWithReuseIdentifier: "cell")
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            
        }
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkNepaStatus), userInfo: nil, repeats: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logout))
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    @objc private func logout(){
        UserDefaults.standard.removeObject(forKey: "token")
        self.present(LoginController(), animated: true, completion: nil)
    }
    @objc private func checkNepaStatus(){
        UIDevice.current.isBatteryMonitoringEnabled = true
        let state = UIDevice.current.batteryState
        var status = false
        if self.state == state{

        }else{
            self.state = state
            if (state == .charging || state == .full) {
                status = true
                //charging
                let newUpdate = Update(status: true, time: Date())
                self.updates.append(newUpdate)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }else if UIDevice.current.batteryState == .unplugged{
                let up = Update(status: false, time: Date())
                print(up.status)
                self.updates.append(up)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            self.sendtelegramMessage(status: status)
        }
    }
    
    func sendtelegramMessage(status: Bool){
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        let header: HTTPHeaders = ["Authorization": token]
        let params: Parameters = ["state": status]
        Alamofire.request("\(Constant.shared.BASE)/send", method: .post, parameters:params, encoding: JSONEncoding(options: []), headers: header).responseJSON { (response) in
            print(response.result.value)
            if response.response?.statusCode == 200{
                print(response.result.value)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor,constant: 15)
        ])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 25, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return updates.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UpdateCell else{
            return UICollectionViewCell()
        }
        cell.update = updates[indexPath.row]
        return cell
    }
}
