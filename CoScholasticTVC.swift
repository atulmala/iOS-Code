//
//  CoScholasticTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 13/10/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just
import Alamofire
import AWSMobileAnalytics

class CoScholasticTVC: UITableViewController {
    var the_class: String = ""
    var section: String = ""
    var term: String = ""
    
    var grade_list: [CoScholasticModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.blue
        
        let server_ip: String = MiscFunction.getServerIP()
        let teacher: String = SessionManager.getLoggedInUser()
        let url: String = "\(server_ip)/academics/get_co_cscholastics/\(teacher)/\(the_class)/\(section)/\(term)"
        var j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    // 04/10/2017 - we do not display the roll no separately. Instead show the
                    // serial number in front of the name and this can be considered as roll no
                    let prefix: String = String(index + 1)
                    var space: String
                    if prefix.characters.count == 1 {
                        space = ".    "
                    }
                    else{
                        space = ".  "
                    }
                    
                    let the_name: String = j[index]["student"].string!
                    let full_name = "\(prefix)\(space)\(the_name)"
                    
                    let parent: String = j[index]["parent"].string!
                    
                    let grade_work_ed: String = j[index]["work_education"].string!
                    let grade_art_ed: String = j[index]["art_education"].string!
                    let grade_health_ed: String = j[index]["health_education"].string!
                    let grade_dscpln: String = j[index]["discipline"].string!
                    let remarks: String = j[index]["teacher_remarks"].string!
                    let promoted: String = j[index]["promoted_to_class"].string!
                    
                    grade_list.append(CoScholasticModel(id: id, term: term, full_name: full_name, parent: parent, grade_work_ed: grade_work_ed, grade_art_ed: grade_art_ed, grade_health: grade_health_ed, grade_dscpln: grade_dscpln, remarks_class_teacher: remarks, promoted_to_class: promoted))
                }
            }
        }
        
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.white
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.left
        
        lable.text = "\(the_class)-\(section) \(term)"
        self.navigationItem.titleView = lable
        
        let save_button = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(CoScholasticTVC.saveGrades(sender:)))
        
        let submit_button = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(CoScholasticTVC.submitGrades))
        self.navigationItem.rightBarButtonItems = [submit_button, save_button]


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        return grade_list.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "co_scholastic_cell", for: indexPath) as! CoScholasticCell
        
        // Configure the cell...
        cell.delegate = self
        cell.selectionStyle = .none
        cell.id.text = grade_list[indexPath.row].id
        cell.full_name.text = grade_list[indexPath.row].full_name
        cell.parent_name.text = grade_list[indexPath.row].parent
        
        switch grade_list[indexPath.row].grade_work_ed {
            case "A":
                cell.work_ed_grade.selectedSegmentIndex = 0
                break
            case "B":
                cell.work_ed_grade.selectedSegmentIndex = 1
                break;
            case "C":
                cell.work_ed_grade.selectedSegmentIndex = 2
            default:
                cell.work_ed_grade.selectedSegmentIndex = -1
        }
        
        switch grade_list[indexPath.row].grade_health {
            case "A":
                cell.health_grade.selectedSegmentIndex = 0
                break
            case "B":
                cell.health_grade.selectedSegmentIndex = 1
                break
            case "C":
                cell.health_grade.selectedSegmentIndex = 2
                break
            default:
                cell.health_grade.selectedSegmentIndex = -1
                
        }
        
        switch grade_list[indexPath.row].grade_art_ed {
            case "A":
                cell.art_ed_grade.selectedSegmentIndex = 0
                break
            case "B":
                cell.art_ed_grade.selectedSegmentIndex = 1
                break
            case "C":
                cell.art_ed_grade.selectedSegmentIndex = 2
                break
            default:
                cell.art_ed_grade.selectedSegmentIndex = -1
        }
        
        switch grade_list[indexPath.row].grade_dscpln {
            case "A":
                cell.dscpln_grade.selectedSegmentIndex = 0
                break
            case "B":
                cell.dscpln_grade.selectedSegmentIndex = 1
                break
            case "C":
                cell.dscpln_grade.selectedSegmentIndex = 2
                break
            default:
                cell.dscpln_grade.selectedSegmentIndex = -1
        }
        
        cell.ramarks.text = grade_list[indexPath.row].remarks_class_teacher
        
        if term == "term1"  {
            cell.promoted_to_class.isHidden = true
            cell.promoted_lbl.isHidden = true
        }
        else{
            cell.promoted_to_class.text = grade_list[indexPath.row].promoted_to_class
        }
        
        return cell
    }
    
    func saveGrades(sender: UIButton)    {
        var grades_dictionary = [String:[String:String]]()
        
        for i in 0 ..< grade_list.count {
            
            grades_dictionary[grade_list[i].id] = [
                "term": term,
                "work_education": grade_list[i].grade_work_ed,
                "art_education": grade_list[i].grade_art_ed,
                "health_education": grade_list[i].grade_health,
                "discipline": grade_list[i].grade_dscpln,
                "teacher_remarks": grade_list[i].remarks_class_teacher,
                "promoted_to_class": grade_list[i].promoted_to_class
            ]
        }
        
        let server_ip = MiscFunction.getServerIP()
        let url = "\(server_ip)/academics/save_co_scholastics/"
        
        
        Alamofire.request(url, method: .post, parameters: grades_dictionary, encoding: JSONEncoding.default).responseJSON { response in
        }
        
        showAlert(title: "CoScholastic Grades Saved", message: "CoScholastic Grades Saved")
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Saved Coscholastics")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
    }
    
    @objc func submitGrades() {
        for i in 0 ..< grade_list.count {
            let student = grade_list[i].full_name
            
            if grade_list[i].grade_work_ed == " "    {
                let message = "Please enter Work Education Grade for Roll No: \(student)"
                let alertController = UIAlertController(title: "Incomplete Entries", message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                return
            }
            
            if grade_list[i].grade_art_ed == " " {
                let message = "Please enter Art Education Grade for Roll No: \(student)"
                let alertController = UIAlertController(title: "Incomplete Entries", message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                return
            }
            
            if grade_list[i].grade_health == " " {
                let message = "Please enter Health & Physical Education Grade for Roll No: \(student)"
                let alertController = UIAlertController(title: "Incomplete Entries", message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                return

            }
            
            if grade_list[i].grade_dscpln == " " {
                let message = "Please enter Discipline Grade for Roll No: \(student)"
                let alertController = UIAlertController(title: "Incomplete Entries", message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                return
            }
            
            var grades_dictionary = [String:[String:String]]()
            
            for i in 0 ..< grade_list.count {
                grades_dictionary[grade_list[i].id] = [
                    "term": term,
                    "work_education": grade_list[i].grade_work_ed,
                    "art_education": grade_list[i].grade_art_ed,
                    "health_education": grade_list[i].grade_health,
                    "discipline": grade_list[i].grade_dscpln,
                    "teacher_remarks": grade_list[i].remarks_class_teacher,
                    "promoted_to_class": grade_list[i].promoted_to_class
                ]
            }
            
            let server_ip = MiscFunction.getServerIP()
            let url = "\(server_ip)/academics/save_co_scholastics/"
            
            Alamofire.request(url, method: .post, parameters: grades_dictionary, encoding: JSONEncoding.default).responseJSON { response in
            }
            
            showAlert(title: "CoScholastic Grades Submitted", message: "CoScholastic Grades Submitted")
            
            let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
            let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
            let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Submit Coscholastics")
            eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
            eventClient.record(event)
            eventClient.submitEvents()
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
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
