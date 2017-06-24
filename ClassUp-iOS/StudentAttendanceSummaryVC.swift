//
//  StudentAttendanceSummaryVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 26/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class StudentAttendanceSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var student_name: UILabel!
    var student_id: String = ""
    var student_full_name: String = ""
    
    var month_list: [String] = []
    var work_days_list: [String] = []
    var present_days_list: [String] = []
    var percentage_list: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        student_name.text = "Attendance Summary for " + student_full_name
        
        let server_ip = MiscFunction.getServerIP()
        let url = "\(server_ip)/parents/retrieve_stu_att_summary/?student_id=\(student_id)"
        
        MiscFunction.sendRequestToServer(url: url, key: "month_year", list: &month_list, sender: "StuAttSummary")
        MiscFunction.sendRequestToServer(url: url, key: "present_days", list: &present_days_list, sender: "StuAttSummary")
        MiscFunction.sendRequestToServer(url: url, key: "work_days", list: &work_days_list, sender: "StuAttSummary")
        MiscFunction.sendRequestToServer(url: url, key: "percentage", list: &percentage_list, sender: "StuAttSummary")
        
        // we have to calculate the overall attendance figures. Those doesn't come from backend
        month_list.append("Overall")
        var tot_work_days = 0
        var tot_present_days = 0
        if work_days_list.count > 1 {
            for i in 0...work_days_list.count  - 1  {
                tot_work_days += Int(work_days_list[i])!
                tot_present_days += Int(present_days_list[i])!
            }
        }
        work_days_list.append(String(tot_work_days))
        present_days_list.append(String(tot_present_days) + "/" + String(tot_work_days))
        
        var overall_perc: Float = 0.0
        if tot_work_days != 0   {
            overall_perc = Float(Float(tot_present_days)/Float(tot_work_days))*100
            percentage_list.append(String(format: "%.2f", overall_perc) + "%")
        }
        else{
            percentage_list.append("N/A")
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return month_list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stu_att_summary_cell", for: indexPath as IndexPath) as! StuAttSummaryCellTVC
        
        // Configure the cell...
        // we are storing id, class, section, date, month, and year as hidden in the cell
        // so that we can access them in Cell specific view controller.
        cell.month.text = month_list[indexPath.row]
        //cell.tot_days.text = work_days_list[indexPath.row]
        
        // in case this is the last row, this means this shows overall attendance. We need not to show 
        // the "/" as it is already contained in the present_days_list
        
        if indexPath.row != present_days_list.count-1 {
        cell.present_days.text = present_days_list[indexPath.row] + "/" + work_days_list[indexPath.row]
            cell.backgroundColor = UIColor.clear
        }
        else    {
            cell.present_days.text = present_days_list[indexPath.row]
            cell.backgroundColor = UIColor.gray
        }
        
        cell.percentage.text = percentage_list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "stu_att_summary_header_cell") as! StuAttSummaryHeaderCellTVC
        header_cell.backgroundColor = UIColor.cyan
        return header_cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        let destinationVC = segue.destination as! StudentAttendanceSummaryVC
        destinationVC.student_name = student_name
        destinationVC.student_id = student_id
    }
    

}
