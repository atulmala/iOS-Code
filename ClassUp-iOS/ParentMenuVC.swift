//
//  ParentMenuVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 25/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ParentMenuVC: UIViewController {
    var triggeringMenu : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassword(sender: UIButton) {
        triggeringMenu = "ParentChangePassword"
        performSegue(withIdentifier: "parentChangePassword", sender: self)
    }
    
    @IBAction func logout(sender: UIButton) {
        triggeringMenu = "Logout"
        performSegue(withIdentifier: "parentLogout", sender: self)
    }

    @IBAction func attendanceSummary(sender: UIButton) {
        triggeringMenu = "AttendanceSummary"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    
    @IBAction func examResult(sender: UIButton) {
        triggeringMenu = "ExamResult"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    
    @IBAction func sbujectwiseMarks(sender: UIButton) {
        triggeringMenu = "SubjectwiseMarks"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    
    @IBAction func show_hw_list(_ sender: UIButton) {
        triggeringMenu = "HWListForParent"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    
    @IBAction func show_days_of_week(_ sender: UIButton) {
        triggeringMenu = "TimeTable"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    @IBAction func upcoming_test(_ sender: UIButton)    {
        triggeringMenu = "UpcomingTests"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    
    @IBAction func show_comm_center(_ sender: UIButton) {
        triggeringMenu = "CommCenter"
        performSegue(withIdentifier: "show_comm_center", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch triggeringMenu   {
            case "CommunicationHistory":
                _ = segue.destination as! MessageHistoryVC
                break
            case "AttendanceSummary":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = triggeringMenu
                break
            case "ExamResult":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = triggeringMenu
                break
            case "SubjectwiseMarks":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = triggeringMenu
                break
            case "CommunicateWithSchool":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = "CommunicateWithSchool"
            case "HWListForParent":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = "HWListForParent"
            case "UpcomingTests":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = "UpcomingTests"
            case "TimeTable":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = "TimeTable"
                break
        case "image_video":
                let destinationVC = segue.destination as! SelectWardVC
                destinationVC.trigger = "image_video"
                break
            default:
                break
        }
    }

}
