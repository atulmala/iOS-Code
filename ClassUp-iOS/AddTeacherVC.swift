//
//  AddTeacherVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 03/03/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AWSMobileAnalytics

class AddTeacherVC: UIViewController {

    @IBOutlet weak var teacher_name: UITextField!
    
    @IBOutlet weak var teacher_mobile: UITextField!
    
    @IBOutlet weak var teacher_login: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Add Teacher")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTeacher(_ sender: UIButton) {
        // check for blanks
        if teacher_name.text == ""  {
            showAlert(title: "Error", message: "Teacher Name is blank")
            return
        }
        
        if teacher_mobile.text == ""    {
            showAlert(title: "Error", message: "Mobile number is blank")
            return
        }
        
        if teacher_mobile.text?.characters.count != 10  {
            showAlert(title: "Error", message: "Mobile1 should be exactly 10 digits")
            return
        }
        
        if teacher_login.text == "" {
            showAlert(title: "Error", message: "Teacher Login ID is blank")
            return
        }
        
        if !isValidEmail(testStr: teacher_login.text!)   {
            showAlert(title: "Error", message: "Login id is not in proper format.")
        }
        
        let prompt: String = "Are you sure to add this Teacher?"
        let alert: UIAlertController = UIAlertController(title: "Confirm Teacher Addition", message: prompt, preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let user: String = SessionManager.getLoggedInUser()
            let parameters: Parameters = [
                "user": user,
                "school_id": school_id,
                "full_name": self.teacher_name.text!,
                "email": self.teacher_login.text!,
                "mobile": self.teacher_mobile.text!
            ]
            
            var outcome: String = ""
            let error_message: String = ""
            Alamofire.request("\(server_ip)/teachers/add_teacher/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    let json = JSON(response.result.value)
                    outcome = json["status"].string!
                    print(outcome)
                    print(error_message)
                    if outcome != "success" {
                        self.showAlert(title: "Teacher Addition Failed", message: json["message"].string!)
                        return
                    }
                    else    {
                        self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
            }
            
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! SchoolAdminVC
        destinationVC.comingFrom = "AddTeacher"
    }
    

}
