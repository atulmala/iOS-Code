//
//  TeacherMessageRecordTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 30/11/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import AWSMobileAnalytics
import SwiftyJSON
import Just

class MessageSource: NSObject   {
    var id: String
    var date: String
    var message: String
    var sent_to: String
    var the_class: String
    var section: String
    var activity_group: String
    var teacher: String
    
    init(id: String, date: String, message: String, sent_to: String, the_class: String, section: String, activity_group: String, teacher: String) {
        self.id = id
        self.date = date
        self.message = message
        self.sent_to = sent_to
        self.the_class = the_class
        self.section = section
        self.activity_group = activity_group
        self.teacher = teacher
        super.init()
    }
}

class TeacherMessageRecordTVC: UITableViewController {
    var messsage_list: [MessageSource] = []
    var message_id: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Teacher Message Record")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
        
        let server_ip: String = MiscFunction.getServerIP()
        let user: String = SessionManager.getLoggedInUser()
        let url: String =  "\(server_ip)/teachers/message_list/\(user)/"
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    
                    let date: String = j[index]["date"].string!
                    // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
                    let yyyymmdd = date
                    let yy = yyyymmdd[2...3]
                    let mm = yyyymmdd[5...6]
                    let dd = yyyymmdd[8...9]
                    let ddmmyy = dd + "/" + mm +  "/"   + yy
                    
                    let message: String = j[index]["message"].string!
                    var sent_to: String = j[index]["sent_to"].string!
                    
                    var the_class: String = ""
                    if j[index]["the_class"].string != nil{
                        the_class = j[index]["the_class"].string!
                    }
                    var section: String = ""
                    if j[index]["section"].string != nil{
                        section = j[index]["section"].string!
                    }
                    
                    sent_to += "(\(the_class)-\(section))"
                    
                    var activity_group: String = ""
                    if j[index]["activity_group"].string != nil{
                        activity_group = j[index]["activity_group"].string!
                    }
                    
                    let teacher: String = "teacher"
                    
                    messsage_list.append(MessageSource(id: id, date: ddmmyy, message: message, sent_to: sent_to, the_class: the_class, section: section, activity_group: activity_group, teacher: teacher))
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Message History"
        self.navigationItem.titleView = lable
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
        return messsage_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacher_message_cell", for: indexPath) as! TeacherMessageCell

        // Configure the cell...
        cell.id.text = messsage_list[indexPath.row].id
        cell.date.text = messsage_list[indexPath.row].date
        cell.sent_to.text = messsage_list[indexPath.row].sent_to
        cell.message.text = messsage_list[indexPath.row].message
        //cell.message.textAlignment = NSTextAlignment.left
        cell.message.numberOfLines = 0
        cell.message.lineBreakMode = NSLineBreakMode.byWordWrapping
        //cell.accessoryType = .disclosureIndicator
        //cell.message.sizeToFit()
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        message_id = messsage_list[indexPath.row].id
        performSegue(withIdentifier: "to_message_receivers", sender: self)
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc: TeacherMessageReceiversTVC = segue.destination as! TeacherMessageReceiversTVC
        vc.message_id = message_id
    }
    

}
