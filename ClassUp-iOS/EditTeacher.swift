//
//  EditTeacher.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 01/03/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditTeacher: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // lists to hold classes, sections
    var class_list: [String] = []
    var section_list: [String] = []
    var class_section_list: [[String]] = [[], []]
    
    var selected_class: String = ""
    var selected_section: String = ""

    var teacher_id: String = ""
    var teacher_name: String = ""
    var teacher_login: String = ""
    var teacher_mobile: String = ""
    
    
    var operation: String = ""

    @IBOutlet weak var class_secton_picker: UIPickerView!
    @IBOutlet weak var txt_teacher_name: UITextField!
    @IBOutlet weak var txt_login_id: UITextField!
    @IBOutlet weak var txt_mobile: UITextField!
    
    @IBOutlet weak var whether_class_teacher: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        
        let sectionURL = "\(server_ip)/academics/section_list/\(school_id)/?format=json"
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectClassSectionVC")
        MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectClassSectionVC")
        class_section_list[0] = class_list
        class_section_list[1] = section_list
        
        // check if this teacher is Class Teacher of any class?
        let url: String = "\(server_ip)/teachers/whether_class_teacher/\(teacher_id)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if let value: AnyObject = response.result.value as AnyObject? {
                // handle the results as JSON, without a bunch of nested if loops
                let response = JSON(value)
                print(response)
                let is_class_teacher: String = response["is_class_teacher"].string!
                
                if is_class_teacher == "true"   {
                    self.whether_class_teacher.setOn(true, animated: true)
                    self.class_secton_picker.isUserInteractionEnabled = true
                    
                    let the_class = response["the_class"].string!
                    let section = response["section"].string!
                    // show the current class & section in the picker
                    
                    let class_index: Int = self.class_list.index(of: the_class)!
                    let section_index: Int = self.section_list.index(of: section)!
                    
                    self.class_secton_picker.selectRow(class_index, inComponent: 0, animated: true)
                    self.class_secton_picker.selectRow(section_index, inComponent: 1, animated: true)
                }
                else    {
                    self.whether_class_teacher.setOn(false, animated: true)
                    self.class_secton_picker.isUserInteractionEnabled = false
                    
                }
            }
        }

        // Do any additional setup after loading the view.
        txt_teacher_name.text = teacher_name
        txt_login_id.text = teacher_login
        txt_mobile.text = teacher_mobile
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enablePicker(_ sender: UISwitch) {
        if whether_class_teacher.isOn   {
            whether_class_teacher.setOn(false, animated: true)
            class_secton_picker.isUserInteractionEnabled = false
        }
        else    {
            whether_class_teacher.setOn(true, animated: true)
            class_secton_picker.isUserInteractionEnabled = true
        }
    }

    @IBAction func deleteTeacher(_ sender: UIButton) {
        operation = "DeleteTeacher"
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let prompt: String = "Are you sure that you want to delete this Teacher?"
        let alert: UIAlertController = UIAlertController(title: "Confirm Teacher Delete", message: prompt, preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let user: String = SessionManager.getLoggedInUser()
            let parameters: Parameters = [
                "user": user,
                "school_id": school_id,
                "student_id": self.teacher_id,
                ]
            
            Alamofire.request("\(server_ip)/teachers/delete_teacher/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
    
    @IBAction func updateTeacher(_ sender: UIButton) {
        operation = "UpdateTeacher"
        
        //check for blank values
        let name: String = txt_teacher_name.text!
        if name == ""   {
            showAlert(title: "Error", message: "Teacher name is blank")
            return
        }
        
        let login_id: String = txt_login_id.text!
        if login_id == "" {
            showAlert(title: "Error", message: "Login ID is blank")
            return
        }
        
        if !isValidEmail(testStr: login_id) {
            showAlert(title: "Error", message: "Invalid login id. Should be of form teadhername@school.com")
            return
        }
        
        let m1: String = txt_mobile.text!
        if m1 == "" {
            showAlert(title: "Error", message: "Mobile is blank")
            return
        }
        
        if m1.characters.count != 10    {
            showAlert(title: "Error", message: "Mobile should be exactly 10 digits")
            return
        }
        
        let prompt: String = "Are you sure you want to update this Teacher?"
        let alert: UIAlertController = UIAlertController(title: "Confirm Teacher Update", message: prompt, preferredStyle: .alert )
        
        self.selected_class = self.class_section_list[0][self.class_secton_picker.selectedRow(inComponent: 0)]
        self.selected_section = self.class_section_list[1][self.class_secton_picker.selectedRow(inComponent: 1)]
        if self.selected_class == ""     {
            self.selected_class = self.class_list[0]
        }
        if self.selected_section == ""   {
            self.selected_section = self.section_list[0]
        }

        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let user: String = SessionManager.getLoggedInUser()
            
            var is_class_teacher: String = "false"
            if self.whether_class_teacher.isOn   {
                is_class_teacher = "true"
            }
            
            let parameters: Parameters = [
                "user": user,
                "school_id": school_id,
                "teacher_id": self.teacher_id,
                "teacher_name": name,
                "teacher_login": login_id,
                "teacher_mobile": m1,
                "is_class_teacher": is_class_teacher,
                "the_class": self.selected_class,
                "section": self.selected_section
            ]
            
            Alamofire.request("\(server_ip)/teachers/update_teacher/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print("printing response")
                    let json = JSON(response.result.value)
                    let outcome: String = json["message"].string!
                    self.showAlert(title: "Oucome", message: outcome)
                    
            }
            
            self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
            self.dismiss(animated: true, completion: nil)
            return
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! SchoolAdminVC
        
        switch operation {
        
        case "UpdateTeacher":
            destinationVC.comingFrom = "UpdateTeacher"
            break
        case "DeleteTeacher":
            destinationVC.comingFrom = "DeleteTeacher"
            break
        default:
            break
        }

    }

    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }


}
