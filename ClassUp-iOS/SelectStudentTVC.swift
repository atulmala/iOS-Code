//
//  SelectStudentTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 24/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class SelectStudentTVC: UITableViewController {
    var the_class: String = ""
    var section: String = ""
    var student_list: [StudentModel] = []
    var student_id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the api to get the list of students, roll number and id
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let student_list_url: String = "\(server_ip)/student/list/\(school_id)/" + the_class + "/" + section + "/?format=json"
        let j = JSON(Just.get(student_list_url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let first_name: String = j[index]["fist_name"].string!
                    let last_name: String = j[index]["last_name"].string!
                    
                    
                    var roll_no: String = ""
                    if let _ = j[index]["roll_number"].int {
                        let the_roll_no = j[index]["roll_number"]
                        roll_no = String(stringInterpolationSegment: the_roll_no)
                    }
                    
                    let full_name: String = roll_no + "   " + first_name + " " + last_name
                    
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    student_list.append(StudentModel(id: id, full_name: full_name, roll_no: roll_no, whether_present: true))
                }
            }
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return student_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student_cell", for: indexPath) as! StuNameCell

        // Configure the cell...
        cell.student_id.text = student_list[indexPath.row].id as String
        cell.student_name.text = student_list[indexPath.row].full_name as String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StuNameCell
        student_id = cell.student_id.text!
        
        performSegue(withIdentifier: "updateStudent", sender: self)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! AddStudentVC
        vc.student_id = student_id
        vc.operation = "Update"
    }
    

}
