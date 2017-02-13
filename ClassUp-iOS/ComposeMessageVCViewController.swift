//
//  ComposeMessageVCViewController.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 11/01/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire


class ComposeMessageVCViewController: UIViewController {
    
    var student_list: [String] = []
    var whole_class: Bool = false
    var the_class: String = ""
    var section: String = ""
    var cancelled: Bool = false
    
    @IBOutlet weak var message: UITextView!

    @IBAction func sendMessage(sender: UIButton) {
        let the_message = message.text as String
        if the_message == ""    {
            showAlert(title: "Error", message: "Message is empty!")
        }
        else    {
            let alert: UIAlertController = UIAlertController(title: "Confirm Message(s) Sending", message: "Are you sure to send the message(s)?", preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            var dict = [String:String]()
            dict["message"] = the_message
            dict["teacher"] = SessionManager.getLoggedInUser() as String
            dict["whole_class"] = "false"
            if self.whole_class  {
                dict["whole_class"] = "true"
                dict["class"] = self.the_class
                dict["section"] = self.section
            }
            
            
            for i in 0 ..< self.student_list.count  {
                dict[MiscFunction.randomStringWithLength(len: 4) as String] = self.student_list[i]
            }
            print(dict)
            let server_ip = MiscFunction.getServerIP()
            let school_id = SessionManager.getSchoolId()
            let url = "\(server_ip)/operations/send_message/\(school_id)/"
            Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { response in
                
            }
            self.performSegue(withIdentifier: "unwindToMainMenu", sender: self)
            self.dismiss(animated: true, completion: nil)
            return
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        cancelled = true
        performSegue(withIdentifier: "unwindToMainMenu", sender: self)
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set border around the text box
        message!.layer.borderWidth = 1
        message!.layer.borderColor = UIColor.black.cgColor

        // Do any additional setup after loading the view.
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
        let destinationVC = segue.destination as! MainMenuVC
        if cancelled    {
        destinationVC.comingFrom = "SendMessageVCCancelled"
        } else{
            destinationVC.comingFrom = "SendMessageVC"
        }
    }
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    

}
