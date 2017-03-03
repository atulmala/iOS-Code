//
//  AddStudentVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 19/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddStudentVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var student_id: String = ""
    var operation: String = "Add"
    

    @IBOutlet weak var reg_no: UITextField!
    @IBOutlet weak var first_name: UITextField!
    
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var parent_name: UITextField!
    @IBOutlet weak var mobile1: UITextField!
    
    @IBOutlet weak var class_section_picker: UIPickerView!
    @IBOutlet weak var mobile2: UITextField!
    @IBOutlet weak var roll_no: UITextField!
    @IBOutlet weak var lbl_roll_no: UILabel!
    
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_update: UIButton!
    
    
    
    // lists to hold classes, sections
    var class_list: [String] = []
    var section_list: [String] = []
    var class_section_list: [[String]] = [[], []]
    
    var selected_class: String = ""
    var selected_section: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        // when the keyboard appears, the cells in the bottom gets hidden. We need to move the cells up
        // when the keyboard appears. So we register for keyboard notification
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        
        let sectionURL = "\(server_ip)/academics/section_list/\(school_id)/?format=json"
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectClassSectionVC")
        MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectClassSectionVC")
        class_section_list[0] = class_list
        class_section_list[1] = section_list
        
        // 24/02/17 if this view is opened for updating a student, we need to fetch the student details
        if operation == "Update"    {
            // change the title of the screen
            self.title = "Update Student"
            
            
            // show the delete  & update buttons
            btn_delete.isHidden = false
            btn_delete.isEnabled = true
            btn_update.isHidden = false
            btn_update.isEnabled = true
            
            // hide the add button
            btn_add.isHidden = true
            
            // roll no is no longer optional
            lbl_roll_no.text = "Roll No"
            
            // registration number cannot be edited in Update mode
            reg_no.isEnabled = false
            
            
            // get the details of the student
            let url = "\(server_ip)/student/get_student_detail/\(student_id)"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                if let value: AnyObject = response.result.value as AnyObject? {
                    // handle the results as JSON, without a bunch of nested if loops
                    let response = JSON(value)
                    print(response)
                    self.reg_no.text = response["erp_id"].string
                    self.first_name.text = response["first_name"].string
                    self.last_name.text = response["last_name"].string
                    self.parent_name.text = response["parent_name"].string
                    self.mobile1.text = response["parent_mobile1"].string
                    self.mobile2.text = response["parent_mobile2"].string
                    self.roll_no.text = response["roll_no"].string
                    
                    // show the current class & section in the picker
                    let current_class: String = response["class"].string!
                    let current_section: String = response["section"].string!
                    let class_index: Int = self.class_list.index(of: current_class)!
                    let section_index: Int = self.section_list.index(of: current_section)!
                    
                    self.class_section_picker.selectRow(class_index, inComponent: 0, animated: true)
                    self.class_section_picker.selectRow(section_index, inComponent: 1, animated: true)
                    
                }else    {
                    self.showAlert(title: "Error", message: "Failed to fetch student details. Please check your internet connection")
                }
            }

        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return class_section_list[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return class_section_list[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_class = class_section_list[0][pickerView.selectedRow(inComponent: 0)]
        selected_section = class_section_list[1][pickerView.selectedRow(inComponent: 1)]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    @IBAction func addStudent(_ sender: AnyObject) {
        operation = "AddStudent"
        
        //check for blank values
        let r_no: String = reg_no.text!
        if r_no == ""   {
            showAlert(title: "Error", message: "Registration number is blank")
            return
        }
        
        let f_name: String = first_name.text!
        if f_name == "" {
            showAlert(title: "Error", message: "First Name is blank")
            return
        }
        
        let l_name: String = last_name.text!
        if l_name == ""     {
            showAlert(title: "Error", message: "Last Name is blank")
            return
        }
        
        let p_name: String = parent_name.text!
        if p_name == "" {
            showAlert(title: "Error", message: "Parent Name is blank")
            return
        }
        
        let m1: String = mobile1.text!
        if m1 == "" {
            showAlert(title: "Error", message: "Mobile1 is blank")
            return
        }
        
        if m1.characters.count != 10    {
            showAlert(title: "Error", message: "Mobile1 should be exactly 10 digits")
                return
        }
        
        let m2: String = mobile2.text!
        if m2 != "" {
            if m2.characters.count != 10    {
                showAlert(title: "Error", message: "Mobile2 should be exactly 10 digits")
                return
            }
        }
        
        let rl_no: String = roll_no.text!
        
        // after basic validations are done, we need to check that this registration number is not already in use
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let url: String = "\(server_ip)/setup/check_reg_no/?school_id=\(school_id)&reg_no=\(r_no)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                if let value: AnyObject = response.result.value as AnyObject? {
                    // handle the results as JSON, without a bunch of nested if loops
                    let response = JSON(value)
                    print(response)
                    if response["status"].string == "error" {
                        self.showAlert(title: "Error", message: response["error_message"].string!)
                        return
                        }
                    else{
                        // registration number is available. Add this student
                        self.selected_class = self.class_section_list[0][self.class_section_picker.selectedRow(inComponent: 0)]
                        self.selected_section = self.class_section_list[1][self.class_section_picker.selectedRow(inComponent: 1)]
                        if self.selected_class == ""     {
                            self.selected_class = self.class_list[0]
                        }
                        if self.selected_section == ""   {
                            self.selected_section = self.section_list[0]
                        }
                        let prompt: String = "Are you sure to add \(r_no): \(f_name) \(l_name) C/o \(p_name), mobile 1: \(m1), mobile2: \(m2) to class \(self.selected_class) \(self.selected_section)?"
                        let alert: UIAlertController = UIAlertController(title: "Confirm Student Addition", message: prompt, preferredStyle: .alert )
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                            let user: String = SessionManager.getLoggedInUser()
                            let parameters: Parameters = [
                                "user": user,
                                "school_id": school_id,
                                "reg_no": r_no,
                                "first_name": f_name,
                                "last_name": l_name,
                                "parent_name": p_name,
                                "mobile1": m1,
                                "mobile2": m2,
                                "roll_no": rl_no,
                                "the_class": self.selected_class,
                                "section": self.selected_section
                            ]
                            
                            Alamofire.request("\(server_ip)/setup/add_student/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                .responseJSON { response in
                                    debugPrint(response)
                            }
                            self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
                            self.dismiss(animated: true, completion: nil)
                            return
                        })
                        alert.addAction(confirmAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        }
    }

    
    @IBAction func deleteStudent(_ sender: UIButton) {
        operation = "DeleteStudent"
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let prompt: String = "Are you sure that you want to delete this Student?"
        let alert: UIAlertController = UIAlertController(title: "Confirm Student Delete", message: prompt, preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let user: String = SessionManager.getLoggedInUser()
            let parameters: Parameters = [
                "user": user,
                "school_id": school_id,
                "student_id": self.student_id,
            ]
            
            Alamofire.request("\(server_ip)/setup/delete_student/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
            }
            self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
            self.dismiss(animated: true, completion: nil)
            return
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func updateStudent(_ sender: UIButton) {
        operation = "UpdateStudent"
        
        //check for blank values
        let f_name: String = first_name.text!
        if f_name == "" {
            showAlert(title: "Error", message: "First Name is blank")
            return
        }
        
        let l_name: String = last_name.text!
        if l_name == ""     {
            showAlert(title: "Error", message: "Last Name is blank")
            return
        }
        
        let p_name: String = parent_name.text!
        if p_name == "" {
            showAlert(title: "Error", message: "Parent Name is blank")
            return
        }
        
        let m1: String = mobile1.text!
        if m1 == "" {
            showAlert(title: "Error", message: "Mobile1 is blank")
            return
        }
        
        if m1.characters.count != 10    {
            showAlert(title: "Error", message: "Mobile1 should be exactly 10 digits")
            return
        }
        
        let m2: String = mobile2.text!
        if m2 != "" {
            if m2.characters.count != 10    {
                showAlert(title: "Error", message: "Mobile2 should be exactly 10 digits")
                return
            }
        }
        
        let rl_no: String = roll_no.text!
        
        // after basic validations are done, we need to check that this registration number is not already in use
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let r_no: String = reg_no.text!
        self.selected_class = self.class_section_list[0][self.class_section_picker.selectedRow(inComponent: 0)]
        self.selected_section = self.class_section_list[1][self.class_section_picker.selectedRow(inComponent: 1)]
        if self.selected_class == ""     {
            self.selected_class = self.class_list[0]
        }
        if self.selected_section == ""   {
            self.selected_section = self.section_list[0]
        }
        
        let prompt: String = "Are you sure to add \(r_no): \(f_name) \(l_name) C/o \(p_name), mobile 1: \(m1), mobile2: \(m2) to class \(self.selected_class) \(self.selected_section)?"
        let alert: UIAlertController = UIAlertController(title: "Confirm Student Update", message: prompt, preferredStyle: .alert )
                        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let user: String = SessionManager.getLoggedInUser()
            let parameters: Parameters = [
                "user": user,
                "school_id": school_id,
                "student_id": self.student_id,
                "reg_no": r_no,
                "first_name": f_name,
                "last_name": l_name,
                "parent_name": p_name,
                "mobile1": m1,
                "mobile2": m2,
                "roll_no": rl_no,
                "the_class": self.selected_class,
                "section": self.selected_section
            ]
            
            Alamofire.request("\(server_ip)/setup/update_student/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
            }
            self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
            self.dismiss(animated: true, completion: nil)
            return
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! SchoolAdminVC
        
        switch operation {
            case "AddStudent":
                destinationVC.comingFrom = "AddStudent"
                break
            case "UpdateStudent":
                destinationVC.comingFrom = "UpdateStudent"
                break
            case "DeleteStudent":
                destinationVC.comingFrom = "DeleteStudent"
                break
            default:
                break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
