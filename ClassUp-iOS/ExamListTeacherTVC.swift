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
    
    var selected_exam: String = ""
    var selected_id: String = ""
    var selected_exam_type: String = ""
    
    @IBOutlet weak var nav_item: UINavigationItem!

    override func viewDidLoad() {
        print("starting")
        super.viewDidLoad()
        self.view.tintColor = UIColor.black
        nav_item.title = "Select an Exam"
        nav_item.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action:#selector(ExamListTeacherTVC.go_next))
        nav_item.rightBarButtonItem?.isEnabled = false

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
        cell.exam_title.text = title_list[indexPath.row]
        cell.exam_id.text = id_list[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nav_item.rightBarButtonItem?.isEnabled = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacher_exam_cell", for: indexPath) as! ExamCellTVC
        if cell.accessoryType == .checkmark    {
            cell.accessoryType = .none
        }
        else    {
            cell.accessoryType = .checkmark
        }
        selected_id = id_list[indexPath.row]
        selected_exam = title_list[indexPath.row]
        selected_exam_type = exam_type_list[indexPath.row]
        
    }
    
    func go_next() {
        print("entered next")
        print("trigger = \(trigger)")
        if trigger == "scheduleTest"    {
            let alert = UIAlertController(title: "Please confirm", message: "Are you sure to schedule a test for \(selected_exam)?.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.performSegue(withIdentifier: "schedule_test_sel_class_sec_sub", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
        if trigger == "to_tests_list"    {
            performSegue(withIdentifier: "show_test_in_exam", sender: self)
        }
        
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
        SessionManager.set_exam_id(id: selected_id)
        SessionManager.set_exam_type(ex_type: selected_exam_type)
        SessionManager.set_exam_title(title: selected_exam)
        
        switch trigger {
        case "scheduleTest":
            let destinationVC = segue.destination as! SelectDateClassSectionSubjectVC
            destinationVC.trigger = trigger
            destinationVC.exam_title = selected_exam
            
        case "to_tests_list":
            _ = segue.destination as! TestDetailsTBC
        default:
            break
        }
    }
    

}
