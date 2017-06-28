//
//  BusAttendanceVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 31/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Just

class BusAttendanceVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selected_rout: String = ""
    var selected_rout_type: String = ""
    var d: String = ""
    var m: String = ""
    var y: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toMainMenu: UIButton!
    var already_taken: Bool = false
    
    var stop_list: [String] = []
    var student_list: [StudentStopModel] = []
    var current_absent_list: [String] = []
    var correction_list: [String] = []
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer)    {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began   {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if tableView.indexPathForRow(at: touchPoint) != nil {
                // ge the name of the student
                
                let cell = tableView.cellForRow(at: tableView.indexPathForRow(at: touchPoint)! as IndexPath) as! BusAttendanceCellTVC
                let student = cell.student_name.text!
                let alert: UIAlertController = UIAlertController(title: "Calling Parent", message: "Do you want to call \(student) 's Parent?", preferredStyle: .alert )
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    let server_ip = MiscFunction.getServerIP()
                    
                    // get the phone number of the parent
                    let student_id = cell.student_id.text!
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the long tap functionality. Long tapping on a student's name will initiate a call to the parent
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TakeAttendanceVC.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)

        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        // check if an attendnce was taken earlier on this rout/date
        
        var url: String = ("\(server_ip)/bus_attendance/attendance_taken_earlier/\(school_id)/\(selected_rout)/\(d)/\(m)/\(y)/").replacingOccurrences(of: " ", with: "%20")
        let j1 = JSON(Just.get(url).json!)
        already_taken = j1["taken_earlier"].boolValue
        
        // 18/11/2016 - get the list of stops on this rout
        url = ("\(server_ip)/bus_attendance/retrieve_bus_stops/\(school_id)/\(selected_rout)/?format=json").replacingOccurrences(of: " ", with: "%20")
        let j2 = JSON(Just.get(url).json!)
        var count: Int? = j2.count
        if (count! > 0)  {
            if let ct = count{
                for index in 0...ct-1   {
                    var stop_name = ""
                    if let _ = j2[index]["stop_name"].string {
                        stop_name = j2[index]["stop_name"].string!
                    }
                    stop_list.append(stop_name)
                }
            }
        }
        
        
        // get the list of students for each stop on this rout
        for stop in stop_list   {
            let student: StudentStopModel = StudentStopModel(id: "", full_name: "", bus_stop: stop, roll_no: "", whether_present: true)
            student_list.append(student)
            url = ("\(server_ip)/bus_attendance/list_rout_students1/\(school_id)/\(selected_rout)/\(stop)/?format=json").replacingOccurrences(of: " ", with: "%20")
            let j = JSON(Just.get(url).json!)
            
            count = j.count
            if (count! > 0)  {
                if let ct = count {
                    for index in 0...ct-1 {
                        var full_name: String = ""
                        full_name = String(stringInterpolationSegment: index+1)
                        
                        var id: String = ""
                        if let first_name = j[index]["fist_name"].string {
                            full_name += ". \(first_name)"
                        }
                        if let last_name = j[index]["last_name"].string {
                            full_name += " \(last_name)"
                        }
                        if let current_class = j[index]["current_class"].string {
                            full_name += " (\(current_class)-"
                        }
                        if let current_section = j[index]["current_section"].string {
                            full_name += "\(current_section))"
                        }
                        if let _ = j[index]["id"].int  {
                            let the_id = j[index]["id"]
                            id = String(stringInterpolationSegment: the_id)
                            // when taking attendance for the first time, initally every student is considered to be absent
                            if !already_taken   {
                                current_absent_list.append(id)
                            }
                        }
                        let student: StudentStopModel = StudentStopModel(id: id, full_name: full_name, bus_stop: "", roll_no: "", whether_present: true)
                        student_list.append(student)
                    }
                }
            }
        }
        if (already_taken)    {
            // get the list of students who are absent in the earlier attendance on this rout/date
            url = ("\(server_ip)/bus_attendance/retrieve_bus_attendance/\(school_id)/\(selected_rout)/\(selected_rout_type)/\(d)/\(m)/\(y)/?format=json").replacingOccurrences(of: " ", with: "%20")
            
            let j2 = JSON(Just.get(url).json!)
            count = j2.count
            if (count! > 0)  {
                if let ct = count   {
                    for index in 0...ct-1   {
                        let abs_id = j2[index]["student"].intValue
                        for i in 0...student_list.count-1 {
                            if student_list[i].id == String(stringInterpolationSegment: abs_id)  {
                                student_list[i].whether_present = false
                                current_absent_list.append(String(stringInterpolationSegment: abs_id))
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let submit_btn = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(BusAttendanceVC.submitBusAttendance(sender:)))
        navigationItem.rightBarButtonItems = [submit_btn,]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return student_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        _ = tableView.dequeueReusableCell(withIdentifier: "bus_attendance_cell", for: indexPath as IndexPath) as! BusAttendanceCellTVC
        if student_list[indexPath.row].bus_stop == ""   {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "bus_attendance_cell", for: indexPath as IndexPath) as! BusAttendanceCellTVC
            
            // Configure the cell...
            
            cell.student_name.text =  student_list[indexPath.row].full_name
            cell.student_id.text = student_list[indexPath.row].id
            cell.student_id.isHidden = true
            
            if already_taken    {
                if !current_absent_list.contains(student_list[indexPath.row].id)  {
                    cell.accessoryType = .checkmark
                    cell.backgroundColor = UIColor.clear
                }
                else    {
                    cell.accessoryType = .none
                    cell.backgroundColor = UIColor.yellow
                }
            }
            else    {
                if current_absent_list.contains(student_list[indexPath.row].id) {
                    cell.accessoryType = .none
                }
                else    {
                    cell.accessoryType = .checkmark
                }
            }
            return cell
        }
        else    {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "bus_attendance_header_cell") as! BusAttendanceHeaderCell
            headerCell.backgroundColor = UIColor.cyan
            headerCell.bus_stop.text = student_list[indexPath.row].bus_stop
            
            return headerCell
        }
        //return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if the row is section header (bus stop name) then we need to do nothing!
        if student_list[indexPath.row].bus_stop == ""   {
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! BusAttendanceCellTVC!
            
            if cell?.accessoryType == .checkmark    {
                cell?.accessoryType = .none
                
                // the student has to be marked absent
                if current_absent_list.index(of: (cell?.student_id.text!)!) == nil{
                    current_absent_list.append((cell?.student_id.text!)!)
                }
                if correction_list.contains((cell?.student_id.text!)!)  {
                    correction_list.remove(at: correction_list.index(of: (cell?.student_id.text!)!)!)
                }
                print("current_absent_list=\(current_absent_list)")
                print("correction_lust=\(correction_list)")
            }
            else    {
                cell?.accessoryType = .checkmark
                cell?.backgroundColor = UIColor.clear
                
                // the student is to be marked as present
                if current_absent_list.contains((cell?.student_id.text!)!) {
                    current_absent_list.remove(at: current_absent_list.index(of: (cell?.student_id.text!)!)!)
                }
                if !correction_list.contains((cell?.student_id.text!)!) {
                    correction_list.append((cell?.student_id.text!)!)
                }
                print("current_absent_list=\(current_absent_list)")
                print("correction_lust=\(correction_list)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    @IBAction func submitBusAttendance(sender: UIButton) {
        let present_count = student_list.count - stop_list.count - current_absent_list.count
        let absent_count = current_absent_list.count
        let alert: UIAlertController = UIAlertController(title: "Confirm Attendance Submission", message: "Date: \(d)-\(m)-\(y) | Rout: \(selected_rout) | Present = \(present_count), Absent = \(absent_count)", preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            
            //var t: TakeAttendanceVC = self
            
            let server_ip = MiscFunction.getServerIP()
            let teacher = SessionManager.getLoggedInUser()
            // update the server tables to indicate that the attendance for this
            // rout/date was taken
            let url1 = ("\(server_ip)/bus_attendance/bus_attendance_taken/\(school_id)/\(self.selected_rout)/\(self.selected_rout_type)/\(self.d)/\(self.m)/\(self.y)/\(teacher)/").replacingOccurrences(of: " ", with: "%20")
            
            Alamofire.request(url1, method: .post, encoding: JSONEncoding.default).responseJSON { response in
                
            }
            
            // now, submit the details of absentees to the server.
            var dictionary = [String:String]()
            for absentee_id in self.current_absent_list    {
                dictionary[String(stringInterpolationSegment: absentee_id)] = String(stringInterpolationSegment: absentee_id)
            }
            
            let url = ("\(server_ip)/bus_attendance/process_bus_attendance1/\(self.selected_rout_type)/\(self.d)/\(self.m)/\(self.y)/\(teacher)/").replacingOccurrences(of: " ", with: "%20")
            
            
            Alamofire.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
            }
            
            // submit the correction list. Those are the students which were marked absent and now turned present
            var dictionary2 = [String:String]()
            for correction_id in self.correction_list   {
                dictionary2[String(stringInterpolationSegment: correction_id)] = String(stringInterpolationSegment: correction_id)
            }
            let url2 = ("\(server_ip)/bus_attendance/delete_bus_attendance1/\(self.selected_rout_type)/\(self.d)/\(self.m)/\(self.y)/").replacingOccurrences(of: " ", with: "%20")
            Alamofire.request(url2, method: .post, parameters: dictionary2, encoding: JSONEncoding.default)
            .responseJSON { response in
                
            }

            self.performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
            return
            
            
        })
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
        return
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "BusAttendanceVC"
    }

    
}
