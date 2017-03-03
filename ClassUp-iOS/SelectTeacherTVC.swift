//
//  SelectTeacherTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 01/03/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//
import UIKit
import SwiftyJSON
import Just

class TeacherModel:NSObject {
    var id: String
    var name: String
    var login_id: String
    var mobile: String
    
    init(id: String, name: String, login_id: String, mobile: String)    {
        self.id = id
        self.name = name
        self.login_id = login_id
        self.mobile = mobile
        
        super.init()
    }
}


class SelectTeacherTVC: UITableViewController {
    var id: String = ""
    var name: String = ""
    var login_id: String = ""
    var mobile: String = ""
    
    var teacher_list: [TeacherModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
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
            }
        }
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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = teacher_list[indexPath.row].id
        name = teacher_list[indexPath.row].name
        mobile = teacher_list[indexPath.row].mobile
        login_id = teacher_list[indexPath.row].login_id
        
        performSegue(withIdentifier: "edit_teacher", sender: self)
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
        let destinationVC = segue.destination as! EditTeacher
        destinationVC.teacher_id = id
        destinationVC.teacher_name = name
        destinationVC.teacher_login = login_id
        destinationVC.teacher_mobile = mobile
    }
}
