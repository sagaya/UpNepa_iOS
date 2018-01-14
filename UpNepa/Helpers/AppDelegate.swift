//
//  AppDelegate.swift
//  UpNepa
//
//  Created by Sagaya Abdulhafeez on 1/14/18.
//  Copyright © 2018 Sagaya Abdulhafeez. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import  UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if UserDefaults.standard.string(forKey: "token") == nil{
            window?.rootViewController = LoginController()
        }else{
            
            window?.rootViewController = UINavigationController(rootViewController: UpdatesController())
        }
        IQKeyboardManager.sharedManager().enable = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (didAllow, error) in
            
        }
        UIApplication.shared.isIdleTimerDisabled = true

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        var username = UserDefaults.standard.string(forKey: "username")
        if username == nil{
            username = ""
        }
        let content = UNMutableNotificationContent()
        content.title = "Hello! \(username!)"
        content.body = "You will not be able to receive telegram notifications when the app is in background mode kindly reopen the app to continue monitoring"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (_) in
            
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


