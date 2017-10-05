//
//  ShowSchoolAttSummVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 16/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import AWSMobileAnalytics
class ShowSchoolAttSummVC: UIViewController, UITableViewDataSource {
    @IBOutlet weak var attendance_date: UILabel!
    
    var d: String = ""
    var m: String = ""
    var y: String = ""
    
    var the_class: String = ""
    var attendance: String = ""
    var percentage: String = ""
    
    var class_list: [String] = []
    var att_list: [String] = []
    var perc_list: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "School Attendance Summary")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()

        
        // Do any additional setup after loading the view.
        let date: String = "Attendance Summary for Date: " + d + "/" + m + "/" + y
        attendance_date.text = date
        
        let server_ip = MiscFunction.getServerIP()
        let school_id = SessionManager.getSchoolId()
        
        let sender = "ShowSchoolAttSummVC"
        
        let url = "\(server_ip)/operations/att_summary_school_device/?school_id=\(school_id)&date=\(d)&month=\(m)&year=\(y)"
        MiscFunction.sendRequestToServer(url: url, key: "class", list: &class_list, sender: sender)
        MiscFunction.sendRequestToServer(url: url, key: "attendance", list: &att_list, sender: sender)
        MiscFunction.sendRequestToServer(url: url, key: "percentage", list: &perc_list, sender: sender)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return class_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sch_att_summary_cell", for: indexPath as IndexPath) as! School_Att_Summ_Cell
        
        // Configure the cell...
        cell.the_class.text = class_list[indexPath.row]
        cell.attendance.text = att_list[indexPath.row]
        cell.percentage.text = perc_list[indexPath.row]
        
        return cell
    }
    
    
    
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "sch_att_summ_hdr_cell") as! School_Att_Summ_Hdr_Cell
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
}




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


