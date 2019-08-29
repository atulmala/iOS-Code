//
//  SelStudForImageSharingTVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 29/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just
import Alamofire

class StudListForPicSharingTVC: UITableViewController {
    var image: UIImage!
    
    var coming_from = "share_pic"
    var brief_description: String = ""
    
    var the_class: String = ""
    var section: String = ""
    var student_id: String = ""
    var student_list: [StudentModel] = []
    var selected_student: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    var roll_no: String = String(index + 1)
                    if roll_no.count > 1 {
                        roll_no = roll_no + ". "
                    }
                    else{
                        roll_no = roll_no + ".  "
                    }
                    
                    let full_name: String = roll_no + "   " + first_name + " " + last_name
                    
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    
                    let parent: String = j[index]["parent"].string!
                    student_list.append(StudentModel(id: id, full_name: full_name, roll_no: roll_no, whether_present: true, parent: parent))
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let share_button = UIBarButtonItem(title: "Share Now", style: .done, target: self, action: #selector(StudListForPicSharingTVC.share_now(sender:)))
        navigationItem.rightBarButtonItems = [share_button,]
    }
    
    @IBAction func share_now(sender: UIButton) {
        let random = Int.random(in: 0 ..< 100000)
        let teacher: String = SessionManager.getLoggedInUser()
        let school_id: String = SessionManager.getSchoolId()
        let imageFileName: String = "\(teacher)_\(the_class)_\(section)_\(String(random)).jpg"
        let imageData:NSData = UIImageJPEGRepresentation(image, 85)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        let alert: UIAlertController = UIAlertController(title: "Confirm Media Sharing", message: "Are you sure to share this Image/Video?", preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            
            let jsonObject: [String:AnyObject] = [
                "image": strBase64 as AnyObject,
                "image_name": imageFileName as AnyObject,
                "description": self.brief_description as AnyObject,
                "whole_class": "false" as AnyObject,
                "student_list": self.selected_student as AnyObject,
                "class": self.the_class as AnyObject,
                "section": self.section as AnyObject,
                "teacher": SessionManager.getLoggedInUser() as AnyObject,
                "school_id": school_id as AnyObject
            ]
            var dict = [String:String]()
            dict["image"] = strBase64
            dict["image_name"] = imageFileName
            dict["description"] = self.brief_description
            dict["whole_class"] = "true"
            dict["class"] = self.the_class
            dict["section"] = self.section
            dict["teacher"] = SessionManager.getLoggedInUser()
            dict["school_id"] = school_id
            
            let server_ip = MiscFunction.getServerIP()
            let url = "\(server_ip)/pic_share/upload_pic/"
            Alamofire.request(url, method: .post, parameters: jsonObject, encoding: JSONEncoding.default).responseJSON { response in
                switch
                response.result   {
                    
                case .success(let JSON):
                    debugPrint(response)
                    let response = JSON as! NSDictionary
                    let message = response.object(forKey: "message")
                    
                case .failure(let JSON):
                    let response = JSON as! NSDictionary
                    let message = response.object(forKey: "message")
                    
                }
                
            }
            self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
            self.dismiss(animated: true, completion: nil)
            return
        })
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student_cell", for: indexPath) as! StuNameCell
        
        // Configure the cell...
        cell.student_id.text = student_list[indexPath.row].id as String
        cell.student_name.text = student_list[indexPath.row].full_name as String
        
        cell.selectionStyle = .none
        if (selected_student.index(of: student_list[indexPath.row].id as String) != nil)  {
            cell.accessoryType = .checkmark
        }
        else    {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! StuNameCell!
        
        if cell?.accessoryType == .checkmark    {
            cell?.accessoryType = .none
            if selected_student.index(of: (cell?.student_id.text!)!) != nil{
                selected_student.remove(at: selected_student.index(of: (cell?.student_id.text!)!)!)
            }
            
        }
        else    {
            cell?.accessoryType = .checkmark
            
            if selected_student.index(of: (cell?.student_id.text!)!) == nil{
                selected_student.append((cell?.student_id.text!)!)
            }
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "image_sharing"
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
