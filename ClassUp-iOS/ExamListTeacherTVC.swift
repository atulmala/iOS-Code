//
//  ExamListTeacherTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 19/05/18.
//  Copyright © 2018 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import AWSMobileAnalytics
import Alamofire
import SwiftyJSON

class ExamListTeacherTVC: UITableViewController {
    var trigger: String = ""
    
    var id_list: [String] = []
    var exam_type_list: [String] = []
    var title_list: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Show Exam List Teacher")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
        
        let server_ip: String = MiscFunction.getServerIP()
        let teacher: String = SessionManager.getLoggedInUser()
        
        let url = "\(server_ip)/academics/get_exam_list_teacher/\(teacher)/"
        
        MiscFunction.sendRequestToServer(url: url, key: "id", list: &id_list, sender: "ExamListTeacherTVC")
        print(id_list)
        MiscFunction.sendRequestToServer(url: url, key: "exam_type", list: &exam_type_list, sender: "ExamListTeacherTvc")
        print(exam_type_list)
        MiscFunction.sendRequestToServer(url: url, key: "title", list: &title_list, sender: "ExamListTeacherTVC")
        print(title_list)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exam_type_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacher_exam_cell", for: indexPath) as! ExamCellTVC
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
