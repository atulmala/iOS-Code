//
//  SelClassUpdateStuVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 23/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SelClassUpdateStuVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // lists to hold classes, sections
    var class_list: [String] = []
    var section_list: [String] = []
    var class_section_list: [[String]] = [[], []]
    
    var selected_class: String = ""
    var selected_section: String = ""
    var selected_term: String = ""
    
    var trigger: String = "SelClassUpdateStu"
    
    @IBOutlet weak var class_section_picker: UIPickerView!

    @IBOutlet weak var term_segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if trigger == "co_scholastics"   {
            term_segment.isHidden = false
        }
        else{
            term_segment.isHidden = true
        }

        // Do any additional setup after loading the view.
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        
        let sectionURL = "\(server_ip)/academics/section_list/\(school_id)/?format=json"
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectClassSectionVC")
        MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectClassSectionVC")
        class_section_list[0] = class_list
        class_section_list[1] = section_list
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let next_button = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(SelClassUpdateStuVC.next(_:)))
        navigationItem.rightBarButtonItems = [next_button]
        
    }

    func next(_ sender: UIButton) {
        if trigger == "co_scholastics"  {
            if selected_class == "" {
                selected_class = class_list[0]
            }
            if selected_section == ""   {
                selected_section = section_list[0]
            }
            var good_to_go: Bool = true
            
            let server_ip: String = MiscFunction.getServerIP()
            let teacher: String = SessionManager.getLoggedInUser()
            let url: String = "\(server_ip)/teachers/whether_class_teacher2/\(teacher)/"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                    if let value: AnyObject = response.result.value as AnyObject? {
                    // handle the results as JSON, without a bunch of nested if loops
                    let response = JSON(value)
                    print(response)
                    
                    if response["is_class_teacher"] == "true"  {
                        let the_class: String = response["the_class"].string!
                        let the_section: String = response["section"].string!
                        
                        if self.selected_class != the_class || self.selected_section != the_section   {
                            self.showAlert(title: "Not a Class Teacher", message: "You are not the Class Teacher of \(self.selected_class) - \(self.selected_section)!")
                            good_to_go = false
                            return
                        }
                        
                        if self.selected_term == ""  {
                            self.showAlert(title: "Term not Selected", message: "Please selecte either Term 1 or Term 2")
                            good_to_go = false
                            return
                        }
                        
                        if good_to_go   {
                            self.performSegue(withIdentifier: "to_co_scholastic", sender: self)
                        }
                    }
                    else    {
                        self.showAlert(title: "You are not the Class Teacher of \(self.selected_class) - \(self.selected_section)!", message: response["error_message"].string!)
                        return
                    }
                }
            }
            
        }
        else{
            performSegue(withIdentifier: "to_select_student", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func select_term(_ sender: UISegmentedControl) {
        switch term_segment.selectedSegmentIndex    {
            case 0:
                selected_term = "term1"
            case 1:
                selected_term = "term2"
            default:
                break
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


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch trigger {
            case "SelClassUpdateStu":
                let vc = segue.destination as! SelectStudentTVC
                
                if selected_class == "" {
                    selected_class = class_list[0]
                }
                if selected_section == ""   {
                    selected_section = section_list[0]
                }
                
                vc.the_class = selected_class
                vc.section = selected_section
            case "co_scholastics":
                let vc =  segue.destination as! CoScholasticTVC
                if selected_class == "" {
                    selected_class = class_list[0]
                }
                if selected_section == ""   {
                    selected_section = section_list[0]
                }
                
                vc.the_class = selected_class
                vc.section = selected_section
                vc.term = selected_term
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
    

}
