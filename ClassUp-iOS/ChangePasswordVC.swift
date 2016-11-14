//
//  ChangePasswordVC.swift
//  Classup1
//
//  Created by Atul Gupta on 18/10/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var new_password: UITextField!
    @IBOutlet weak var new_password1: UITextField!
    @IBAction func changePassword(sender: UIButton) {
        var good_to_go: Bool = true
        
        
        let password: NSString = new_password.text! as NSString
        let password1: NSString = new_password1.text! as NSString
        
        // check for blank password
        if  password.isEqual(to: "")   {
            good_to_go = false
            showAlert(title: "Password change Error", message: "Password is Blank")
            return
        }
        
        // the password cannot contain blank
        if password.contains(" ")   {
            good_to_go = false
            
            showAlert(title: "Password change Error", message: "Password cannot be blank")
            return
        }
        
        if password1.isEqual(to: "")    {
            good_to_go   = false
            showAlert(title: "Attention", message: "Please re-enter the new password")
            return
        }
        
        // the passwords should match
        if password.isEqual(to: password1 as String) == false    {
            good_to_go = false
            showAlert(title: "Password change Error", message: "Password doesn't match!")
            return
        }
        
        if good_to_go   {
            var dictionary = [String:String]()
            dictionary["user"] = SessionManager.getLoggedInUser()
            dictionary["new_password"] = password as String
            
            let server_ip = MiscFunction.getServerIP()
            let url = server_ip + "/auth/change_password/"
            
            Alamofire.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default)
                .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
               
                switch response.result  {
                    case .success(_):
                        self.showAlert(title: "Success", message: "Password change successful. Please re-login with new password")
                        return
                    default:
                        self.showAlert(title: "Password Change Failed", message: "Password change failed. Please contact your administrator")
                        return
                    }
                }
            performSegue(withIdentifier: "toLogin", sender: self)
        }
        
    }
    
    @IBAction func cancelChangePassword(sender: UIButton) {
    }

    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LoginVC
        destinationVC.comingFrom = "PasswordChange"
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
