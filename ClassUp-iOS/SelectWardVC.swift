//
//  SelectWardVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 25/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Just

class SelectWardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var trigger: String = ""
    var ward_list: [StudentModel] = []
    var f_name_list: [String] = []
    var l_name_list: [String] = []
    var id_list: [String] = []
    
    var student_name: String = ""
    var student_id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let server_ip: String = MiscFunction.getServerIP()
        let parent: String = SessionManager.getLoggedInUser()
        
        let url = server_ip +
            "/student/student_list_for_parents/" + parent;
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let first_name: String = j[index]["fist_name"].string!
                    let last_name: String = j[index]["last_name"].string!
                    let full_name: String = first_name + " " + last_name
                    
                    var roll_no: String = ""
                    if let _ = j[index]["roll_number"].int {
                        let the_roll_no = j[index]["roll_number"]
                        roll_no = String(stringInterpolationSegment: the_roll_no)
                    }
                    
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    
                    // 18/06/2017 - we are getting parent also in the api call
                    let parent: String = j[index]["parent"].string!
                    ward_list.append(StudentModel(id: id, full_name: full_name, roll_no: roll_no, whether_present: true, parent: parent))
                }
            }
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return ward_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath row=\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ward_list_cell", for: indexPath as IndexPath) as! WardListCellTVC
        
        // Configure the cell...
                cell.ward_name.text = ward_list[indexPath.row].full_name
        cell.ward_id.isHidden = true
        cell.ward_id.text = ward_list[indexPath.row].id
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("a cell has been  tapped")
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! WardListCellTVC
        student_id = cell.ward_id.text!
        student_name = cell.ward_name.text!
        
        // check whether the subscription of the school has expired
        let server_ip: String = MiscFunction.getServerIP()
        let url: String = server_ip +
            "/auth/check_subscription/" + student_id + "/";
                let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let _ = count   {
                    let subscription_status: String = j["subscription"].string!
                    if subscription_status != "expired" {
                        switch trigger  {
                            case "AttendanceSummary":
                                performSegue(withIdentifier: "to_stu_att_summary", sender: self)
                                break
                            case "ExamResult":
                                performSegue(withIdentifier: "to_exam_list", sender: self)
                                break
                            case "SubjectwiseMarks":
                                performSegue(withIdentifier: "to_show_subjects", sender: self)
                                break
                            case "CommunicateWithSchool":
                                performSegue(withIdentifier: "to_message_school", sender: self)
                                break
                            case "HWListForParent":
                                performSegue(withIdentifier: "to_hw_list_parent", sender: self)
                            case "UpcomingTests":
                                performSegue(withIdentifier: "to_upcoming_tests", sender: self)
                            default:
                                break
                        }
                    }
                    else    {
                        let error_message: String = j["error_message"].string!
                        showAlert(title: "School Subscription Expired", message: error_message)
                    }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch trigger  {
            case "AttendanceSummary":
                let destinationVC = segue.destination as! StudentAttendanceSummaryVC
                destinationVC.student_id = student_id
                destinationVC.student_full_name = student_name
                break
            case "ExamResult":
                let destinationVC = segue.destination as! SelectExamTermVC
                destinationVC.student_id = student_id
                destinationVC.student_full_name = student_name
                break
            case "SubjectwiseMarks":
                let destinationVC = segue.destination as! SubjectSelectionVC
                destinationVC.student_id = student_id
                destinationVC.student_full_name = student_name
            case "CommunicateWithSchool":
                let destinationVC = segue.destination as! MessageToSchoolVC
                destinationVC.student_id = student_id
            case "HWListForParent":
                let destinationVC = segue.destination as! HWListTVC
                destinationVC.student_id = student_id
                destinationVC.student_name = student_name
                destinationVC.coming_from = "HWListForParent"
                break
            case "UpcomingTests":
                let destinationVC = segue.destination as! UpcomingTestTVC
                destinationVC.student_id = student_id
                destinationVC.student_full_name = student_name
                break
            default:
                break
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
