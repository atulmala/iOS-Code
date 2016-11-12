//
//  SelectStudentVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 08/01/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class SelectStudentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var the_class: String = ""
    var section: String = ""
    var student_list: [StudentModel] = []
    var selected_student: [String] = []

    @IBOutlet weak var tableView: UITableView!
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer)    {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began   {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if tableView.indexPathForRow(at: touchPoint) != nil {
                // ge the name of the student
                
                let cell = tableView.cellForRow(at: tableView.indexPathForRow(at: touchPoint)! as IndexPath) as! StudentSelectionCell
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the long tap functionality. Long tapping on a student's name will initiate a call to the parent
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TakeAttendanceVC.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        
        lable.text = "Please Select Student"
        self.navigationItem.titleView = lable
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return student_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "student_selection_cell", for: indexPath as IndexPath) as! StudentSelectionCell
        
        // Configure the cell...
        // we are storing id, class, section, date, month, and year as hidden in the cell
        // so that we can access them in Cell specific view controller.
        cell.id.text = student_list[indexPath.row].id
        cell.id.isHidden = true
       
        cell.roll_no.text = student_list[indexPath.row].roll_no as String
        cell.full_name.numberOfLines = 0
        cell.full_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.full_name.text =  student_list[indexPath.row].full_name as String
        
        cell.selectionStyle = .none
        if (selected_student.index(of: student_list[indexPath.row].id as String) != nil)  {
            cell.accessoryType = .checkmark
        }
        else    {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! StudentSelectionCell!
        
        if cell?.accessoryType == .checkmark    {
            cell?.accessoryType = .none
            if selected_student.index(of: (cell?.id.text!)!) != nil{
                selected_student.remove(at: selected_student.index(of: (cell?.id.text!)!)!)
            }
            
        }
        else    {
            cell?.accessoryType = .checkmark
            
            if selected_student.index(of: (cell?.id.text!)!) == nil{
                selected_student.append((cell?.id.text!)!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func composeMessage(sender: UIButton) {
        if selected_student.isEmpty {
            showAlert(title: "Error", message: "Please select at least one Student!")
        }
        else    {
            performSegue(withIdentifier: "toComposeMessage", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! ComposeMessageVCViewController
        destinationVC.student_list = selected_student
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
