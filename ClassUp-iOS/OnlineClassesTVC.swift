//
//  OnlineClassesTVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 03/04/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class OnlineClassModel: NSObject {
    var id: String
    var date: String
    var the_class: String
    var subject: String
    var topic: String
    var teacher: String
    var youtube_link: String
    var doc_link: String
    
    init(id: String, date: String, the_class: String, subject: String, topic: String, teacher: String, youtube_link: String, doc_link: String) {
        self.id = id
        self.date = date
        self.the_class = the_class
        self.subject = subject
        self.topic = topic
        self.teacher = teacher
        self.youtube_link = youtube_link
        self.doc_link = doc_link
        super.init()
    }
    
}

class OnlineClassesTVC: UITableViewController {
    var lecture_list: [OnlineClassModel] = []
    var student_id: String = ""
    var student_name: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let server_ip: String = MiscFunction.getServerIP()
        let url: String = "\(server_ip)/lectures/get_student_lectures/\(student_id)/"
        
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
                    
                    let date: String = j[index]["creation_date"].string!
                    // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
                    let yyyymmdd = date
                    let yy = yyyymmdd[2...3]
                    let mm = yyyymmdd[5...6]
                    let dd = yyyymmdd[8...9]
                    let ddmmyy = dd + "/" + mm +  "/"   + yy
                    
                    let the_class: String = j[index]["the_class"].string!
                    let subject: String = j[index]["subject"].string!
                    let topic: String = j[index]["topic"].string!
                    let teacher: String = j[index]["teacher"].string!
                    let youtube_link: String = j[index]["youtube_link"].string!
                    let pdf_link: String = j[index]["pdf_link"].string ?? "Unavailable"
                    
                    
                    lecture_list.append(OnlineClassModel(id:id, date:ddmmyy, the_class:the_class, subject: subject, topic:topic, teacher:teacher, youtube_link: youtube_link, doc_link: pdf_link))
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Online Classes List"
        self.navigationItem.titleView = lable
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lecture_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "online_class_cell", for: indexPath) as! OnlineClassCell

        // Configure the cell...
        cell.date.text = lecture_list[indexPath.row].date
        cell.the_class.text = lecture_list[indexPath.row].the_class
        cell.subject.text = lecture_list[indexPath.row].subject
        cell.topic.text = lecture_list[indexPath.row].topic
        cell.teacher.text = lecture_list[indexPath.row].teacher
        
        cell.youtube_link.isUserInteractionEnabled = true
        
        cell.youtube_link.text = lecture_list[indexPath.row].youtube_link
        cell.youtube_link.dataDetectorTypes = .link
        cell.youtube_link.isUserInteractionEnabled = true
        cell.pdf_link.text = lecture_list[indexPath.row].doc_link

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
