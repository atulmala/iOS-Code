//
//  TakeAttendanceTVC.swift
//  Classup1
//
//  Created by Atul Gupta on 03/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import UIKit

class TakeAttendanceTVC: UITableViewController {
    @IBOutlet weak var navigation_bar: UINavigationItem!
    // the below varialbes have been passed by segues in TakeAttendance. They will be used to 
    // call the API to get the attendance l of students for a particular class/section/subject combination
    // on the given date
    var d: String = ""
    var m: String = ""
    var y: String = ""
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    var student_list: [StudentModel] = []
    var absentee_list: [String] = []
    var absentee_list_main: [String] = []

    override func viewDidLoad() {
        var f_name_list: [String] = []
        var l_name_list: [String] = []
        var roll_no_list: [String] = []
        var id_list: [String] = []
        
        
        super.viewDidLoad()
        // call the api to get the list of students, roll number and id
        let server_ip: String = MiscFunction.getServerIP()
        let student_list_url: String = "\(server_ip)//student/list/" + the_class + "/" + section + "/?format=json"
        //println("stundent_list_url=\(student_list_url)")
        MiscFunction.sendRequestToServer(student_list_url, key: "fist_name", list: &f_name_list, sender: "TakeAttendanceTVC")
        MiscFunction.sendRequestToServer(student_list_url, key: "last_name", list: &l_name_list, sender: "TakeAttendanceTVC")
        MiscFunction.sendRequestToServer(student_list_url, key: "roll_number", list: &roll_no_list, sender: "TakeAttendanceTVC")
        MiscFunction.sendRequestToServer(student_list_url, key: "id", list: &id_list, sender: "TakeAttendanceTVC")
        
        // we also need to get the list of absent students for this class/section/subject/date
        let attendance_list_url = "\(server_ip)/attendance/retrieve/" +
            the_class + "/" + section + "/" + subject +
            "/" + d + "/" + m + "/" + y + "/?format=json"
        MiscFunction.sendRequestToServer(attendance_list_url, key: "student", list: &absentee_list, sender: "TakeAttendanceTVC")
        
        // Get also the list of students absent in the main attendance for this date
        let main_attendance_list_url = "\(server_ip)/attendance/retrieve/" +
            the_class + "/" + section + "/Main"  +
            "/" + d + "/" + m + "/" + y + "/?format=json"
        
        MiscFunction.sendRequestToServer(main_attendance_list_url, key: "student", list: &absentee_list_main, sender: "TakeAttendanceTVC")
        
        absentee_list += absentee_list_main
        
        for (var i=0; i<id_list.count; i++)     {
            student_list.append(StudentModel(id: id_list[i], full_name: (f_name_list[i] + " " + l_name_list[i]), roll_no: roll_no_list[i], whether_present: true))
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        //nav?.barTintColor = UIColor.yellowColor()
        self.navigationItem.title = "Roll No       Name           P/A"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return student_list.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("attendance_cell", forIndexPath: indexPath) as! TakeAttendanceCellTVC

        // Configure the cell...
        cell.full_name.numberOfLines = 0
        cell.full_name.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.full_name.text =  student_list[indexPath.row].full_name
        cell.roll_number.text = student_list[indexPath.row].roll_no
        // check if this student was absent
        if (absentee_list.count > 0)    {
            if let _ = absentee_list.indexOf(student_list[indexPath.row].id)
              {
                //println("student with id=\(student_list[indexPath.row].id) is absent")
                cell.whether_present.setOn(false, animated: false)
                cell.backgroundColor = UIColor.redColor()
            }
            else    {
                cell.whether_present.setOn(true, animated: false)
                cell.backgroundColor = UIColor.greenColor()
            }
        }

        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //self.navigationItem.backBarButtonItem?.title = ""
    }


}
