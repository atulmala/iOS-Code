//
//  SelectDateVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 16/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class SelectDateVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var d: String = "1"
    var m: String = "1"
    var y: String = "1970"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // attendance summary for future date is not allowed
        datePicker.maximumDate = NSDate() as Date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // get the selected date from date picker
    func dateHandler(sender: UIDatePicker)  {
        let date_formatter = DateFormatter()
        date_formatter.timeStyle = DateFormatter.Style.short
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! ShowSchoolAttSummVC
        MiscFunction.decomposeDate(date_picker: datePicker, day: &d, month: &m, year: &y)
        // date, month, and year contains "optional( ) - we need to remove optional and parantheses
                let index = d.index(d.startIndex, offsetBy: 9)
        let dd = d.substring(from: index)
        destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
        let mm = m.substring(from: index)
        destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
        let yy = y.substring(from: index)
        destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))
        
    }
    

}
