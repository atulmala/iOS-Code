//
//  CreateOnlineClassVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 23/04/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import Just

class CreateOnlineClassVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIDocumentPickerDelegate {
    @IBOutlet weak var select_class_sub: UIPickerView!
    @IBOutlet weak var youtube_link: UITextField!
    
    @IBOutlet weak var pdf_link: UITextField!
    @IBOutlet weak var select_document: UIButton!
    @IBOutlet weak var brief_description: UITextField!
    
    var server_ip: String = ""
    
    var composit_list: [[String]] = [[], []]
    var class_list: [String] = []
    var subject_list: [String] = []
    
    var selected_class: String = ""
    var selected_subject: String = ""
    
    var pdf_URL: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        server_ip = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        let subjectURL = "\(server_ip)/academics/subject_list/\(school_id)/?format=json"
        
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectClassSectionVC")
        MiscFunction.sendRequestToServer(url: subjectURL, key: "subject_name", list: &subject_list, sender: "SelectClassSectionVC")
        composit_list[0] = class_list
        composit_list[1] = subject_list
        
        pdf_link.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Create Online Class"
        self.navigationItem.titleView = lable
        
        let upload_button = UIBarButtonItem(title: "Upload", style: .done, target: self, action: #selector(CreateOnlineClassVC.upload(_:)))
        navigationItem.rightBarButtonItems = [upload_button]
    }
    
    func upload(_ sender: UIButton) {
        if selected_class == ""     {
            selected_class = class_list[0]
        }
        
        if selected_subject == ""   {
            selected_subject = subject_list[0]
        }
        
        if brief_description.text == "" {
            self.showAlert(title: "Description Needed", message: "Please enter brief description about this online class")
            return
        }
        
        if youtube_link.text == "" && pdf_link.text == ""   {
            let message: String = "You have neither provided Video link nor Document link. At least one is required"
            self.showAlert(title: "Video/Document link Missing!", message: message)
            return
        }
        
        let prompt: String = "Are you sure that you want create this Online Class?"
        let alert: UIAlertController = UIAlertController(title: "Please Confirm", message: prompt, preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            var params = [String:String]()
            
            params["school_id"] = school_id as String
            params["teacher"] = SessionManager.getLoggedInUser()
            params["the_class"] = self.selected_class
            params["subject"] = self.selected_subject
            params["section"] = "all_sections"
            params["all_sections"] = "true"
            params["youtube_link"] = self.youtube_link.text
            params["lesson_topic"] = self.brief_description.text
            
            if self.pdf_link.text == ""  {
                params["file_included"] = "false"
                self.pdf_link.text = "no_file"
                params["file_name"] = self.pdf_link.text
            }
            else{
                params["file_included"] = "true"
                params["file_name"] = self.pdf_link.text
            }
            
            print("params = ", params)
            
            let url = "\(self.server_ip)/lectures/share_lecture/"
            
            if params["file_included"] == "true"    {
                let r = Just.post(
                    url,
                    data: params,
                    files: ["file": .url(self.pdf_URL!, nil)]
                )
                if r.ok {
                    self.performSegue(withIdentifier: "back_to_online_class_list", sender: self)
                }
                
            }
            else    {
                let r = Just.post(
                    url,
                    data: params,
                    files:[
                        "b":.text("polo.txt", "Polo", nil)
                    ]
                )
                if r.ok {
                    self.performSegue(withIdentifier: "back_to_online_class_list", sender: self)
                }
            }})
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return composit_list[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return composit_list[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_class = composit_list[0][pickerView.selectedRow(inComponent: 0)]
        selected_subject = composit_list[1][pickerView.selectedRow(inComponent: 1)]
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        pdf_URL = myURL
        pdf_link.text = myURL.lastPathComponent
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pickDocument(_ sender: UIButton) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self as? UIDocumentPickerDelegate
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! OnlineClassesTVC
        destinationVC.sender = "created_online_class"
        destinationVC.teacher_id = SessionManager.getLoggedInUser()
        var count = self.navigationController?.viewControllers.count
        print("first count = ", count)
        self.navigationController?.viewControllers.remove(at: count! - 2)
    }
}
