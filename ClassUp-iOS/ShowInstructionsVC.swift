//
//  ShowInstructionsVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 18/05/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON
import Alamofire

class ShowInstructionsVC: UIViewController {
    var student_id: String = ""
    var test_id: String = ""
    var subject: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Instructions"
        self.navigationItem.titleView = lable
        
        let start_button = UIBarButtonItem(title: "Start Test", style: .done, target: self, action: #selector(ShowInstructionsVC.start_test(_:)))
        navigationItem.rightBarButtonItems = [start_button]
        
    }
    
    func start_test(_ sender: UIButton) {
        let server_ip: String = MiscFunction.getServerIP()
        let url: String = "\(server_ip)/online_test/whether_attempted/\(student_id)/\(test_id)/"
        
        let j = JSON(Just.get(url).json!)
        if j["attempted"] == "true" {
            showAlert(title: "Already Done", message: "You have already attempted this Test!")
        }
        else    {
            let prompt: String = "Are you sure that you want attempt this Online Test?"
            let alert: UIAlertController = UIAlertController(title: "Please Confirm", message: prompt, preferredStyle: .alert )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
                var params = [String:String]()
                params["submitted_via"] = "iPhone"
                let url1: String = "\(server_ip)/online_test/mark_attempted/\(self.student_id)/\(self.test_id)/"
                Alamofire.request(url1, method: .post, parameters: params, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        self.performSegue(withIdentifier: "to_online_test", sender: self)
                }

            })
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! OnlineQuestionTVC
        destinationVC.test_id = test_id
        destinationVC.student_id = student_id
    }
    
    
}
