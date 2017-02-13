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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendWholeSchool(_ sender: UIButton) {
        let the_message = txt_bulk_SMS.text as String
        if the_message == ""    {
            showAlert(title: "Error", message: "Message is empty!")
        }
        else    {
            let alert: UIAlertController = UIAlertController(title: "Confirm Message(s) Sending", message: "Are you sure to send the message(s)?", preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                var dict = [String:String]()
                dict["message_text"] = the_message
                dict["from_device"] = "true"
                dict["whole_school"] = "true"
                dict["user"] = SessionManager.getLoggedInUser()
                dict["school_id"] = SessionManager.getSchoolId()
                
                let server_ip = MiscFunction.getServerIP()
                let url = "\(server_ip)/operations/send_bulk_sms/"
                Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { response in
                    
                }
                //self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
                self.dismiss(animated: true, completion: nil)
                return
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func sendSelectedClasses(_ sender: UIButton) {
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
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
