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
    var coming_from: String = "TeacherCommunication"
    var group_id: String = ""
    
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
                dict["coming_from"] = self.coming_from
                dict["message"] = the_message
                dict["teacher"] = SessionManager.getLoggedInUser() as String
                switch self.coming_from  {
                    case "TeacherCommunication":
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
                        break
                    case "ActivityGroup":
                        dict["group_id"] = self.group_id
                        break
                    default:
                        break
                    
                }
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
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.left
        
        lable.text = "Compose Message"
        self.navigationItem.titleView = lable
        
        // 25/06/2017 - moving the submit button to the navigation bar
        
        let send_button = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(ComposeMessageVCViewController.sendMessage(sender:)))
        let cancel_button = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(ComposeMessageVCViewController.cancel(sender:)))
        navigationItem.rightBarButtonItems = [cancel_button, send_button,]
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
