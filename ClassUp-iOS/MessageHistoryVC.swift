//
//  MessageHistoryVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 04/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON
import AWSMobileAnalytics

class MessageModel:NSObject {
    var id: String
    var date: String
    var message: String
    
    init(id: String, date: String, message: String)  {
        self.id = id
        self.date = date
        self.message = message
        
        super.init()
    }
}

class MessageHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var message_list: [MessageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Communication History")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        // call the api to retrieve the messages sent to this parent
        let server_ip: String = MiscFunction.getServerIP()
        let user: String = SessionManager.getLoggedInUser()
        let url: String =  "\(server_ip)/operations/retrieve_sms_history/\(user)/"
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let date: String = j[index]["date"].string!
                    // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
                    let yyyymmdd = date
                    let yy = yyyymmdd[2...3]
                    let mm = yyyymmdd[5...6]
                    let dd = yyyymmdd[8...9]
                    let ddmmyy = dd + "/" + mm +  "/"   + yy

                    let message: String = j[index]["message"].string!
                    
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    message_list.append(MessageModel(id: id, date: ddmmyy, message: message))
                }
            }
        }

        // Do any additional setup after loading the view.
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message_history_cell", for: indexPath as IndexPath) as! MessageHistoryCellTableViewCell
        cell.message_date.text = message_list[indexPath.row].date
        cell.message.text = message_list[indexPath.row].message
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
