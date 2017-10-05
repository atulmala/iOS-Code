//
//  LoginVC.swift
//  Classup1
//
//  Created by Atul Gupta on 22/08/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ReachabilitySwift
import Firebase
import AWSMobileAnalytics




class LoginVC: UIViewController {
    let reachability = Reachability()
    var comingFrom: String = ""
    
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtLogin: UITextField!
    
    @IBAction func forgotPassword(sender: UIButton) {
        // check the connectivity to iternet
        if !(reachability?.isReachable)!   {
            showAlert(title: "Not connected to Internet", message: "It looks you that you are not connected to internet. Please check and try again")
            return
        }
        
        var userName:NSString = txtLogin.text! as NSString
        
        // verify if either username has been left blank
        if (userName.isEqual(to: ""))   {
            showAlert(title: "Alert", message: "Username is blank!")
        }
        else    {
            let propmt: String = "Are you sure you want to reset your password?"
            
            let alert: UIAlertController = UIAlertController(title: "Confirm Action", message: propmt, preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                
                self.activity_indicator.isHidden = false
                self.activity_indicator.startAnimating()
                // if by mistake the user leaves any blank spaces in username or password, this can cause exception. Replace spaces by %20
                userName = userName.replacingOccurrences(of: " ", with: "%20") as NSString
                
                // send the request to backend for verification
                let server_ip: String = MiscFunction.getInitialServerIP(usr: userName as String)
                
                // if the user has typed a wrong username then server ip will be "error"
                let parameters: Parameters = ["user":userName as String]
                
                Alamofire.request("\(server_ip)/auth/forgot_password/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    if let value: AnyObject = response.result.value as AnyObject? {
                        // handle the results as JSON, without a bunch of nested if loops
                        let response = JSON(value)
                        print(response)
                        
                        if response["forgot_password"] == "successful"  {
                            self.activity_indicator.stopAnimating()
                            self.activity_indicator.isHidden = true
                            self.showAlert(title: "Password reset successful!", message: "You will soon receive your new password via SMS")
                            
                            
                        }else    {
                            self.activity_indicator.stopAnimating()
                            self.activity_indicator.isHidden = true
                            self.showAlert(title: "Password reset failed!", message: response["error_message"].string!)
                        }
                    }else    {
                        self.activity_indicator.stopAnimating()
                        self.activity_indicator.isHidden = true
                        self.showAlert(title: "Password reset failed!", message: "User does not exist. Please contact ClassUp Support at info@classup.in")
                    }
                }
            })
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // check the connectivity to iternet
        if !(reachability?.isReachable)!   {
            showAlert(title: "Not connected to Internet", message: "It looks you that you are not connected to internet. Please check and try again")
            return
        }
        
        var userName:NSString = txtLogin.text! as NSString
        var password:NSString = txtPassword.text! as NSString
        
        // verify if either username or password has been left blank
        if (userName.isEqual(to: "") || password.isEqual(to: ""))   {
            showAlert(title: "Login Failed!", message: "Either Username or password is blank")
        }
        else    {
            activity_indicator.isHidden = false
            activity_indicator.startAnimating()
            
            // 16/09/2017 we are now implmenting AWS Analytics
            let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
            let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
            let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Login Attempt")
            eventClient.addGlobalAttribute(userName as String!, forKey: "user")
            eventClient.record(event)
            eventClient.submitEvents()
            
            // if by mistake the user leaves any blank spaces in username or password, this can cause exception. Replace spaces by %20
            userName = userName.replacingOccurrences(of: " ", with: "%20") as NSString
            password = password.replacingOccurrences(of: " ", with: "%20") as NSString
            
            // send the request to backend for verification
            let server_ip: String = MiscFunction.getInitialServerIP(usr: userName as String)
            
            // if the user has typed a wrong username then server ip will be "error"
            if server_ip != "error" {
                let modelName = UIDevice.current.modelName
                let systemVersion = UIDevice.current.systemVersion
                let screenSize = UIScreen.main.bounds
                let width = screenSize.width
                let height = screenSize.height
                let size = "\(height.description) X \(width.description)"
                let parameters: Parameters =    [
                                                    "user":userName as String,
                                                    "password":password as String,
                                                    "device_type":"iPhone" as String,
                                                    "model":modelName as String,
                                                    "os":systemVersion as String,
                                                    "size":size as String,
                                                    "resolution":"iPhone Res" as String
                                                ]
                Alamofire.request("\(server_ip)/auth/login1/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        debugPrint(response)
                        if let value: AnyObject = response.result.value as AnyObject? {
                            // handle the results as JSON, without a bunch of nested if loops
                            let response = JSON(value)
                            print(response)
                            if response["user_status"] == "active" && response["login"] == "successful" {
                                SessionManager.setLoggedInUser(user: userName as String)
                                
                                let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
                                let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
                                let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Login Result")
                                eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
                                eventClient.addGlobalAttribute("Success", forKey: "Login Result")
                                eventClient.record(event)
                                eventClient.submitEvents()
                                
                                // 10/03/17 for firebase messsging, send the token id to server
                                let refreshedToken = FIRInstanceID.instanceID().token()
                                let parameters: Parameters = ["user": userName as String,
                                                              "device_token": refreshedToken! as String,
                                                              "device_type": "iOS"]
                                
                                Alamofire.request("\(server_ip)/auth/map_device_token/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                    .responseJSON { response in
                                        debugPrint(response)
                                }
                                
                                if let school_id = response["school_id"].int {
                                    SessionManager.setSchoolId(id: String(school_id))
                                }
                                if response["is_staff"] == "true"   {
                                    if response["subscription"] == "expired"    {
                                        self.showAlert(title: "Login Failed", message: "Institute/School's subscription has expired. Please contact your seniors")
                                    }
                                    else    {
                                        // 13/02/17 if user is School Admin show School Admin menu
                                        if response["school_admin"]  == "true"  {
                                            self.performSegue(withIdentifier: "toSchoolAdmin", sender: self)
                                        }
                                        else    {
                                            self.performSegue(withIdentifier: "toMainMenu", sender: self)
                                        }
                                    }
                                }else{
                                    // a parent has logged in
                                    self.performSegue(withIdentifier: "toParentMenu", sender: self)
                                }
                            }else    {
                                self.activity_indicator.stopAnimating()
                                self.activity_indicator.isHidden = true
                                self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
                                
                                let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
                                let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
                                let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Login Result")
                                eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
                                eventClient.addGlobalAttribute("Failed", forKey: "Login Result")
                                eventClient.record(event)
                                eventClient.submitEvents()
                            }
                        }else    {
                            self.activity_indicator.stopAnimating()
                            self.activity_indicator.isHidden = true
                            self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
                            let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
                            let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
                            let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Login Result")
                            eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
                            eventClient.addGlobalAttribute("Failed", forKey: "Login Result")
                            eventClient.record(event)
                            eventClient.submitEvents()
                        }
                        
                }
            }else    {
                activity_indicator.stopAnimating()
                activity_indicator.isHidden = true
                self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
            }
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activity_indicator.isHidden = true
        txtLogin.text = ""
        txtPassword.text = ""
        if comingFrom == "PasswordChange"    {
            let message = "Please Login with new Password"
            let final_confirm = UIAlertController(title: "Password Changed", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        activity_indicator.isHidden = true
        activity_indicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activity_indicator.isHidden = true
        activity_indicator.stopAnimating()
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue)   {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
