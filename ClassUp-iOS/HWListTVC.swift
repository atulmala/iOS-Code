//
//  HWListTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 01/05/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class HWModel: NSObject {
    var id: String = ""
    var teacher: String = ""
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    var due_date: String = ""
    var location: String = ""
    var notes: String = ""
    
    init(id: String, teacher: String, the_class: String, section: String, subject: String, due_date: String, location: String, notes: String) {
        self.id = id
        self.teacher = teacher
        self.the_class = the_class
        self.section = section
        self.subject = subject
        self.due_date = due_date
        self.location = location
        self.notes = notes
        
        super.init()
    }
}

class HWListTVC: UITableViewController {
    var hw_list: [HWModel] = []
    
    var coming_from: String = ""
    
    var id: String = ""
    var location = ""
    var destination: String = ""

    var student_id: String = ""
    var student_name: String = ""
    
    var url: String = ""

    @IBOutlet weak var nav_item: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        nav_item.title = "HW List"
        nav_item.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action:#selector(HWListTVC.createHW))
        
        let server_ip: String = MiscFunction.getServerIP()
        let user_id: String = SessionManager.getLoggedInUser()
        
        if coming_from != "HWListForParent"  {
            url = "\(server_ip)/academics/retrieve_hw/\(user_id)/?format=json"
        }
        else    {
            url = "\(server_ip)/academics/retrieve_hw/\(student_id)/?format=json"
        }
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    let teacher: String = j[index]["teacher"].string!
                    let the_class: String = j[index]["the_class"].string!
                    let section: String = j[index]["section"].string!
                    let subject: String = j[index]["subject"].string!
                    
                    let due_date: String = j[index]["due_date"].string!
                    // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
                    let yyyymmdd = due_date
                    let yy = yyyymmdd[2...3]
                    let mm = yyyymmdd[5...6]
                    let dd = yyyymmdd[8...9]
                    let ddmmyy = dd + "/" + mm +  "/"   + yy
                    
                    let location: String = j[index]["location"].string!
                    let notes: String = j[index]["notes"].string!
                    
                    hw_list.append(HWModel(id: id, teacher: teacher, the_class: the_class, section: section, subject: subject, due_date: ddmmyy, location: location, notes: notes))
                }
            }
        }
    }

    func createHW()   {
        destination = "SelectDateClassSubVC"
        performSegue(withIdentifier: "hw_list_to_date_class_sub_selection", sender: self)
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
        return hw_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hw_cell", for: indexPath) as! HWCell

        // Configure the cell...
        cell.id.text = hw_list[indexPath.row].id
        cell.due_date.text = hw_list[indexPath.row].due_date
        
        let class_sec: String = hw_list[indexPath.row].the_class + "-" + hw_list[indexPath.row].section
        cell.the_class.text = class_sec
        
        cell.subject.text = hw_list[indexPath.row].subject
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = hw_list[indexPath.row].id
        location = hw_list[indexPath.row].location
        destination = "ReviewHWVC"
        performSegue(withIdentifier: "show_hw_image", sender: self)
    }
    
    // for swipe delete a test
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            let alert: UIAlertController = UIAlertController(title: "Confirm HW Deletion", message: "Are you sure that you want to delete this Home Work? ", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "Home Work", style: .default, handler: {(action: UIAlertAction) in
                
                let server_ip = MiscFunction.getServerIP()
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! HWCell
                let url = server_ip + "/academics/delete_hw/" + cell.id.text! + "/"
                let r = Just.delete(url)
                if r.statusCode == 200  {
                    let alert: UIAlertController = UIAlertController(title: "Done", message: "Test Deleted", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.destination = "to_main_menu"
                    self.performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
                }
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }
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
        switch destination {
            case "ReviewHWVC":
                let destinationVC = segue.destination as! ReviewHWVC
                destinationVC.sender = "TeacherApp"
                destinationVC.id = id
                destinationVC.location = location
                break
            case "SelectDateClassSubVC":
                let destinationVC = segue.destination as! SelectDateClassSectionSubjectVC
                destinationVC.trigger = "HWListVC"
                break
            default:
                break
        }
        
    }
    

}
