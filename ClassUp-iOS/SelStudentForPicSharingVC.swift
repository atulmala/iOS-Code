//
//  SelStudentForPicSharingVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 28/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class SelStudentForPicSharingVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var brief_description: UITextView!
    @IBOutlet weak var class_sec_picker: UIPickerView!
    
    var image: UIImage!
    
    var coming_from = "share_pic"
    
    var class_list: [String] = []
    var section_list: [String] = []
    var class_section_list: [[String]] = [[], []]
    
    var selected_class: String = ""
    var selected_section: String = ""
    var whole_class: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brief_description.backgroundColor = UIColor.lightGray
        
        let server_ip: String = MiscFunction.getServerIP()
        
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        
        let sectionURL = "\(server_ip)/academics/section_list/\(school_id)/?format=json"
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectClassSectionVC")
        MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectClassSectionVC")
        class_section_list[0] = class_list
        class_section_list[1] = section_list
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let select_students_btn = UIBarButtonItem(title: "Select Students", style: .done, target: self, action: #selector(SelStudentForPicSharingVC.shareWithSelectedStudents(sender:)))
        
        let whole_class_btn = UIBarButtonItem(title: "Whole Class", style: .done, target: self, action: #selector(SelStudentForPicSharingVC.shareWithWholeClass(sender:)))
        navigationItem.rightBarButtonItems = [whole_class_btn, select_students_btn,]
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
    
    @IBAction func shareWithSelectedStudents(sender: UIButton)  {
        let description = brief_description.text as String
        if description == ""    {
            let prompt: String = "Please enter brief description for this Image/Video"
            showAlert(title: "Brief Description not entered", message: prompt)
        }
        else    {
            if selected_class == "" {
                selected_class = class_list[0]
            }
            if selected_section == ""   {
                selected_section = section_list[0]
            }
            performSegue(withIdentifier: "stud_list_for_pic_sharing", sender: self)
        }
    }
    
    @IBAction func shareWithWholeClass(sender: UIButton)    {
        let description = brief_description.text as String
        if description == ""    {
            let prompt: String = "Please enter brief description for this Image/Video"
            showAlert(title: "Brief Description not entered", message: prompt)
        }
        else{
            if selected_class == ""     {
                selected_class = class_list[0]
            }
            if selected_section == ""   {
                selected_section = section_list[0]
            }
            let random = Int.random(in: 0 ..< 100000)
            let teacher: String = SessionManager.getLoggedInUser()
            let school_id: String = SessionManager.getSchoolId()
            let imageFileName: String = "\(teacher)_\(selected_class)_\(selected_section)\(String(random)).jpg"
            let imageData:NSData = UIImageJPEGRepresentation(image, 85)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            let alert: UIAlertController = UIAlertController(title: "Confirm Media Sharing", message: "Are you sure to share this Image/Video?", preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                var dict = [String:String]()
                dict["image"] = strBase64
                dict["image_name"] = imageFileName
                dict["description"] = description
                dict["whole_class"] = "true"
                dict["class"] = self.selected_class
                dict["section"] = self.selected_section
                dict["teacher"] = SessionManager.getLoggedInUser()
                dict["school_id"] = school_id
                
                let server_ip = MiscFunction.getServerIP()
                let url = "\(server_ip)/pic_share/upload_pic/"
                Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { response in self.showAlert(title: "Awaiting Image Upload status", message: "Awaiting Image Upload status" )
                    switch
                    response.result   {
                        
                    case .success(let JSON):
                        debugPrint(response)
                        let response = JSON as! NSDictionary
                        let message = response.object(forKey: "message")
                        self.showAlert(title: "Image Upload status", message: message as! String)
                    case .failure(let JSON):
                        let response = JSON as! NSDictionary
                        let message = response.object(forKey: "message")
                        self.showAlert(title: "Image Upload status", message: message as! String)
                    }
                    
                }
                self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
                self.dismiss(animated: true, completion: nil)
                return
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stud_list_for_pic_sharing"  {
            let destinationVC = segue.destination as! StudListForPicSharingTVC
            destinationVC.image = image
            destinationVC.coming_from = "share_pic"
            destinationVC.the_class = selected_class
            destinationVC.section = selected_section
            destinationVC.brief_description = brief_description.text as String
        }
        else{
            let destinationVC = segue.destination as! MainMenuVC
            destinationVC.comingFrom = "image_sharing"
        }
    }
}
