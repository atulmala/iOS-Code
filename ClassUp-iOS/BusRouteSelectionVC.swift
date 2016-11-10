//
//  BusRouteSelectionVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 30/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class BusRouteSelectionVC: UIViewController {

    @IBOutlet weak var rout_picker: UIPickerView!
    @IBOutlet weak var date_picker: UIDatePicker!
    var rout_list: [String] = []
    var rout_type_list: [[String]] = [[], ["To School", "From School"]]
    var selected_rout: String = ""
    var selected_rout_type: String = ""
    
    var d: String = ""
    var m: String = ""
    var y: String = ""
    
    var trigger: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date_picker.maximumDate = NSDate()
        
        // retrieve bus routs
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let url = "\(server_ip)/bus_attendance/retrieve_bus_routs/\(school_id)/"
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        if (count > 0)  {
            if let ct = count {
                for index in 0...ct-1 {
                    if let rout = j[index]["bus_root"].string {
                        if !rout_list.contains(rout)  {
                            rout_list.append(rout)
                        }
                    }
                }
            }
        }
        rout_type_list[0] = rout_list

        // Do any additional setup after loading the view.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rout_type_list[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rout_type_list[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_rout = rout_type_list[0][pickerView.selectedRowInComponent(0)]
        selected_rout_type = rout_type_list[1][pickerView.selectedRowInComponent(1)]
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // get the selected date from date picker
    func dateHandler(sender: UIDatePicker)  {
        let date_formatter = NSDateFormatter()
        date_formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        //var str_date = date_formatter.stringFromDate(datePicker.date)
    }

    @IBAction func take_bus_attendance(sender: UIButton) {
        trigger = "takeBusAttendance"
        
        MiscFunction.decomposeDate(date_picker, day: &d, month: &m, year: &y)
        
        if selected_rout == ""  {
            selected_rout = rout_list[0]
        }
        if selected_rout_type == "" {
            selected_rout_type = "to_school"
        }
        if selected_rout_type == "To School" {
            selected_rout_type = "to_school"
        }
        if selected_rout_type == "From School" {
            selected_rout_type = "from_school"
        }
        performSegueWithIdentifier("take_bus_attendance", sender: self)
    }
    @IBAction func report_delay(sender: UIButton) {
        trigger = "reportBusDelay"
        MiscFunction.decomposeDate(date_picker, day: &d, month: &m, year: &y)
        
        if selected_rout == ""  {
            selected_rout = rout_list[0]
        }
        if selected_rout_type == "" {
            selected_rout_type = "to_school"
        }
        if selected_rout_type == "To School" {
            selected_rout_type = "to_school"
        }
        if selected_rout_type == "From School" {
            selected_rout_type = "from_school"
        }

        performSegueWithIdentifier("to_report_bus_delay", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch trigger  {
            case "takeBusAttendance":
                let destinationVC = segue.destinationViewController as!
                BusAttendanceVC
                destinationVC.selected_rout = selected_rout
                destinationVC.selected_rout_type = selected_rout_type
                destinationVC.d = d
                destinationVC.m = m
                destinationVC.y = y
                break;
            case "reportBusDelay":
                let destinationVC = segue.destinationViewController as!BusDelayMessageVC
                destinationVC.rout = selected_rout
                destinationVC.d = d
                destinationVC.m = m
                destinationVC.y = y
                break;

            default:
                break;
        }
    }
}
