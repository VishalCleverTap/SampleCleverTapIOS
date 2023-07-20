//
//  NotificationService.swift
//  NotificationService
//
//  Created by Vishal More on 21/11/22.
//

import UserNotifications
import CTNotificationService
import CleverTapSDK

class NotificationService: CTNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        let defaults = UserDefaults.init(suiteName: "group.com.clevertap.sampleclevertap.clevertap")
        //for logged in users onuserLogin called so impression goes to right profile
        let logged_in = defaults?.value(forKey: "logged_in")
        let _identity = defaults?.value(forKey: "identity")
        let _email = defaults?.value(forKey: "email")
        let _phone = defaults?.value(forKey: "phone")
            if ((logged_in) != nil) {

                let profile: Dictionary<String, AnyObject> = [
                    "Identity": _identity as AnyObject,                   // String or number
                    "Email": _email as AnyObject,              // Email address of the user
                    "Phone": _phone as AnyObject,                // Phone (with the country code, starting with +)
                        ]
                CleverTap.sharedInstance()?.onUserLogin(profile)
                    }
        
            CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData: request.content.userInfo)
            super.didReceive(request, withContentHandler: contentHandler)
    }
}
