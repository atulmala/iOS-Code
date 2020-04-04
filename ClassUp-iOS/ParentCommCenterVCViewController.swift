//
//  ParentCommCenterVCViewController.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 03/04/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ParentCommCenterVCViewController: UIViewController {
    var triggeringMenu : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func communicateWithSchool(sender: UIButton) {
        triggeringMenu = "CommunicateWithSchool"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    
    @IBAction func communicationHistory(_ sender: UIButton) {
        triggeringMenu = "CommunicationHistory"
        performSegue(withIdentifier: "to_communication_history", sender: self)
    }
    
    @IBAction func image_video_list(_ sender: UIButton) {
        triggeringMenu = "image_video"
        performSegue(withIdentifier: "selectWard", sender: self)
    }
    
    @IBAction func online_classes(_ sender: UIButton) {
        triggeringMenu = "online_classes"
        performSegue(withIdentifier: "selectWard", sender: self)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinqtionVC = segue.destination as! SelectWardVC
        destinqtionVC.trigger = triggeringMenu
        
    }
 

}
