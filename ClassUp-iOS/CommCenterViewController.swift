//
//  CommCenterViewController.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 15/03/18.
//  Copyright © 2018 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class CommCenterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCirculars"    {
            let destinationVC = segue.destination as! MessageHistoryVC
            destinationVC.coming_from = "teacher"
        }
        
        if segue.identifier == "show_days_of_week"  {
            let destinationVC = segue.destination as! DaysofWeek
            destinationVC.coming_from = "teacher"
        }
    }
    

}
