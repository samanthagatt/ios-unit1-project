//
//  AppDelegate.swift
//  Bookshelves
//
//  Created by Samantha Gatt on 8/20/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GoogleBooksAuthorizationClient.shared.resumeAuthorizationFlow(with: url)
    }

}

