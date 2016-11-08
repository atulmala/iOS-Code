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


class LoginVC: UIViewController {
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtLogin: UITextField!
    
    @IBAction func forgotPassword(sender: UIButton) {
        // check the connectivity to iternet
        
        if !Reachability.isConnectedToNetwork() {
            showAlert(title: "Not connected to Internet", message: "It looks you that you are not connected to internet. Please check and try again")
            
            return
        }
        
        var userName:NSString = txtLogin.text! as NSString
        
        // verify if either username has been left blank
        if (userName.isEqual(to: ""))   {
            showAlert(title: "Alert", message: "Username is blank!")
        }
        else    {
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
                        self.showAlert(title: "Password reset successful!", message: "You will soon receive your new password via SMS")
                        
                    }else    {
                        self.showAlert(title: "Password reset failed!", message: "User does not exist. Please contact ClassUp Support at info@classup.in")
                    }
                }else    {
                    self.showAlert(title: "Password reset failed!", message: "User does not exist. Please contact ClassUp Support at info@classup.in")
                }
            }
        }
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // check the connectivity to iternet
        
        if !Reachability.isConnectedToNetwork() {
            showAlert(title: "Not connected to Internet", message: "It looks you that you are not connected to internet. Please check and try again")
            return
        }
        
        var userName:NSString = txtLogin.text! as NSString
        var password:NSString = txtPassword.text! as NSString
        //var school_id:String = "";
        
        // verify if either username or password has been left blank
        if (userName.isEqual(to: "") || password.isEqual(to: ""))   {
            showAlert(title: "Login Failed!", message: "Either Username or password is blank")
        }
        else    {
            // if by mistake the user leaves any blank spaces in username or password, this can cause exception. Replace spaces by %20
            userName = userName.replacingOccurrences(of: " ", with: "%20") as NSString
            password = password.replacingOccurrences(of: " ", with: "%20") as NSString
            
            // send the request to backend for verification
            let server_ip: String = MiscFunction.getInitialServerIP(usr: userName as String)
            
            // if the user has typed a wrong username then server ip will be "error"
            if server_ip != "error" {
                let parameters: Parameters = ["user":userName as String, "password":password as String]
                Alamofire.request("\(server_ip)/auth/login1/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        debugPrint(response)
                        if let value: AnyObject = response.result.value as AnyObject? {
                            // handle the results as JSON, without a bunch of nested if loops
                            let response = JSON(value)
                            print(response)
                            if response["user_status"] == "active" && response["login"] == "successful" {
                                SessionManager.setLoggedInUser(user: userName as String)
                                
                                if let school_id = response["school_id"].int {
                                    SessionManager.setSchoolId(id: String(school_id))
                                }
                                if response["is_staff"] == "true"   {
                                    if response["subscription"] == "expired"    {
                                        self.showAlert(title: "Login Failed", message: "Institute/School's subscription has expired. Please contact your seniors")
                                    }
                                    else    {
                                        self.performSegue(withIdentifier: "toMainMenu", sender: self)
                                    }
                                }else{
                                    // a parent has logged in
                                    self.performSegue(withIdentifier: "toParentMenu", sender: self)
                                }
                            }else    {
                                self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
                            }
                        }else    {
                            self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
                        }

                }
            }else    {
                self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
                
            }
        }

    }
    @IBAction func loginTapped(sender: UIButton) {
        
        // check the connectivity to iternet
        
        if !Reachability.isConnectedToNetwork() {
            showAlert(title: "Not connected to Internet", message: "It looks you that you are not connected to internet. Please check and try again")
            return
        }
        
        var userName:NSString = txtLogin.text! as NSString
        var password:NSString = txtPassword.text! as NSString
        //var school_id:String = "";
        
        // verify if either username or password has been left blank
        if (userName.isEqual(to: "") || password.isEqual(to: ""))   {
            showAlert(title: "Login Failed!", message: "Either Username or password is blank")
        }
        else    {
            // if by mistake the user leaves any blank spaces in username or password, this can cause exception. Replace spaces by %20
            userName = userName.replacingOccurrences(of: " ", with: "%20") as NSString
            password = password.replacingOccurrences(of: " ", with: "%20") as NSString
            
            // send the request to backend for verification
            let server_ip: String = MiscFunction.getInitialServerIP(usr: userName as String)
            
            // if the user has typed a wrong username then server ip will be "error"
            if server_ip != "error" {
                var dictionary = [String:String]()
                dictionary["user"] = userName as String
                dictionary["password"] = password as String
                print(dictionary)
                let url: NSURL = NSURL(string: "\(server_ip)/auth/login1/")!
                print(url)
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                do{
                    request.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
                } catch _ {
                    request.httpBody = nil
                }
                Alamofire.request(request as! URLRequestConvertible).responseJSON { response in
                    if let value: AnyObject = response.result.value as AnyObject? {
                        // handle the results as JSON, without a bunch of nested if loops
                        let response = JSON(value)
                        print(response)
                        if response["user_status"] == "active" && response["login"] == "successful" {
                            SessionManager.setLoggedInUser(user: userName as String)
                            
                            if let school_id = response["school_id"].int {
                                SessionManager.setSchoolId(id: String(school_id))
                            }
                            if response["is_staff"] == "true"   {
                                if response["subscription"] == "expired"    {
                                    self.showAlert(title: "Login Failed", message: "Institute/School's subscription has expired. Please contact your seniors")
                                }
                                else    {
                                    self.performSegue(withIdentifier: "toMainMenu", sender: self)
                                }
                            }else{
                                // a parent has logged in
                                self.performSegue(withIdentifier: "toParentMenu", sender: self)
                            }
                        }else    {
                            self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
                        }
                    }else    {
                        self.showAlert(title: "Login Failed!", message: "Either Username/password is incorrect or user is inactive")
                    }
                }
            }else    {
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
        txtLogin.text = ""
        txtPassword.text = ""
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
