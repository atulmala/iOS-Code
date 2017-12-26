//
//  CompletedTestListVC.swift
//  Classup1
//
//  Created by Atul Gupta on 24/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Just
import SwiftyJSON

class CompletedTestListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var test_list: [TestModel] = []
    var current_test_id: String = ""
    var whether_grade_based: Bool = false
    
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    var test_type: String = ""
    var whether_higher_class = ""
    var destination = ""

        override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the api to ge the list of Completed tests
        let server_ip: String = MiscFunction.getServerIP()
        let user: String = SessionManager.getLoggedInUser()
        let url: String = "\(server_ip)/academics/completed_test_list/\(user)/?format=json"
        //print("url=\(url)")
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
                    
                    // 05/10/2017 - now we distinguish between unit test and term test. Hence getting the test type
                    let test_type: String = j[index]["test_type"].string!
                    
                    // 25/12/2017 - For higher classes (XI & XII), test handling will be different. We need to determine if the test is for higher classes
                    var whether_higher_class: String = "false"
                    if the_class == "XI" || the_class == "XII"  {
                        whether_higher_class = "true"
                    }
                    
                    test_list.append(TestModel(id: id, date: ddmmyy, the_class: the_class, section: section, subject: subject, mm: max_marks, grade_based: String(stringInterpolationSegment: gb), test_type: test_type, whether_higher_class: whether_higher_class))
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
    func numberOfRowsInSection(in tableView:UITableView) ->Int  {
        return test_list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test_list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "completed_test_cell", for: indexPath as IndexPath) as! TestCellVC
        
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
        cell.test_type.text = test_list[indexPath.row].test_type
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "header_cell") as! HeaderCell
        header_cell.backgroundColor = UIColor.cyan
        
        switch(section) {
        case 0:
            header_cell.date.text = "Date"
            header_cell.the_class.text = "Class"
            header_cell.section.isHidden = true
            header_cell.section.text = ""
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
        if cell.max_marks.text == "Grade Based" {
            whether_grade_based = true
        }
        
        current_test_id = cell.test_id.text!
        test_type = cell.test_type.text!
        
        whether_higher_class = test_list[indexPath.row].whether_higher_class
        
        performSegue(withIdentifier: "to_test_marks_entry", sender: self)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TestMarksEntryVC
        destinationVC.test_id = current_test_id
        destinationVC.whether_grade_based = whether_grade_based
        destinationVC.the_class = the_class
        destinationVC.section = section
        destinationVC.subject = subject
        destinationVC.unit_or_term = test_type
        destinationVC.whether_higher_class = whether_higher_class
    }

    
    
}

extension String {
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex,
                               offsetBy: max(0,range.lowerBound),
                               limitedBy: endIndex) ?? endIndex
        return substring(
            with: lowerIndex..<(index(lowerIndex,
                                      offsetBy: range.upperBound - range.lowerBound + 1,
                                      limitedBy: endIndex) ?? endIndex))
    }
}
