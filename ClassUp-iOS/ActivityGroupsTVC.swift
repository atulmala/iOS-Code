//
//  ActivityGroupsTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/11/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import AWSMobileAnalytics
import Just
import SwiftyJSON

class GroupSource: NSObject{
    var id: String = ""
    var activity_group: String = ""
    var incharge: String = ""
    var incharge_email: String = ""
    
    init (id: String, activity_group: String, incharge: String, incharge_email: String) {
        self.id = id
        self.activity_group = activity_group
        self.incharge = incharge
        self.incharge_email = incharge_email
        
        super.init()
    }
}

class ActivityGroupsTVC: UITableViewController {
    var group_id: String = ""
    var group_name: String = ""
    var group_list: [GroupSource] = []
    
    var destination = "ComposeMessage"

    override func viewDidLoad() {
        super.viewDidLoad()

        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Activity Groups")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ActivityGroupsTVC.longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        // call the api to retrieve the messages sent to this parent
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let url: String =  "\(server_ip)/activity_groups/get_activity_group_list/\(school_id)/"
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
                    
                    let activity_group: String = j[index]["group_name"].string!
                    
                    let incharge: String = j[index]["group_incharge"].string!
                    let incharge_email: String = j[index]["incharge_email"].string!
                    
                    group_list.append(GroupSource(id: id, activity_group: activity_group, incharge: incharge, incharge_email: incharge_email))
                }
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Activity Groups List"
        self.navigationItem.titleView = lable
        tableView.reloadData()
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer)    {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began   {
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            if tableView.indexPathForRow(at: touchPoint) != nil {
                // ge the name of the student
                
                let cell = tableView.cellForRow(at: tableView.indexPathForRow(at: touchPoint)! as IndexPath) as! ActivityGroupCell
                group_id = cell.group_id.text!
                group_name = cell.group_name.text!
                let alert: UIAlertController = UIAlertController(title: "Members List", message: "Do you want to see the list of members in Group:  \(group_name) (Group id: \(group_id))?", preferredStyle: .alert )
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    self.destination = "ShowGroupMembers"
                    self.performSegue(withIdentifier: "show_group_members", sender: self)
                    
                    return
                })
                alert.addAction(confirmAction)
                present(alert, animated: true, completion: nil)
                
            }
        }
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
        return group_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activity_group_cell", for: indexPath as IndexPath) as! ActivityGroupCell
        cell.group_id.text = group_list[indexPath.row].id
        cell.group_name.text = group_list[indexPath.row].activity_group
        cell.group_incharge.text = group_list[indexPath.row].incharge
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destination = "ComposeMessage"
        let logged_in_user: String = SessionManager.getLoggedInUser()
        let incharge: String = group_list[indexPath.row].incharge_email
        if logged_in_user != incharge   {
            let message: String = "You are not the Incharge of this group. Hence, you cannot send message to this group."
            let alert = UIAlertController(title: "Autherization Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else    {
            group_id = group_list[indexPath.row].id
            performSegue(withIdentifier: "to_compose_message", sender: self)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        switch destination  {
            case "ComposeMessage":
                let destinationVC = segue.destination as! ComposeMessageVCViewController
                destinationVC.coming_from = "ActivityGroup"
                destinationVC.group_id = group_id
                break;
            case "ShowGroupMembers":
                let destinationVC = segue.destination as! ActivityMemberTVC
                destinationVC.group_id = group_id
                destinationVC.group_name = group_name
                break
            default:
                break
            
        }
    }
    

}
