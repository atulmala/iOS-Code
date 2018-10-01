//
//  UpcomingTestTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 20/06/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import AWSMobileAnalytics

class UpcomingTestTVC: UITableViewController {
    var student_id: String = ""
    var student_full_name: String = ""
    
    var date: [String] = []
    var tests: [String] = []
    var topics: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Upcoming Tests")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()

        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let server_ip = MiscFunction.getServerIP()
        let url = "\(server_ip)/academics/pending_test_list_parents/\(student_id)/"
        
        MiscFunction.sendRequestToServer(url: url, key: "date_conducted", list: &date, sender: "UpcomingTests")
        MiscFunction.sendRequestToServer(url: url, key: "subject", list: &tests, sender: "UpcomingTests")
        MiscFunction.sendRequestToServer(url: url, key: "test_type", list: &topics, sender: "UpcomingTests")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Upcoming Tests for \(student_full_name)"
        self.navigationItem.titleView = lable
        tableView.reloadData()
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
        return tests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcoming_test_cell", for: indexPath) as! UpcomintTestCell
        
        let date_conducted = date[indexPath.row]
        // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
        let yyyymmdd = date_conducted
        let yy = yyyymmdd[2...3]
        let mm = yyyymmdd[5...6]
        let dd = yyyymmdd[8...9]
        let ddmmyy = dd + "/" + mm +  "/"   + yy
        cell.test_date.text = ddmmyy
        
        cell.test.text = tests[indexPath.row]
        cell.test_topics.text = topics[indexPath.row]
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
