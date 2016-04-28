//
//  AppDelegate.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-18.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		UIApplication.sharedApplication().statusBarHidden = true
		self.window?.opaque = false
		return true
	}
	
	func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
		guard let vc = self.window?.rootViewController as? ViewController else {
			completionHandler(false)
			return
		}
		vc.view.frame = vc.view.frame // so the view gets init'ed
		// note that the indexes are reversed upon card array generation
		if shortcutItem.localizedTitle.containsString("MarketMesh") {
			vc.cardIndexToDrop = 6
		} else if shortcutItem.localizedTitle.containsString("Meshwurk") {
			vc.cardIndexToDrop = 5
		} else if shortcutItem.localizedTitle.containsString("NearbEYE") {
			vc.cardIndexToDrop = 4
		} else {
			completionHandler(false)
			return
		}
			completionHandler(true)
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

