//
//  SchoolAdminVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 13/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class SchoolAdminVC: UIViewController {
    var comingFrom: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var message: String = ""
        if comingFrom == "BulkSMS"    {
            message = "Message(s) Sent!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
        if comingFrom == "BulkSMSCancelled"    {
            message = "Message Sending Cancelled!"
            let final_confirm = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            final_confirm.addAction(OKAction)
            
            self.present(final_confirm, animated: false , completion: nil)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePassword")
        self.show(vc, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
