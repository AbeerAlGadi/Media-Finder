//
//  AppDelegate.swift
//  Media Finder
//
//  Created by Abeersharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.

import UIKit
import IQKeyboardManagerSwift
import SkyFloatingLabelTextField


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        //let navigationBarAppearace = UINavigationBar.appearance()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
}
