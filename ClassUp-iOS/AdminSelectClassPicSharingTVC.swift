//
//  AdminSelectClassPicSharingTVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 30/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Just

class AdminSelectClassPicSharingTVC: UITableViewController {
    var image: UIImage!
    var coming_from: String = ""
    var message: String = ""
    
    var class_list: [ClassListSource] = []
    var selection: [String] = []
    var cancelled = true

    override func viewDidLoad() {
        super.viewDidLoad()

        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let url: String = "\(server_ip)/academics/class_list/\(school_id)/?format=json";
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let the_class: String = j[index]["standard"].string!
                    class_list.append(ClassListSource(the_class: the_class))
                }
                class_list.append(ClassListSource(the_class: "Teachers"))
                class_list.append(ClassListSource(the_class: "Staff"))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        
        lable.text = "Please Select Classes"
        self.navigationItem.titleView = lable
        
        let upload_button = UIBarButtonItem(title: "Upload", style: .done, target: self, action: #selector(AdminSelectClassPicSharingTVC.upload(sender:)))
        navigationItem.rightBarButtonItems = [upload_button,]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return class_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "class_selection_cell", for: indexPath as IndexPath) as! ClassListCell
        
        // Configure the cell...
        // we are storing id, class, section, date, month, and year as hidden in the cell
        // so that we can access them in Cell specific view controller.
        cell.the_class.text = class_list[indexPath.row].the_class
        
        cell.selectionStyle = .none
        if (selection.index(of: class_list[indexPath.row].the_class as String) != nil)  {
            cell.accessoryType = .checkmark
        }
        else    {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! ClassListCell!
        
        if cell?.accessoryType == .checkmark    {
            cell?.accessoryType = .none
            if selection.index(of: (cell?.the_class.text!)!) != nil{
                selection.remove(at: selection.index(of: (cell?.the_class.text!)!)!)
            }
        }
        else    {
            cell?.accessoryType = .checkmark
            
            if selection.index(of: (cell?.the_class.text!)!) == nil{
                selection.append((cell?.the_class.text!)!)
            }
        }
    }
    
    @IBAction func upload(sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "Confirm Message(s) Sending", message: "Are you sure to Uplod Pic/Video to Selected Classes?", preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction =
            UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                self.cancelled = false
                let random = Int.random(in: 0 ..< 100000)
                let teacher: String = SessionManager.getLoggedInUser()
                let imageFileName: String = "\(teacher)_\(String(random)).jpg"
                let imageData:NSData = UIImageJPEGRepresentation(self.image, 85)! as NSData
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                let school_id = SessionManager.getSchoolId()
                let user = SessionManager.getLoggedInUser()
                let whole_school = "false"
                let message_text = self.message
                var dict = [String:String]()
                var classes_array: [String] = []
                for i in 0 ..< self.selection.count  {
                    classes_array.append(self.selection[i])
                    dict[self.selection[i]] = self.selection[i]
                }
                
                // prepare the json
                let jsonObject: [String:AnyObject] = [
                    "school_id": school_id as AnyObject,
                    "user": user as AnyObject,
                    "whole_school": whole_school as AnyObject,
                    "message_text": message_text as AnyObject,
                    "classes_array": classes_array as AnyObject,
                    "image_included": "yes" as AnyObject,
                    "image_name": imageFileName as AnyObject,
                    "image": strBase64 as AnyObject
                ]
                
                let server_ip = MiscFunction.getServerIP()
                let url = "\(server_ip)/operations/send_bulk_sms/"
                Alamofire.request(url, method: .post, parameters: jsonObject, encoding: JSONEncoding.default).responseJSON { response in
                    
                }
                self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
                self.dismiss(animated: true, completion: nil)
                return
            })
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAdminMenu"  {
            let destinationVC = segue.destination as! SchoolAdminVC
            destinationVC.comingFrom = "pic_share"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
