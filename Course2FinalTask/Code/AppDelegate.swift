//
//  AppDelegate.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 23/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var rootViewController: UIViewController?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = UIColor.white
        
        rootViewController = UIViewController()
        rootViewController?.view.frame = (window?.bounds)!
        
        window!.rootViewController = rootViewController!

        appCoordinator = AppCoordinator.init(name: "appcoordinator", container: rootViewController!)
        appCoordinator?.start()
        window!.makeKeyAndVisible()
        return true
    }

    

}

