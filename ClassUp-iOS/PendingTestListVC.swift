//
//  PendingTestListVC.swift
//  Classup1
//
//  Created by Atul Gupta on 24/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Just

class PendingTestListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var test_list: [TestModel] = []
    var current_test_id: String = ""
    var whether_grade_based: Bool = false
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    var destination: String = ""

    @IBOutlet weak var nav_bar: UINavigationItem!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.white
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        
        lable.text = "Pending Test List"
        self.navigationItem.titleView = lable
        
        // call the api to ge the list of pending tests
        let server_ip: String = MiscFunction.getServerIP()
        let user: String = SessionManager.getLoggedInUser()
        let url: String = "\(server_ip)/academics/pending_test_list/\(user)/?format=json"
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if count! > 0    {
            if let ct = count    {
                for index in 0...ct-1   {
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    
                    let date_conducted = j[index]["date_conducted"].string!
                    // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
                    let yyyymmdd = date_conducted
                    let yy = yyyymmdd[2...3]
                    let mm = yyyymmdd[5...6]
                    let dd = yyyymmdd[8...9]
                    let ddmmyy = dd + "/" + mm +  "/"   + yy
                    
                    let the_class = j[index]["the_class"].string!
                    let section = j[index]["section"].string!
                    let subject = j[index]["subject"].string!
                    
                    var max_marks: String = ""
                    let m = j[index]["max_marks"].string!
                    let m1 = String(stringInterpolationSegment: m)
                    let m2 = String(m1.characters.dropLast())
                    let mm1 = String(m2.characters.dropLast())
                    let mm2 = String(mm1.characters.dropLast())
                    max_marks = String(stringInterpolationSegment: mm2)
                    
                    let gb = j[index]["grade_based"].bool!
                    if gb  {
                        max_marks = "Grade Based"
                    }
                    
                    test_list.append(TestModel(id: id, date: ddmmyy, the_class: the_class, section: section, subject: subject, mm: max_marks, grade_based: String(stringInterpolationSegment: gb)))
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain,
            target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pending_test_cell", for: indexPath as IndexPath) as! TestCellVC
        // configure the cell
        cell.test_id.isHidden = true
        cell.test_id.text = test_list[indexPath.row].id
        cell.test_date.numberOfLines = 0
        cell.test_date.lineBreakMode = NSLineBreakMode.byWordWrapping;
        cell.test_date.text = test_list[indexPath.row].date
        cell.the_class.text = test_list[indexPath.row].the_class
        cell.section.text = test_list[indexPath.row].section
        cell.subject.numberOfLines = 0
        cell.subject.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.subject.text = test_list[indexPath.row].subject
        cell.max_marks.numberOfLines = 0
        cell.max_marks.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.max_marks.text = test_list[indexPath.row].max_marks
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "header_cell") as! HeaderCell
        header_cell.backgroundColor = UIColor.cyan
        
        switch(section) {
        case 0:
            header_cell.date.text = "Date"
            header_cell.the_class.text = "Class"
            header_cell.section.text = ""
            header_cell.section.isHidden = true
            header_cell.subject.text = "Subject"
            header_cell.max_marks.text = "Max Marks"
        default:
            header_cell.date.text = "Date"
            header_cell.the_class.text = "Class"
            header_cell.section.text = "Section"
            header_cell.subject.text = "Subject"
            header_cell.max_marks.text = "Max Marks"
            
        }
        return header_cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! TestCellVC
        
        the_class = cell.the_class.text!
        section = cell.section.text!
        subject = cell.subject.text!
        
        current_test_id = cell.test_id.text!
        if cell.max_marks.text == "Grade Based" {
            whether_grade_based = true
        }

        destination = "to_test_marks_entry"
        performSegue(withIdentifier: "to_test_marks_entry", sender: self)
    }
    
    // for swipe delete a test
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete  {
            let alert: UIAlertController = UIAlertController(title: "Confirm Test Deletion", message: "Are you sure that you want to delete this test? Any saved Marks/Grade will also be deleted", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancelAction)
            
            let confirmAction = UIAlertAction(title: "Delete Test", style: .default, handler: {(action: UIAlertAction) in
                
                let server_ip = MiscFunction.getServerIP()
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! TestCellVC
                let url = server_ip + "/academics/delete_test/" + cell.test_id.text! + "/"
                let r = Just.delete(url)
                if r.statusCode == 200  {
                    let alert: UIAlertController = UIAlertController(title: "Done", message: "Test Deleted", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.destination = "to_main_menu"
                    self.performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
                }
            })
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if destination == "to_test_marks_entry" {
            let destinationVC = segue.destination as! TestMarksEntryVC
            destinationVC.test_id = current_test_id
            destinationVC.whether_grade_based = whether_grade_based
            destinationVC.the_class = the_class
            destinationVC.section = section
            destinationVC.subject = subject
        }
        if destination == "to_main_menu"    {
            let destinationVC = segue.destination as! MainMenuVC
            destinationVC.comingFrom = "PendingTestList"
        }
    }
    
}

