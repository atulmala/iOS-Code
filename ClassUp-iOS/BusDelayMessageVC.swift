//
//  BusDelayMessageVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 01/04/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class BusDelayMessageVC: UIViewController {
    var d: String = ""
    var m: String = ""
    var y: String = ""
    var rout: String = ""

    @IBOutlet weak var text_bus_delay: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        text_bus_delay!.layer.borderWidth = 1
        text_bus_delay!.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func reportBusDelay(sender: UIButton) {
        let the_message = text_bus_delay.text as String
        if the_message == ""    {
            showAlert(title: "Error", message: "Message is empty!")
        }
        else    {
            let alert: UIAlertController = UIAlertController(title: "Confirm", message: "Date: \(d)-\(m)-\(y) | Rout: \(rout)", preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in

                let server_ip = MiscFunction.getServerIP()
                let school_id = SessionManager.getSchoolId()
                var dict = [String:String]()
                dict["message"] = the_message
                dict["date"] = self.d
                dict["month"] = self.m
                dict["year"] = self.y
                dict["school_id"] = school_id
                dict["rout"] = self.rout
                dict["teacher"] = SessionManager.getLoggedInUser()
                let url = "\(server_ip)/bus_attendance/report_delay/"
                Alamofire.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { response in
                
                }
                self.performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
            
                return
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
            return
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
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "ReportBusDelay"
    }
    
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    

}
