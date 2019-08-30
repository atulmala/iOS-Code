//
//  AdminPicSelectedVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 30/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class AdminPicSelectedVC: UIViewController {
    var coming_from: String = ""
    var image: UIImage!
    
    @IBOutlet weak var message: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.backgroundColor = UIColor.lightGray

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let select_class_btn = UIBarButtonItem(title: "Select Classes", style: .done, target: self, action: #selector(AdminPicSelectedVC.select_classes(sender:)))
        
        let whole_school_btn = UIBarButtonItem(title: "Whole School", style: .done, target: self, action: #selector(AdminPicSelectedVC.whole_school(sender:)))
        navigationItem.rightBarButtonItems = [select_class_btn, whole_school_btn,]
    }
    
    @IBAction func select_classes(sender: UIButton) {
        let message: String = self.message.text
        if message == "" {
            let prompt: String = "Plese enter message for this Image/Video"
            showAlert(title: "No Messge!", message: prompt)
        }
        else    {
            performSegue(withIdentifier: "admin_select_class_pic_sharing", sender: self)
        }
    }
    
    @IBAction func whole_school(sender: UIButton)   {
        let message: String = self.message.text
        if message == "" {
            let prompt: String = "Plese enter message for this Image/Video"
            showAlert(title: "No Messge!", message: prompt)
        }
        else    {
            let random = Int.random(in: 0 ..< 100000)
            let teacher: String = SessionManager.getLoggedInUser()
            let imageFileName: String = "\(teacher)_\(String(random)).jpg"
            let imageData:NSData = UIImageJPEGRepresentation(image, 85)! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            let alert: UIAlertController = UIAlertController(title: "Confirm Media Sharing", message: "Are you sure to share this Image/Video with the whole School?", preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                var dict = [String:String]()
                dict["school_id"] = SessionManager.getSchoolId()
                dict["image_included"] = "yes"
                dict["image"] = strBase64
                dict["image_name"] = imageFileName
                dict["message_text"] = message
                dict["whole_class"] = "true"
                dict["whole_school"] = "true"
                dict["user"] = SessionManager.getLoggedInUser()
                
                let server_ip = MiscFunction.getServerIP()
                let url = "\(server_ip)/operations/send_bulk_sms/"
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
                self.performSegue(withIdentifier: "unwindToAdminMenu", sender: self)
                self.dismiss(animated: true, completion: nil)
                return
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToAdminMenu"  {
            let destinationVC = segue.destination as! SchoolAdminVC
            destinationVC.comingFrom = "pic_share"
        }
        
        if segue.identifier == "admin_select_class_pic_sharing" {
            let destinationVC = segue.destination as! AdminSelectClassPicSharingTVC
            destinationVC.coming_from = "pic_share"
            destinationVC.image = image
            destinationVC.message = message.text
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
