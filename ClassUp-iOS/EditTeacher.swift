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
    }
    @IBAction func updateTeacher(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
