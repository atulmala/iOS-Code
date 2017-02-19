//
//  ComposeBulkSMSVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 13/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class ComposeBulkSMSVC: UIViewController {
    
    @IBOutlet weak var txt_bulk_SMS: UITextView!
    
    var cancelled = true
    var destination = "SelectClassBulkSMSVC"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendWholeSchool(_ sender: UIButton) {
        let message_text = txt_bulk_SMS.text as String
        if message_text == ""    {
            showAlert(title: "Error", message: "Message is empty!")
        }
        else if (message_text.characters.count) > 140       {showAlert(title: "Error", message: "Message is too large (\(message_text.characters.count) characters). Please restrict it to 140 characters!")
        }
        else    {
            let alert: UIAlertController = UIAlertController(title: "Confirm Message(s) Sending", message: "Are you sure to send the message(s)?", preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                self.destination = "SchoolAdminVC"
                self.cancelled = false
                var dict = [String:String]()
                dict["message_text"] = message_text
                dict["from_device"] = "true"
                dict["whole_school"] = "true"
                dict["user"] = SessionManager.getLoggedInUser()
                dict["school_id"] = SessionManager.getSchoolId()
                
                let server_ip = MiscFunction.getServerIP()
                let url = "\(server_ip)/operations/send_bulk_sms/"
                Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { response in
                    
                }
                self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
                self.dismiss(animated: true, completion: nil)
                return
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendSelectedClasses(_ sender: UIButton) {
        let message_text = txt_bulk_SMS.text as String
        if message_text == ""    {
            showAlert(title: "Error", message: "Message is empty!")
        }
        else    if (message_text.characters.count) > 140       {showAlert(title: "Error", message: "Message is too large (\(message_text.characters.count) characters). Please restrict it to 140 characters!")
        }
        else
        {
            destination = "SelectClassBulkSMS"
            performSegue(withIdentifier: "toSelectClassBulkSMS", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch destination {
        case "SelectClassBulkSMS":
            let vc = segue.destination as! SelectClassBulkSMSVC
            let message_text = txt_bulk_SMS.text as String
            vc.message_text = message_text
            break
        case "SchoolAdminVC":
            let vc = segue.destination as! SchoolAdminVC
            vc.comingFrom = "BulkSMS"
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
    
}
