//
//  SelectClassSectionVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 06/01/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class SelectClassSectionVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    // lists to hold classes, sections
    var class_list: [String] = []
    var section_list: [String] = []
    var class_section_list: [[String]] = [[], []]
    
    var selected_class: String = ""
    var selected_section: String = ""
    var whole_class: Bool = false
    var trigger: String = "SelectStudents"
    
    @IBOutlet weak var class_section_picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        
        let sectionURL = "\(server_ip)/academics/section_list/\(school_id)/?format=json"
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectClassSectionVC")
        MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectClassSectionVC")
        class_section_list[0] = class_list
        class_section_list[1] = section_list
        
        
        // No title for the back button in navigation section
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain,
            target: nil, action: nil)
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
    
    @IBAction func next(sender: UIButton) {
        trigger = "SelectStudents"
    }

    
    @IBAction func sendMessageToWholeClass(sender: UIButton) {
        whole_class = true
        trigger = "WholeClass"
        performSegue(withIdentifier: "to_compose_message_for_whole_class", sender: self)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if selected_class == ""     {
            selected_class = class_list[0]
        }
        if selected_section == ""   {
            selected_section = section_list[0]
        }
        switch trigger {
        case "SelectStudents":
            let destinationVC = segue.destination as! SelectStudentVC
            destinationVC.the_class = selected_class
            destinationVC.section = selected_section
            break;
        case "WholeClass":
            let destinationVC = segue.destination as! ComposeMessageVCViewController
            destinationVC.the_class = selected_class
            destinationVC.section = selected_section
            destinationVC.whole_class = true
            break;
        default:
            break;
        }
    }
}
