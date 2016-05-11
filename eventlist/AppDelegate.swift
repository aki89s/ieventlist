//
//  AppDelegate.swift
//  eventlist
//
//  Created by SuzukiAkinori on 2016/04/24.
//  Copyright © 2016年 kosa. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loading: Bool = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor.redColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()

        let chain = Keychain(service: ELConst().keychainBundle)
        if chain["uuid"] == nil {
            chain["uuid"] = UIDevice.currentDevice().identifierForVendor!.UUIDString
        }

        /*
        let deviceToken : NSData = def.objectForKey("deviceToken") != nil ? def.objectForKey("deviceToken") as! NSData : NSData()
         */

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }


}

