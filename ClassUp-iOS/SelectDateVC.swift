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
    var comingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // attendance summary for future date is not allowed
        datePicker.maximumDate = NSDate() as Date
        navigationItem.backBarButtonItem?.title = ""
        let submit_button = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(SelectDateVC.next(_:)))
        navigationItem.rightBarButtonItems = [submit_button]
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

    @IBAction func next(_ sender: UIButton) {
        switch comingFrom {
        case "TeachersAttendance":
            performSegue(withIdentifier: "to_teachers_attendance", sender: self)
            break
        case "AttendanceSummary":
            performSegue(withIdentifier: "showAttSummary", sender: self)
            break
        default:
            break
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        MiscFunction.decomposeDate(date_picker: datePicker, day: &d, month: &m, year: &y)
        // date, month, and year contains "optional( ) - we need to remove optional and parantheses
        let index = d.index(d.startIndex, offsetBy: 9)
        let dd = d.substring(from: index)
        let mm = m.substring(from: index)
        let yy = y.substring(from: index)

        
        switch comingFrom {
        case "AttendanceSummary":
            let destinationVC = segue.destination as! ShowSchoolAttSummVC
            destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
            destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
            destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))
            break
        case "TeachersAttendance":
            let destinationVC = segue.destination as! TeachersAttTVC
            destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
            destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
            destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))
            break
        default:
            break
        }
        

        
    }
    

}
