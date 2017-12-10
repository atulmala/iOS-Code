//
//  TeacherMessageReceiversTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 02/12/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON
import AWSMobileAnalytics

class MessageReceiversModel: NSObject   {
    var id: String
    var student: String
    var message: String
    var outcome: String
    
    init (id: String, student: String, message: String, outcome: String)    {
        self.id = id
        self.student = student
        self.message = message
        self.outcome = outcome
        
        super.init()
    }
}

class TeacherMessageReceiversTVC: UITableViewController {
    var message_id: String = ""
    var message_list: [MessageReceiversModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Teacher Message Receivers")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        

        let server_ip: String = MiscFunction.getServerIP()
        let url: String =  "\(server_ip)/teachers/receivers_list/\(message_id)/"
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
                    
                    let student: String = j[index]["student"].string!
                    let message: String = j[index]["full_message"].string!
                    let outcome: String = j[index]["outcome"].string!
                    
                    message_list.append(MessageReceiversModel(id: id, student: student, message: message, outcome: outcome))
                }
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Message Receivers"
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
        return message_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message_receiver_cell", for:indexPath) as! MessageReceiversCell
        cell.student_name.text = message_list[indexPath.row].student
        cell.message.text = message_list[indexPath.row].message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let outcome: String = message_list[indexPath.row].outcome
        let alertController = UIAlertController(title: "Status", message:
            outcome, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

}
