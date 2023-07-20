//
//  AppDelegate.swift
//  sampleclevertap
//
//  Created by Vishal More on 17/10/22.
//Universal App Link
//

import UIKit
import CleverTapSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,CleverTapPushNotificationDelegate {

    var window: UIWindow?
    //Multi Instance SDK Code
   // var cleverTapAdditionalInstance:CleverTap!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 2.0)
        
        /* // Multi Instance SDK Code
        let ctConfig = CleverTapInstanceConfig.init(accountId: "449-WZ4-KK6Z", accountToken:  "410-c44")
        ctConfig.logLevel = CleverTapLogLevel.debug
        ctConfig.disableIDFV = false
        cleverTapAdditionalInstance = CleverTap.instance(with: ctConfig)*/
        
        registerForPush()
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(true)
        
        return true
    }
    
//    private func application(application: UIApplication,
  //                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    //    NSLog("%@: registered for remote notifications: %@", self.description, deviceToken.description)
      //  CleverTap.sharedInstance()?.setPushToken(deviceToken as Data)
    //}
    
    func registerForPush() {
        
        let action1 = UNNotificationAction(identifier: "action_1", title: "Back", options: [])
            let action2 = UNNotificationAction(identifier: "action_2", title: "Next", options: [])
            //let action3 = UNNotificationAction(identifier: "action_3", title: "View In App", options: [])
            let categorywithAction = UNNotificationCategory(identifier: "CTNotification", actions: [action1, action2], intentIdentifiers: [], options: [])
            let categoryNoAction = UNNotificationCategory(identifier: "CTNotification2", actions: [], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([categoryNoAction,categorywithAction])

            // Register for Push notifications
            UNUserNotificationCenter.current().delegate = self
            // request Permissions
            UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {granted, error in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            })
        
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        // Get URL components from the incoming user activity.
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
            return false
        }

        // Check for specific URL components that you need.
        guard let path = components.path,
        let params = components.queryItems else {
            return false
        }
        print("path = \(path)")

        if let albumName = params.first(where: { $0.name == "albumname" } )?.value,
            let photoIndex = params.first(where: { $0.name == "index" })?.value {

            print("album = \(albumName)")
            print("photoIndex = \(photoIndex)")
            return true

        } else {
            print("Either album name or photo index missing")
            return false
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            NSLog("%@: failed to register for remote notifications: %@", self.description, error.localizedDescription)
        }
        
       /* func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            NSLog("%@: registered for remote notifications: %@", self.description, deviceToken.description)
            CleverTap.sharedInstance()?.setPushToken(deviceToken as Data)
        }*/
        
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            //CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo, openDeepLinksInForeground: true)
            //CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: response.notification.request.content.userInfo)
            //CleverTap.sharedInstance()?.recordNotificationClickedEvent(withData: response.notification.request.content.userInfo)
            NSLog("%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo)
            completionHandler()
         }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.badge, .sound, .alert])
        }
        
        func application(_ application: UIApplication,
                         didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            NSLog("%@: did receive remote notification completionhandler: %@", self.description, userInfo)
            completionHandler(UIBackgroundFetchResult.noData)
        }
        
        func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
            NSLog("pushNotificationTapped: customExtras: ", customExtras)
         }
    
    /*private func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject) -> Bool {
        CleverTap.sharedInstance()?.handleOpen(url as URL, sourceApplication: sourceApplication)
        return true
    }*/

    /*func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            print("APPDELEGATE: open url \(url)")
            DispatchQueue.main.async {
                self.showAlert(message: "APPDELEGATE: open url \(url)")
            }
            return true
        }
        
        func open(_ url: URL, options: [String : Any] = [:],
                  completionHandler completion: ((Bool) -> Swift.Void)? = nil){
            print("APPDELEGATE: open url \(url) with completionHandler")
            DispatchQueue.main.async {
                self.showAlert(message: "APPDELEGATE: open url \(url) with completionHandler")
            }
            
            completion?(false)
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("did receive remote notification \(response.notification.request.content.userInfo)")
        }
        
        func showAlert(message:String) {
            let alertController = UIAlertController(title: "Deeplink", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }*/
    
    /*func application(application: UIApplication, openURL url: NSURL,
                     sourceApplication: String?, annotation: AnyObject) -> Bool {
        CleverTap.sharedInstance()?.handleOpen(url as URL, sourceApplication: sourceApplication)
        return true
    }

    // Swift 3
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       CleverTap.sharedInstance()?.handleOpen(url, sourceApplication: nil)
       return true
    }

    func open(_ url: URL, options: [String : Any] = [:],
                       completionHandler completion: ((Bool) -> Swift.Void)? = nil) {
        CleverTap.sharedInstance()?.handleOpen(url, sourceApplication: nil)
        completion?(false)
    }*/
}

