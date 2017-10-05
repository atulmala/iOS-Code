//
//  MainMenuVC.swift
//  Classup1
//
//  Created by Atul Gupta on 09/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON


class MainMenuVC: UIViewController {
    var triggering_menu: String = ""
    var comingFrom: String = ""
    @IBOutlet weak var btnTakeUpdateAttendance: UIButton!

    
    @IBAction func showCriteriaAttSummary(sender: UIButton) {
        triggering_menu = "showCriteriaAttSummary"
        //print("triggering menu=\(triggering_menu)")
        performSegue(withIdentifier: "selectAttSummaryCriteria", sender: self)
    }
    
    @IBAction func showCriteriaBusAttendance(sender: UIButton) {
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        Alamofire.request("\(server_ip)/setup/bus_attendance_enabled/\(school_id)/?format=json", method: .get, encoding: JSONEncoding.default).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                // handle the results as JSON, without a bunch of nested if loops
                let response = JSON(value)
                if response[0]["enable_bus_attendance"] == false {
                    let message = "This functionality is not available for your account. Please contact ClassUp Support to get this functionality."
                    let title = "Functionality not available"
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)                }else    {
                    self.triggering_menu = "BusAttendance"
                    self.performSegue(withIdentifier: "to_select_bus_attendance_criteria", sender:self)
                }
            }
        }
    }
    @IBAction func scheduleTest(sender: UIButton) {
        triggering_menu = "scheduleTest"
        performSegue(withIdentifier: "MainMenuToDateClassSectionSubjectSelection", sender: self)

    }
    
    @IBAction func scheduleTermTest(_ sender: UIButton) {
        triggering_menu = "scheduleTermTest"
        performSegue(withIdentifier: "MainMenuToDateClassSectionSubjectSelection", sender: self)
    }
    
    @IBAction func showTestsLists(sender: UIButton) {
        triggering_menu = "to_tests_list"
        performSegue(withIdentifier: "to_tests_list", sender: self)
        
    }
    @IBAction func goToTakeUpdateAttendance(sender: UIButton) {
        triggering_menu = "takeUpdateAttendance"
        performSegue(withIdentifier: "MainMenuToDateClassSectionSubjectSelection", sender: self)
    }
    
    @IBAction func setSubjects(sender: UIButton) {
        triggering_menu = "set_subjects"
        //performSegueWithIdentifier("to_set_subjects", sender: self)
    }
    @IBAction func logout(sender: UIButton) {
        SessionManager.logout()
        let vc: UIViewController = LoginVC()
        self.present(vc, animated: false, completion: nil)
        
        
    }
    override func viewDidLoad() {
        //print("Inside viewDidLoad of MainMenuVC")
        super.viewDidLoad()
        //btnTakeUpdateAttendance.layer.masksToBounds = true
        //btnTakeUpdateAttendance.layer.cornerRadius = 10
        
        // No title for the back button in navigation section
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var message: String = ""
        if comingFrom == "TakeAttendanceVC" {
            message = "Attendance submitted to Server"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "TestDetailsVC"    {
            message = "Test Scheduled"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "PendingTestList"    {
            message = "Test Deleted"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "TestMarksEntryVC"    {
            message = "Marks Submitted to Server. The test has been marked as Completed!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "SetSubjectVC"    {
            message = "Subjects Set!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "SendMessageVC"    {
            message = "Message(s) Sent!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "SendMessageVCCancelled"    {
            message = "Message Sending Cancelled!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "BusAttendanceVC"    {
            message = "Bus Attendance Submitted to Server"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        if comingFrom == "ReportBusDelay"    {
            message = "Message Sent"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        
        // 10/05/2017 - added when coming here after creating HomeWork
        if comingFrom == "CreateHW"    {
            message = "Home Work upload in progress. It will take a few minutes and then the new HW will appear in the HW List"
            let final_confirm = UIAlertController(title: "Homw Work Uploaded", message: message, preferredStyle: .alert)
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch triggering_menu  {
            case "takeUpdateAttendance":
                let destinationVC = segue.destination as! SelectDateClassSectionSubjectVC
                destinationVC.trigger = triggering_menu
                triggering_menu = ""
            case "scheduleTest":
                let destintionVC = segue.destination as! SelectDateClassSectionSubjectVC
                destintionVC.trigger = triggering_menu
                triggering_menu = ""
            case "scheduleTermTest":
                let destintionVC = segue.destination as! SelectDateClassSectionSubjectVC
                destintionVC.trigger = triggering_menu
                triggering_menu = ""
            case "to_tests_list":
                _ = segue.destination as! TestDetailsTBC
                triggering_menu = ""
            default:
                break;
        }
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue)   {
        
        
    }
}
