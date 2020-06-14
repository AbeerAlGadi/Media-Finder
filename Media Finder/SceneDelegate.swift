//
//  SceneDelegate.swift
//  Media Finder
//
//  Created by Abeersharaf on 5/19/20.
//  Copyright © 2020 Abeer. All rights reserved.
//

import UIKit
import UIKit.UIWindow


@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if (UserDefaults.standard.object(forKey: "isFirstTime") as? Bool) != nil {  // Means if there is user
            let isLogOut = UserDefaults.standard.bool(forKey: "UserisLogOut") // When the user check Out the App
            print("islogout\(isLogOut)")
            if isLogOut {
                goToSignIn()
            }else{
                goToMediaScreen()
            }
        }
    }
    
    @available(iOS 13.0, *)
    func goToMediaScreen() {
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MediaListVC1") as! MediaListVC1
        let navigationController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navigationController
    }
    
    func goToSingUp(){
        let rootVC : UIViewController  = (mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC)
        let navigationController = UINavigationController(rootViewController: rootVC)
        let window = UIApplication.shared.windows.first
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func goToSignIn(){
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInVC") as! SignInVC
        let navigationController = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = navigationController
    }
    
}

