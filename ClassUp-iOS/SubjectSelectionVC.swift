//
//  SubjectSelectionVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class SubjectSelectionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var student_id: String = ""
    var student_full_name: String = ""
    var selected_subject: String = ""
    
    var subject_list: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let server_ip: String = MiscFunction.getServerIP()
        let url: String = "\(server_ip)/parents/retrieve_student_subjects/?student=\(student_id)"
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count {
                for index in 0...ct-1 {
                    if let subject = j[index]["subject"].string {
                        if !subject_list.contains(subject)  {
                            subject_list.append(subject)
                        }
                        print(subject_list)
                    }
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
            }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return subject_list.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject_list_cell", for: indexPath as IndexPath) as! SubjectListCellTVC
        
        cell.subject_name.text = subject_list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("a cell has been  tapped")
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! SubjectListCellTVC
        selected_subject = cell.subject_name.text!
        
        performSegue(withIdentifier: "show_subject_marks", sender: self)
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! SubjectMarksHistoryVC
        destinationVC.student_id = student_id
        destinationVC.student_full_name = student_full_name
        destinationVC.subject_name = selected_subject
    }
    

}
