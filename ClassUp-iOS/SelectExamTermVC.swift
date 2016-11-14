//
//  SelectExamTermVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just


class SelectExamTermVC: UIViewController {
    var student_id: String = ""
    var student_full_name: String = ""
    
    var exam_id: String = ""
    var exam_title: String = ""
    
    struct ExamModel    {
        var exam_id: String = ""
        var exam_title: String = ""
    }
    
    var exam_list: [ExamModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let server_ip: String = MiscFunction.getServerIP()
        let url: String = "\(server_ip)/academics/get_exam_list/\(student_id)/"
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count {
                for index in 0...ct-1 {
                    var em = ExamModel()
                    
                    if let _ = j[index]["id"].int {
                        let name = j[index]["id"]
                        let id = String(stringInterpolationSegment: name)
                        em.exam_id = id
                    }
                    if let title = j[index]["title"].string {
                        em.exam_title = title
                    }
                    exam_list.append(em)
                    print(exam_list)
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return exam_list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exam_list_cell", for: indexPath as IndexPath) as! ExamCellTVC
        
        cell.exam_title.text = exam_list[indexPath.row].exam_title
        cell.exam_id.text = exam_list[indexPath.row].exam_id
        cell.exam_id.isHidden = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("a cell has been  tapped")
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! ExamCellTVC
        exam_id = cell.exam_id.text!
        exam_title = cell.exam_title.text!
        
        performSegue(withIdentifier: "show_exam_results", sender: self)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! ExamResultVC
        destinationVC.student_id = student_id
        destinationVC.exam_id = exam_id
        destinationVC.student_full_name = student_full_name
        destinationVC.exam_title = exam_title
    }
}
