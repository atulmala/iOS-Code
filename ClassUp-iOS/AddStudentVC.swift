//
//  AddStudentVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 19/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class AddStudentVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var reg_no: UITextField!
    @IBOutlet weak var first_name: UITextField!
    
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var parent_name: UITextField!
    @IBOutlet weak var mobile1: UITextField!
    
    @IBOutlet weak var class_section_picker: UIPickerView!
    @IBOutlet weak var mobile2: UITextField!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(AddStudentVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddStudentVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        
        let sectionURL = "\(server_ip)/academics/section_list/\(school_id)/?format=json"
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectClassSectionVC")
        MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectClassSectionVC")
        class_section_list[0] = class_list
        class_section_list[1] = section_list
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
            showAlert(title: "Error", message: "Mobile2 should be exactly 10 digits")
                return
        }
        
        let m2: String = mobile2.text!
        if m2 != "" {
            if m2.characters.count != 10    {
                showAlert(title: "Error", message: "Mobile2 should be exactly 10 digits")
                return
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    func dismissKeyboard()  {
        view.endEditing(true)
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
