//
//  AppDelegate.swift
//  SFE
//
//  Created by Mateo Garcia on 8/2/17.
//  Copyright © 2017 Story for Everyone. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var hamburgerViewController: HamburgerViewController?
    var menuViewController: MenuViewController?
    
    static var allowRotation = false
    static var isAdmin = false {
        didSet {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.menuViewController?.checkAdmin()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /** CONNECT TO PARSE **/
        if let keys = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Keys", ofType: "plist")!) {
            // Parse config.
            let configuration = ParseClientConfiguration {
                $0.applicationId = keys["ParseApplicationID"] as? String
                if let server = keys["ParseServerURL"] as? String {
                    $0.server = server
                } else {
                    print("Error: No Parse Server URL found in Keys.plist.")
                }
            }
            Parse.enableLocalDatastore()
            Parse.initialize(with: configuration)
            
            PFUser.enableRevocableSessionInBackground { (error: Error?) -> Void in
                print("enableRevocableSessionInBackgroundWithBlock completion:", error?.localizedDescription)
            }
        } else {
            print("Error: Unable to load Keys.plist.")
        }
        
        /** SET DEFAULT START VIEW **/
        // Set up hamburger menu.
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        self.hamburgerViewController = menuStoryboard.instantiateViewController(withIdentifier: "HamburgerViewController") as? HamburgerViewController
        self.menuViewController = menuStoryboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        self.hamburgerViewController!.menuViewController = self.menuViewController
        self.menuViewController?.hamburgerViewController = hamburgerViewController
        // Set initial view controller to Stories VC.
        let storyboard = UIStoryboard(name: "Stories", bundle: nil)
        let storiesNC = storyboard.instantiateViewController(withIdentifier: "StoriesNC") as! UINavigationController
        self.hamburgerViewController!.contentViewController = storiesNC
        let storiesVC = storiesNC.viewControllers[0] as! StoriesViewController
        storiesVC.menuDelegate = self.menuViewController
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
