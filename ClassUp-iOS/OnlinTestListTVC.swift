//
//  OnlinTestListTVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 18/05/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just
import Alamofire

class OnlineTestModel: NSObject {
    var id: String
    var date: String
    var the_class: String
    var subject: String
    var duration: Int
    
    init(id: String, date: String, the_class: String, subject: String, duration: Int) {
        self.id = id
        self.date = date
        self.the_class = the_class
        self.subject = subject
        self.duration = duration
        super.init()
    }
}

class OnlinTestListTVC: UITableViewController {
    let server_ip: String = MiscFunction.getServerIP()
    
    var test_list: [OnlineTestModel] =  []
    var sender: String = ""
    var student_id: String = ""
    var student_name: String = ""
    var selected_test : String = ""
    var subject: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url: String = "\(server_ip)/online_test/get_online_test/\(student_id)"
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
                    
                    let the_class: String = j[index]["the_class"].string!
                    let subject: String = j[index]["subject"].string!
                    let duration: Int = j[index]["duration"].int!
                    
            test_list.append(OnlineTestModel(id:id,date:ddmmyy, the_class:the_class, subject:subject, duration:duration))
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        print("inside viewDidAppear")
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Online Test List"
        self.navigationItem.titleView = lable
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return test_list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "online_test_cell", for: indexPath) as! OnlineTestCell

        cell.test_date.text = test_list[indexPath.row].date
        cell.subject_name.text = test_list[indexPath.row].subject

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_test = test_list[indexPath.row].id
        subject = test_list[indexPath.row].subject
        performSegue(withIdentifier: "show_instructions", sender: self)
    }

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ShowInstructionsVC
        destinationVC.test_id = selected_test
        destinationVC.student_id = student_id
        destinationVC.subject = subject
    }
    

}
