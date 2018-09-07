//
//  AppDelegate.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 9/7/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import iPhoneSimulator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        iPhoneSimulator.run(window: window!)
        
        return true
    }

}

