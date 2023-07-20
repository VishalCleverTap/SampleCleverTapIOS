//
//  ViewController.swift
//  sampleclevertap
//
//  Created by Vishal More on 17/10/22.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController, CleverTapInboxViewControllerDelegate,CleverTapDisplayUnitDelegate {

    @IBOutlet weak var btnOnUserLogin: UIButton!
    @IBOutlet weak var btnPushProfile: UIButton!
    @IBOutlet weak var btnEventNoProp: UIButton!
    @IBOutlet weak var btnEventProp: UIButton!
    @IBOutlet weak var btnCharged: UIButton!
    @IBOutlet weak var btnAppInbox: UIButton!
    @IBOutlet weak var btnInApp: UIButton!
    @IBOutlet weak var btnNativeDisplay: UIButton!
    @IBOutlet weak var btnWebView: UIButton!
    @IBOutlet weak var tfIdentity: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    //Multi Instance SDK Code
    var cleverTapAdditionalInstance:CleverTap!
    
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        /* //Multi Instance SDK Code
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        cleverTapAdditionalInstance = appDelegate.cleverTapAdditionalInstance
        */
        
        //Initialize the CleverTap App Inbox
        CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
                let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
         }))
        
        CleverTap.sharedInstance()?.setDisplayUnitDelegate(self)
        
        
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        let _identity:String? = tfIdentity.text
        let _name:String? = tfName.text
        let _email:String? = tfEmail.text
        let _phone:String? = tfPhone.text
        
        switch(sender){
        case btnOnUserLogin:
            
            let dob = NSDateComponents()
            dob.day = 24
            dob.month = 5
            dob.year = 1992
            let d = NSCalendar.current.date(from: dob as DateComponents)
            
            let profile: Dictionary<String, AnyObject> = [
                "Name": _name as AnyObject,                 // String
                "Identity": _identity as AnyObject,                   // String or number
                "Email": _email as AnyObject,              // Email address of the user
                "Phone": _phone as AnyObject,                // Phone (with the country code, starting with +)
                "Gender": "M" as AnyObject,                          // Can be either M or F
                "Age": 28 as AnyObject,                              // Not required if DOB is set
                "Photo": "https://i.ibb.co/RBhV1Rm/michael-dam-m-EZ3-Po-FGs-k-unsplash.jpg" as AnyObject,   // URL to the Image
                "CustomValue":"Testing Value" as AnyObject,
            // optional fields. controls whether the user will be sent email, push etc.
                "MSG-email": true as AnyObject,                     // Disable email notifications
                "MSG-push": true as AnyObject,                       // Enable push notifications
                "MSG-sms": true as AnyObject,                       // Disable SMS notifications
            ]

            CleverTap.sharedInstance()?.onUserLogin(profile)
            //cleverTapAdditionalInstance.onUserLogin(profile)
            
            let defaults = UserDefaults.init(suiteName: "group.com.clevertap.sampleclevertap.clevertap")
            defaults?.setValue(_identity, forKey: "identity")
            defaults?.setValue(_email, forKey: "email")
            defaults?.setValue(_phone, forKey: "phone")
            defaults?.set(true, forKey: "logged_in")
            
            self.showToast(message: "onUserLogin Called", font: .systemFont(ofSize: 12.0))
            break
        case btnPushProfile:
            
            /*let profile: Dictionary<String, AnyObject> = [
                "Name": _name as AnyObject,                 // String
                "Identity": _identity as AnyObject,                   // String or number
                "Email": _email as AnyObject,              // Email address of the user
                "Phone": _phone as AnyObject,                // Phone (with the country code, starting with +)
            ]
            
            CleverTap.sharedInstance()?.profilePush(profile)*/
            
            switch(count){
            case 0:
                CleverTap.sharedInstance()?.profileAddMultiValue("a", forKey: "myStuff")
                count = count + 1
                break;
            
            case 1:
                CleverTap.sharedInstance()?.profileAddMultiValue("b", forKey: "myStuff")
                count = count + 1
                break;
                
            case 2:
                CleverTap.sharedInstance()?.profileAddMultiValue("c", forKey: "myStuff")
                count = count + 1
                break;
                
            case 3:
                CleverTap.sharedInstance()?.profileAddMultiValue("d", forKey: "myStuff")
                count = count + 1
                break;
                
            case 4:
                CleverTap.sharedInstance()?.profileAddMultiValue("e", forKey: "myStuff")
                count = count + 1
                break;
                
            case 5:
                CleverTap.sharedInstance()?.profileAddMultiValue("f", forKey: "myStuff")
                count = count + 1
                break;
                
            default:
                break;
            }
            
            self.showToast(message: "Push Profile Called", font: .systemFont(ofSize: 12.0))
            break
        case btnEventNoProp:
            // event without properties
            //CleverTap.sharedInstance()?.profileRemoveValue(forKey: "CustomValue")
            //CleverTap.sharedInstance()?.recordEvent("Product viewed")
            //CleverTap.sharedInstance()?.recordEvent("Flutter Event")
            let props = [
                "Channel": "App Inbox"
            ] as [String : Any]

            CleverTap.sharedInstance()?.recordEvent("Engagement Event", withProps: props)
            self.showToast(message: "Event with No Property Called", font: .systemFont(ofSize: 12.0))
            break
        case btnEventProp:
            
            // event with properties
            let props = [
                "Product name": "Casio Chronograph Watch",
                "Category": "Mens Accessories",
                "Price": 59.99,
                "Date": NSDate()
            ] as [String : Any]

            CleverTap.sharedInstance()?.recordEvent("Product viewed", withProps: props)
            
            //var testing = CleverTap.sharedInstance()?.getAllInboxMessages()
            //print(testing! as Any )
            
            //CleverTap.sharedInstance()?.recordEvent("ABCD")
            
            self.showToast(message: "Event with Property Called", font: .systemFont(ofSize: 12.0))
            break
        case btnCharged:
            
            func recordUserChargedEvent() {
                    //charged event
                    let chargeDetails = [
                        "Amount": 300,
                        "Payment mode": "Credit Card",
                        "Charged ID": 24052013
                        ] as [String : Any]
                    
                    let item1 = [
                        "Category": "books",
                        "Book name": "The Millionaire next door",
                        "Quantity": 1
                        ] as [String : Any]
                    
                    let item2 = [
                        "Category": "books",
                        "Book name": "Achieving inner zen",
                        "Quantity": 1
                        ] as [String : Any]
                    
                    let item3 = [
                        "Category": "books",
                        "Book name": "Chuck it, let's do it",
                        "Quantity": 5
                        ] as [String : Any]
                    
                    CleverTap.sharedInstance()?.recordChargedEvent(withDetails: chargeDetails, andItems: [item1, item2, item3])
                }
            
            self.showToast(message: "Charged Called", font: .systemFont(ofSize: 12.0))
            break
        case btnAppInbox:
            
            // config the style of App Inbox Controller
                let style = CleverTapInboxStyleConfig.init()
                style.title = "App Inbox"
                style.navigationTintColor = UIColor.black
                style.firstTabTitle = "My First Tab"
                style.messageTags = ["tag1", "tag2"]
                
                if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
                    let navigationController = UINavigationController.init(rootViewController: inboxController)
                    self.present(navigationController, animated: true, completion: nil)
              }
            
            self.showToast(message: "App Inbox Called", font: .systemFont(ofSize: 12.0))
            break
        case btnInApp:
            //CleverTap.sharedInstance()?.recordEvent("ABCD")
            self.registerForPush()
            break
        case btnNativeDisplay:
            CleverTap.sharedInstance()?.recordEvent("Product Viewed Event")
            break
        case btnWebView:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "webViewViewController")
            self.present(vc, animated: true, completion: nil)
            break
        default:
            self.showToast(message: "Default Called", font: .systemFont(ofSize: 12.0))
            break
        }
    }
    
    func displayUnitsUpdated(_ displayUnits: [CleverTapDisplayUnit]) {
           // you will get display units here
        var units:[CleverTapDisplayUnit] = displayUnits;
        //self.showToast(message: units, font: .systemFont(ofSize: 12.0))
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-100, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func registerForPush() {
        // Required field.
        let localInAppBuilder = CTLocalInApp(inAppType: CTLocalInAppType.HALF_INTERSTITIAL,
                                             titleText: "Get Notified",
                                             messageText: "Please enable notifications on your device to use Push Notifications.",
                                             followDeviceOrientation: true,
                                             positiveBtnText: "Allow",
                                             negativeBtnText: "Cancel")

        // Optional fields.
        localInAppBuilder.setFallbackToSettings(true)
        localInAppBuilder.setBackgroundColor("#FFFFFF")
        localInAppBuilder.setTitleTextColor("#FF0000")
        localInAppBuilder.setMessageTextColor("#FF0000")
        localInAppBuilder.setBtnBorderRadius("4")
        localInAppBuilder.setBtnTextColor("#FF0000")
        localInAppBuilder.setBtnBorderColor("#FF0000")
        localInAppBuilder.setBtnBackgroundColor("#FFFFFF")
        localInAppBuilder.setImageUrl("https://icons.iconarchive.com/icons/treetog/junior/64/camera-icon.png")

        // Prompt Push Primer with above settings.
        CleverTap.sharedInstance()?.promptPushPrimer(localInAppBuilder.getSettings())
    }
    
    
    
    func bannerNotification(text: String){

        // create a "container" view
        let container = UIView()
        
        // create a label
        let label = UILabel()
        
        // add label to container
        container.addSubview(label)
        
        // color / font / text properties as desired
        container.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        label.backgroundColor = .yellow
        label.numberOfLines = 0
        label.font = UIFont(name:"Helvetica Neue", size: 16.0)
        label.text = text
        
        // padding on left/right of label
        let hPadding: CGFloat = 16.0
        
        // padding on top of label - account for status bar?
        let vTopPadding: CGFloat = 32.0
        
        // padding on bottom of label
        let vBotPadding: CGFloat = 16.0

        let width = UIScreen.main.bounds.width
        
        // get reference to window 0
        let w = UIApplication.shared.windows[0]
        
        // add container to window
        w.addSubview(container)
        
        // calculate label height
        let labelSize = label.systemLayoutSizeFitting(CGSize(width: width - (hPadding * 2.0),
                                                      height: UIView.layoutFittingCompressedSize.height))
        
        // rect for container view - start with .zero
        var containerRect = CGRect.zero
        // set its size to screen width x calculated label height + top/bottom padding
        containerRect.size = CGSize(width: width, height: labelSize.height + vTopPadding + vBotPadding)
        // set container view's frame
        container.frame = containerRect
        
        // rect for label - container rect inset by padding values
        let labelRect = containerRect.inset(by: UIEdgeInsets(top: vTopPadding, left: hPadding, bottom: vBotPadding, right: hPadding))
        // set the label's frame
        label.frame = labelRect

        // position container view off-the-top of the screen
        container.frame.origin.y = -container.frame.size.height
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: {
                container.frame.origin.y = 0
            }) { (finished) in
                UIView.animate(withDuration: 0.4,delay: 2.0, options: .curveLinear, animations: {
                    container.frame.origin.y = -container.frame.size.height
                })
            }
        }
        
    }
    
}

