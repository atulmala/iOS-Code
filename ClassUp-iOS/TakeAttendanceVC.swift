//
//  TakeAttendanceVC.swift
//  Classup1
//
//  Created by Atul Gupta on 10/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Just

class TakeAttendanceVC: UIViewController, UITableViewDataSource, UITableViewDelegate    {
    // the below varialbes have been passed by segues in TakeAttendance. They will be used to
    // call the API to get the attendance l of students for a particular class/section/subject combination
    // on the given date
    var d: String = ""
    var m: String = ""
    var y: String = ""
    var school_id: String = ""
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    var student_list: [StudentModel] = []
    var absentee_list: [String] = []
    var absentee_list_main: [String] = []
    var whether_main: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toMainMenu: UIButton!
    
    
    // spinner to be shown during loading of table
    let spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    let loading_label: UILabel = UILabel()
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer)    {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began   {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if tableView.indexPathForRow(at: touchPoint) != nil {
                // get the name of the student
                
                let cell = tableView.cellForRow(at: tableView.indexPathForRow(at: touchPoint)! as IndexPath) as! TakeAttendanceCellTVC
                let student = cell.full_name.text!
                let alert: UIAlertController = UIAlertController(title: "Calling Parent", message: "Do you want to call \(student) 's Parent?", preferredStyle: .alert )
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    let server_ip = MiscFunction.getServerIP()
                    
                    // get the phone number of the parent
                    let student_id = cell.id.text!
                    var mob_no: String = ""
                    var url = "\(server_ip)/student/get_parent/\(student_id)/"
                    url = url.replacingOccurrences(of: " ", with: "%20")
                    let j = JSON(Just.get(url).json!)
                    let the_mob_no = j["parent_mobile1"]
                    let mob = String(stringInterpolationSegment: the_mob_no)
                    mob_no = "tel:\(mob)"
                    let alertController = UIAlertController(title: mob_no, message: mob_no, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    let url1: NSURL = NSURL(string: mob_no)!
                    if (UIApplication.shared.canOpenURL(url1 as URL))
                    {
                        UIApplication.shared.open(url1 as URL, options: [:], completionHandler: nil)
                    }
                    return
                })
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        spinner.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = spinner
        self.automaticallyAdjustsScrollViewInsets = false
        
        // add the long tap functionality. Long tapping on a student's name will initiate a call to the parent
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TakeAttendanceVC.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        
        // call the api to get the list of students, roll number and id
        let server_ip: String = MiscFunction.getServerIP()
        school_id = SessionManager.getSchoolId()
        let student_list_url: String = "\(server_ip)/student/list/" + school_id + "/" +
            the_class + "/" + section + "/?format=json"
        let j = JSON(Just.get(student_list_url).json!)
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
                    student_list.append(StudentModel(id: id, full_name: full_name, roll_no: roll_no, whether_present: true))
                }
            }
        }

        
        // we also need to get the list of absent students for this class/section/subject/date
        var attendance_list_url = "\(server_ip)/attendance/retrieve/" + school_id + "/" +
            the_class + "/" + section + "/" + subject +
            "/" + d + "/" + m + "/" + y + "/?format=json"
        
        // as subject name such as Social Sciences contain spaces, those need to be replace by %20
        
        attendance_list_url = attendance_list_url.replacingOccurrences(of: " ", with: "%20")
 
        MiscFunction.sendRequestToServer(url: attendance_list_url, key: "student", list: &absentee_list, sender: "TakeAttendanceTVC")
        
        // Get also the list of students absent in the main attendance for this date
        // 25/08/2016 - We will only do this is Main subject exist for this school
        if whether_main {
            let main_attendance_list_url = "\(server_ip)/attendance/retrieve/" + school_id + "/" +
                the_class + "/" + section + "/Main"  +
                "/" + d + "/" + m + "/" + y + "/?format=json"
        
            MiscFunction.sendRequestToServer(url: main_attendance_list_url, key: "student", list: &absentee_list_main, sender: "TakeAttendanceTVC")
        }
        
        if subject != "Main"    {
            absentee_list += absentee_list_main
        }

        // set the universal absentee list
        AttendanceProcessing.set_absentee_list(list: absentee_list)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        
        lable.text = "Attendance     \(the_class)-\(section)       \(d)/\(m)/\(y)  \(subject)"
        self.navigationItem.titleView = lable
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return student_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath row=\(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendance_cell", for: indexPath as IndexPath) as! TakeAttendanceCellTVC
        
        
        // Configure the cell...
        // we are storing id, class, section, date, month, and year as hidden in the cell
        // so that we can access them in Cell specific view controller. 
        cell.id.text = student_list[indexPath.row].id
        cell.id.isHidden = true
        cell.the_class.text = the_class
        cell.the_class.isHidden = true
        cell.section.text = section
        cell.section.isHidden = true
        cell.subject.text = subject
        cell.subject.isHidden = true
        cell.day.text = d
        cell.day.isHidden = true
        cell.month.text = m
        cell.month.isHidden = true
        cell.year.text = y
        cell.year.isHidden = true
        
        cell.roll_number.text = student_list[indexPath.row].roll_no
        cell.full_name.numberOfLines = 0
        cell.full_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.full_name.text =  student_list[indexPath.row].full_name
        
        cell.selectionStyle = .none
        // check if this student was absent
        //print("id=\(cell.id.text!)")
        if let _ = AttendanceProcessing.get_absentee_list().index(of: cell.id.text!)  {
            //print("cell on indexpath.row=\(indexPath.row) with id=\(cell.id.text) & full name=\(cell.full_name.text) is absent")
            cell.whether_present.setOn(false, animated: true)
            cell.contentView.backgroundColor = UIColor.orange
        }
        else    {
            //print("cell on indexpath.row=\(indexPath.row) with id=\(cell.id.text) & full name=\(cell.full_name.text) is present")
            cell.isHighlighted = true
            cell.whether_present.setOn(true, animated: true)
            //cell.full_name.textColor = UIColor.greenColor()
            cell.contentView.backgroundColor = UIColor.green
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "attendance_header_cell") as! AttendanceHeaderCell
        header_cell.backgroundColor = UIColor.cyan
        
        header_cell.roll_no.text = "Roll No"
        header_cell.full_name.text = "Full Name"
        header_cell.present_absent.text = "A/P"
        
        return header_cell
    }
    
    @IBAction func submitAttendance(sender: UIButton) {
        // we need to present a confirmation dialog to the teacher before they decide to submit the attendance
        let present_count = student_list.count - AttendanceProcessing.get_absentee_list().count
        let absent_count = AttendanceProcessing.get_absentee_list().count
        let alert: UIAlertController = UIAlertController(title: "Confirm Attendance Submission", message: "Date: \(d)-\(m)-\(y) | Class: \(the_class)-\(section) | Subject: \(subject) | Present = \(present_count), Absent = \(absent_count)", preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let server_ip = MiscFunction.getServerIP()
            let teacher = SessionManager.getLoggedInUser()
            
            // update the server tables to indicate that the attendance for this
            // class/section/subject/date was taken
            var url1 = "\(server_ip)/attendance/attendance_taken/\(self.school_id)/\(self.the_class)/\(self.section)/\(self.subject)/\(self.d)/\(self.m)/\(self.y)/\(teacher)/"
            url1 = url1.replacingOccurrences(of: " ", with: "%20")
            Alamofire.request(url1, method: .post, encoding: JSONEncoding.default).responseJSON { response in
                
            }
            
            // now, submit the details of absentees to the server. For conserving db space, we 
            // only keep track of absent students in a particular class on a particular day for a 
            // particular subject
            
            var dictionary = [String:String]()
            for absentee_id in AttendanceProcessing.get_absentee_list()    {
                dictionary[String(stringInterpolationSegment: absentee_id)] = String(stringInterpolationSegment: absentee_id)
            }
            
            let url: String = ("\(server_ip)/attendance/update1/\(self.school_id)/\(self.the_class)/\(self.section)/\(self.subject)/\(self.d)/\(self.m)/\(self.y)/\(teacher)/").replacingOccurrences(of: " ", with: "%20")
                

            Alamofire.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default)
                .responseJSON { response in
                
                }

            if (AttendanceProcessing.get_correction_list()).count > 0   {
                var dictionary2 = [String:String]()
                for correction_id in AttendanceProcessing.get_correction_list() {
                    dictionary2[String(stringInterpolationSegment: correction_id)] = String(stringInterpolationSegment: correction_id)
                }
                print(dictionary2)
                let url2 = ("\(server_ip)/attendance/delete2/\(self.school_id)/\(self.the_class)/\(self.section)/\(self.subject)/\(self.d)/\(self.m)/\(self.y)/").replacingOccurrences(of: " ", with: "%20")
                Alamofire.request(url2, method: .post, parameters: dictionary2, encoding: JSONEncoding.default).responseJSON { response in
                }
            }
            self.performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
            return
        })
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
        
        return
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //self.navigationItem.backBarButtonItem?.title = ""
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "TakeAttendanceVC"
    }
}
