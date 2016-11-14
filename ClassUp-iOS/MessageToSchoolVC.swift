//
//  MessageToSchoolVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 28/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Just

class MessageToSchoolVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var student_id: String = ""
    var category_list: [String] = []
    
    var selected_category: String = ""

    @IBOutlet weak var send_message_button: UIButton!
    @IBOutlet weak var message_text_view: UITextView!
    @IBOutlet weak var message_category_picker: UIPickerView!
    @IBAction func send_message(sender: UIButton) {
        let the_message = message_text_view.text as String
        if the_message == ""    {
            showAlert(title: "Error", message: "Message is empty!")
        }
        else    {
            send_message_button.isEnabled = false
            
            var dict = [String:String]()
            dict["communication_text"] = the_message
            dict["student_id"] = student_id
            if selected_category == ""  {
                selected_category = category_list[0]
            }
            dict["category"] = selected_category
            print(dict)
            
            let server_ip = MiscFunction.getServerIP()
            let url = "\(server_ip)/parents/submit_parents_communication/"
            Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { response in
                //print("alamofire response=\(response)")
                
            }
            let message: String = "Message Sent. If required, school authorities will contact you."
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
            
            return
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // when the keyboard appears, the textview and button the bottom gets hidden. We need to move the cells up
        // when the keyboard appears. So we register for keyboard notification
        // when the keyboard appears, the cells in the bottom gets hidden. We need to move the cells up
        // when the keyboard appears. So we register for keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(TestMarksEntryVC.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TestMarksEntryVC.keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        


        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageToSchoolVC.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        message_text_view!.layer.borderWidth = 1
        message_text_view!.layer.borderColor = UIColor.black.cgColor

        // Do any additional setup after loading the view.
        let server_ip: String = MiscFunction.getServerIP()
        let url = "\(server_ip)/parents/retrieve_categories/"
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count {
                for index in 0...ct-1 {
                    if let category = j[index]["category"].string {
                        category_list.append(category)
                        }
                    
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category_list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category_list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_category = category_list[pickerView.selectedRow(inComponent: 0)]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(note: NSNotification) {
        self.view.frame.origin.y = -150
        /*let info: NSDictionary = note.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        message_text_view.contentInset = contentInsets
        message_text_view.scrollIndicatorInsets = contentInsets*/
    }
    
    func keyboardWillHide(note: NSNotification) {
        self.view.frame.origin.y = 0
//
//        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
//        message_text_view.contentInset = contentInsets
//        message_text_view.scrollIndicatorInsets = contentInsets
    }
    
    func dismissKeyboard()  {
        view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
