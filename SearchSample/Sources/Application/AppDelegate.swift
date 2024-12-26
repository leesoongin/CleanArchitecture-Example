//
//  AppDelegate.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appContainer = AppDIContainer.shared
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController: SearchedListViewController = appContainer.resolveSearchModule(SearchedListViewController.self)
        
        window?.rootViewController = rootViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

