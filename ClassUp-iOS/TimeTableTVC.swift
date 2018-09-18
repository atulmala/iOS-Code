//
//  TimeTableTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 09/04/18.
//  Copyright © 2018 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON
import AWSMobileAnalytics

class TimeTableSource: NSObject {
    var the_class: String
    var period: String
    var section: String
    var subject: String
    
    init(the_class: String, section: String, period: String, subject: String)   {
        self.the_class = the_class
        self.section = section
        self.period = period
        self.subject = subject
        super.init()
    }
}

class TimeTableTVC: UITableViewController {
    var tt_list: [TimeTableSource] = []
    var coming_from: String = ""
    var day: String = ""
    var student_id: String = ""
    var url: String = ""
    var period: String = ""
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    
    var free_perios: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.left
        lable.textAlignment = NSTextAlignment.center
        
        lable.text = "My Time Table for \(day)"
        self.navigationItem.titleView = lable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let server_ip: String = MiscFunction.getServerIP()
        if coming_from == "student" {
            url = "\(server_ip)/time_table/get_time_table/na/student/\(student_id)/\(day)/"
        }
        
        if coming_from == "teacher" {
            let user: String = SessionManager.getLoggedInUser()
            let school_id: String = SessionManager.getSchoolId()
            url = "\(server_ip)/time_table/get_time_table/\(school_id)/teacher/\(user)/\(day)/"
        }
        
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if count! > 0   {
            if let ct = count    {
                for index in 0...ct-1   {
                    let the_class = j[index]["the_class"].string!
                    let section = j[index]["section"].string!
                    
                    var period: String = ""
                    if let _ = j[index]["period"].int {
                        let the_period = j[index]["period"]
                        period = String(stringInterpolationSegment: the_period)
                    }
                    
                    if free_perios.contains(period) {
                        free_perios.remove(at: free_perios.index(of: period)!)
                    }
                    
                    let subject = j[index]["subject"].string!
                    
                    tt_list.append(TimeTableSource(the_class: the_class, section: section, period: period, subject: subject))
                }
            }
            var today_free_period: String = "Today's free Periods: "
            for fp in free_perios   {
                today_free_period = today_free_period + " " + fp + ", "
            }
            tt_list.append(TimeTableSource(the_class: today_free_period, section: "", period: "", subject: ""))
        }
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let userName: String = SessionManager.getLoggedInUser()
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Time Table")
        eventClient.addGlobalAttribute(userName as String?, forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tt_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "time_table_cell", for: indexPath) as! TimeTableCell
        var details: String = ""
        period = tt_list[indexPath.row].period
        the_class = tt_list[indexPath.row].the_class
        section = tt_list[indexPath.row].section
        subject = tt_list[indexPath.row].subject
        
        if coming_from == "teacher" {
            if !the_class.contains("free")  {
                details = "Period # \(period)  \(the_class)-\(section)     \(subject)"
            }
            else    {
                details = the_class
                let endIndex = details.index(details.endIndex, offsetBy: -2)
                details = details.substring(to: endIndex)
            }
        }
        
        if coming_from == "student" {
            details = "Period # \(period)       \(subject)"
        }

        cell.time_table.text = details
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
