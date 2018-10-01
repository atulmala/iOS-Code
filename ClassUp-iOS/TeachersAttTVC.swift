//
//  TeachersAttTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 13/11/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AWSMobileAnalytics
import Just


class TeachersAttTVC: UITableViewController {
    var d: String = ""
    var m: String = ""
    var y: String = ""
    
    var teacher_list: [TeacherModel] = []
    var absent_list: [String] = []
    var correction_list: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Initiated Teacher Attendance")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
        
        let url: String = "\(server_ip)/teachers/teacher_list/\(school_id)"
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let teacher_name: String = j[index]["first_name"].string!
                    let full_name: String = teacher_name
                    
                    let email: String = j[index]["email"].string!
                    let mobile: String = j[index]["mobile"].string!
                    
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    teacher_list.append(TeacherModel(id: id, name: full_name, login_id: email, mobile: mobile))
                }
                print ("teacher list = ")
                print(self.teacher_list)
            }
        }
        
        let url1: String = "\(server_ip)/teachers/retrieve_attendance/\(school_id)/\(d)/\(m)/\(y)/?fomat=json"
        let j1 = JSON(Just.get(url1).json!)
        let count1: Int? = j1.count
        if (count1! > 0) {
            if let ct = count1{
                for index in 0...ct-1  {
                    var id: String = ""
                    if let _ = j1[index]["teacher"].int {
                        let the_id = j1[index]["teacher"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    absent_list.append(id)
                }
                print("A absent list = ")
                print(dump(absent_list))

            }
        }
        
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.left
        
        lable.text = "Teacher Att \(d)/\(m)/\(y)"
        self.navigationItem.titleView = lable
        
        // 25/06/2017 - moving the submit button to the navigation bar
        
        let submit_button = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(TeachersAttTVC.submitAttendance))
        navigationItem.rightBarButtonItems = [submit_button]
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return teacher_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacher_cell", for: indexPath) as! TeacherCell
        
        // Configure the cell...
        
        cell.teacher_name.text = teacher_list[indexPath.row].name
        //cell.selectionStyle = .none
        if (!absent_list.contains(teacher_list[indexPath.row].id as String)) {
            cell.accessoryType = .checkmark
        }
        else    {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! TeacherCell
        if cell.accessoryType == .checkmark {
            // the teacher is being markes as absence. Add the id to absent list
            cell.accessoryType = .none
            absent_list.append(teacher_list[indexPath.row].id as String)
            print ("absent list = ")
            print (absent_list)
            
            if correction_list.contains(teacher_list[indexPath.row].id as String)   {
                correction_list.remove(at: correction_list.index(of: teacher_list[indexPath.row].id as String)!)
                print ("correction list = ")
                print (correction_list)
            }
        }
        else{
            // teacher is being markes as present
            cell.accessoryType = .checkmark
            absent_list.remove(at: absent_list.index(of: teacher_list[indexPath.row].id as String)!)
            print ("absent list = ")
            print (absent_list)
            correction_list.append(teacher_list[indexPath.row].id as String)
            print ("correction list = ")
            print (correction_list)
        }
    }
    
    func submitAttendance ()    {
        var corrections = [String:String]()
        var absentees = [String:String]()
        
        for c in correction_list    {
            corrections[c] = c
        }
        
        for a in absent_list    {
            absentees[a] = a
        }
        
        let total = teacher_list.count
        let absent = absent_list.count
        let present = total - absent
        
        let alert: UIAlertController = UIAlertController(title: "Confirm Teacher Attendance Submission", message: "Date: \(d)-\(m)-\(y)  | Total: \(total) | Present: \(present), Absent: \(absent)", preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
            let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
            let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Conducted Teacher Attendance")
            eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
            eventClient.record(event)
            eventClient.submitEvents()
        
            let dictionary: [String: Any] = ["corrections": corrections,
                                          "absentees": absentees]
            let server_ip = MiscFunction.getServerIP()
            let school_id = SessionManager.getSchoolId()
            let url: String = ("\(server_ip)/teachers/process_attendance/\(school_id)/\(self.d)/\(self.m)/\(self.y)/")
            Alamofire.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
            }
            self.performSegue(withIdentifier: "gotoAdminMenu", sender: self)
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
        return
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
