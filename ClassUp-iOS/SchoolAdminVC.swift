//
//  SchoolAdminVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 13/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import AWSMobileAnalytics

class SchoolAdminVC: UIViewController {
    var comingFrom: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "School Admin")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var message: String = ""
        
        if comingFrom == "BulkSMS"    {
            message = "Message(s) Sent!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "BulkSMSCancelled"    {
            message = "Message Sending Cancelled!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "AddStudent"    {
            message = "Student Added. Please login as teacher and check the Class."
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "DeleteStudent"    {
            message = "Student Deleted. Please login as teacher and check the Class."
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "UpdateStudent"    {
            message = "Student Updated. Please login as teacher and check the Class."
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "Delete Teacher"    {
            message = "Teacher Deleted."
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "UpdateTeacher"    {
            message = "Teacher Updated."
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "AddTeacher"    {
            message = "Teacher Added."
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }




        // we need to reinitialize comingFrom, otherwise it retains its value and unnecessary
        // pop-up appears on screen
        comingFrom = ""
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePassword")
        self.show(vc, sender: self)
    }
    
    @IBAction func unwindToAdminMenu(segue: UIStoryboardSegue)   {
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
