//
//  BusRouteSelectionVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 30/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class BusRouteSelectionVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

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
        date_picker.maximumDate = NSDate() as Date
        
        // retrieve bus routs
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let url = "\(server_ip)/bus_attendance/retrieve_bus_routs/\(school_id)/"
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        if (count! > 0)  {
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rout_type_list[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rout_type_list[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_rout = rout_type_list[0][pickerView.selectedRow(inComponent: 0)]
        selected_rout_type = rout_type_list[1][pickerView.selectedRow(inComponent: 1)]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // get the selected date from date picker
    func dateHandler(sender: UIDatePicker)  {
        let date_formatter = DateFormatter()
        //date_formatter.timeStyle = DateFormatter.Style.ShortStyle
        date_formatter.timeStyle = DateFormatter.Style.short
        //var str_date = date_formatter.stringFromDate(datePicker.date)
    }

    @IBAction func take_bus_attendance(sender: UIButton) {
        trigger = "takeBusAttendance"
        
        MiscFunction.decomposeDate(date_picker: date_picker, day: &d, month: &m, year: &y)
        
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
        performSegue(withIdentifier: "take_bus_attendance", sender: self)
    }
    
    @IBAction func report_delay(sender: UIButton) {
        trigger = "reportBusDelay"
        MiscFunction.decomposeDate(date_picker: date_picker, day: &d, month: &m, year: &y)
        
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

        performSegue(withIdentifier: "to_report_bus_delay", sender: self)
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
        switch trigger  {
        case "takeBusAttendance":
            let destinationVC = segue.destination as!
            BusAttendanceVC
            destinationVC.selected_rout = selected_rout
            destinationVC.selected_rout_type = selected_rout_type
            // date, month, and year contains "optional( ) - we need to remove optional and parantheses
            let index = d.index(d.startIndex, offsetBy: 9)
            let dd = d.substring(from: index)
            destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
            let mm = m.substring(from: index)
            destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
            let yy = y.substring(from: index)
            destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))

            break;
        case "reportBusDelay":
            let destinationVC = segue.destination as!BusDelayMessageVC
            destinationVC.rout = selected_rout
            // date, month, and year contains "optional( ) - we need to remove optional and parantheses
            let index = d.index(d.startIndex, offsetBy: 9)
            let dd = d.substring(from: index)
            destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
            let mm = m.substring(from: index)
            destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
            let yy = y.substring(from: index)
            destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))

            break;
            
        default:
            break;
        }

    }
    }
