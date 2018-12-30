//
//  ShowAttendanceSummaryVC.swift
//  Classup1
//
//  Created by Atul Gupta on 14/10/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just
import AWSMobileAnalytics

class ShowAttendanceSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var class_sec: UILabel!
    @IBOutlet weak var time_period: UILabel!
    @IBOutlet weak var total_days: UILabel!
    
    var the_class: String = ""
    var sec: String = ""
    var sub: String = ""
    var month: String = ""
    var year: String = ""
    var tot_days: String = ""
    
    var roll_no_list: [String] = []
    var name_list: [String] = []
    var days_present_list: [String] = []
    var percentage_list: [String] = []
    
    var work_days_list: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Teacher Attendance Summary")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()

        
        
        // Do any additional setup after loading the view.

        class_sec.text = the_class + "-" + sec
        subject.text = sub
        
        switch year {
            case "Till Date":
                year = "till_date"
                time_period.text = "Till Date"
                break
            case "Current Year":
                let y = MiscFunction.getCurrentYear()
                let index = y.index(year.startIndex, offsetBy: 9)
                let yy = y.substring(from: index)
                year = yy.substring(to: yy.index(before: yy.endIndex))
                time_period.text = month + "/" + year
                break
            case "Last Year":
                year = MiscFunction.getLastYear()
                time_period.text = month + "/" + year
                break
            default:
                break
        }
        
        let server_ip = MiscFunction.getServerIP()
        let school_id = SessionManager.getSchoolId()
        
        // get the number of working days based on month and year (or till date)
        var url = server_ip + "/academics/get_working_days1/?school_id=\(school_id)&class=\(the_class)&section=\(sec)&subject=\(sub)&month=\(month)&year=\(year)"
        
        MiscFunction.sendRequestToServer(url: url, key: "working_days", list: &work_days_list, sender: "AttendanceSummaryGetWorkingDays")
        total_days.text = work_days_list[0]
        
        // get the days present for each student in the class for the given subject and duration
        url = server_ip + "/academics/get_attendance_summary/?school_id=\(school_id)&class=\(the_class)&section=\(sec)&subject=\(sub)&month=\(month)&year=\(year)"
        url = url.replacingOccurrences(of: " ", with: "%20")
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let name: String = j[index]["name"].string!
                    name_list.append(name)
                    
                    var roll_no: String = ""
                    if let _ = j[index]["roll_number"].int {
                        let the_roll_no = index + 1
                        roll_no = String(stringInterpolationSegment: the_roll_no)
                    }
                    roll_no_list.append(roll_no)
                    
                    var present_days: String = ""
                    if let _ = j[index]["present_days"].int {
                        let pd_ = j[index]["present_days"]
                        present_days = String(stringInterpolationSegment: pd_)
                    }
                    else{
                        present_days = j[index]["present_days"].string!
                    }
                    days_present_list.append(present_days)
                    
                    var percentage: String = ""
                    if let _ = j[index]["percentage"].int   {
                        let p = j[index]["percentage"]
                        percentage = String(stringInterpolationSegment: p)
                    }
                    else{
                        percentage = j[index]["percentage"].string!
                    }
                    percentage_list.append(percentage)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        
        self.navigationItem.title = "Attendance Summary"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return name_list.count
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "att_summary_cell", for: indexPath as IndexPath) as! AttendanceSummaryCellVC
        
        // Configure the cell...
        // we are storing id, class, section, date, month, and year as hidden in the cell
        // so that we can access them in Cell specific view controller.
        cell.roll_no.text = roll_no_list[indexPath.row]
        cell.name.text = name_list[indexPath.row]
        cell.days_present.text = days_present_list[indexPath.row]
        cell.percentage.text = percentage_list[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "att_summary_header_cell") as! AttendanceSummaryHeaderCell
        header_cell.backgroundColor = UIColor.cyan
        
        return header_cell
    }


    @IBAction func doneAttendanceSummary(sender: UIButton) {
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
