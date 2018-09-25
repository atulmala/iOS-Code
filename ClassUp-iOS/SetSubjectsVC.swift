//
//  SetSubjectsVC.swift
//  Classup1
//
//  Created by Atul Gupta on 06/10/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Just
import SwiftyJSON
import AWSMobileAnalytics

class SetSubjectsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var subject_name_list: [String] = []
    @IBOutlet weak var nav_item: UINavigationItem!
    var subject_id_list: [String] = []
    var subject_list: [SubjectModel] = []
    var my_subjects: [String] = []
    var already_set_subjects: [String] = []
    var subjects_to_remove: [String] = []
    
    override func viewDidLoad() {
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Set Subjects")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()

        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        
        let subjectURL = "\(server_ip)/academics/subject_list/\(school_id)/?format=json"
        let j = JSON(Just.get(subjectURL).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let subject_name: String = j[index]["subject_name"].string!
                    subject_name_list.append(subject_name)
                    let subject_code: String = j[index]["subject_code"].string!
                    subject_id_list.append(subject_code)
                    subject_list.append(SubjectModel(id: subject_code, subject: subject_name))
                }
            }
        }
        
        // get the list of subjects already set for this teacher
        let logged_in_user = SessionManager.getLoggedInUser()
        let already_set_subjects_url = "\(server_ip)/teachers/teacher_subject_list/\(logged_in_user)/?format=json"
        MiscFunction.sendRequestToServer(url: already_set_subjects_url, key: "subject", list: &already_set_subjects, sender: "SelectSubjectVC")
        
        nav_item.title = "Tap a subject to select/de-select"
        let submit_button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SetSubjectsVC.setSubjects(sender:)))
        navigationItem.rightBarButtonItems = [submit_button]

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subject_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject", for: indexPath as IndexPath) as! SubjectSelectionCell
        // configure the cell
        cell.subject.text = subject_list[indexPath.row].subject as String
        cell.id.isHidden = true
        cell.id.text = subject_list[indexPath.row].id as String
        
        // show a check mark against already selected subjects and the subjects which are selected now
        if (already_set_subjects.index(of: subject_list[indexPath.row].subject as String) != nil)  {
            cell.accessoryType = .checkmark
        }
        else if my_subjects.index(of: cell.id.text!) != nil{
            cell.accessoryType = .checkmark
        }
        else    {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! SubjectSelectionCell?
        
        if cell?.accessoryType == .checkmark    {
            cell?.accessoryType = .none
            if my_subjects.index(of: (cell?.id.text!)!) != nil{
                my_subjects.remove(at: my_subjects.index(of: (cell?.id.text!)!)!)
            }
            if already_set_subjects.index(of: (cell?.subject.text!)!) != nil{
                already_set_subjects.remove(at: already_set_subjects.index(of: (cell?.subject.text!)!)!)
                
                if subjects_to_remove.index(of: (cell?.id.text!)!) == nil  {
                    subjects_to_remove.append((cell?.id.text!)!)
                }
            }
        }
        else    {
            cell?.accessoryType = .checkmark
            
            if my_subjects.index(of: (cell?.id.text!)!) == nil{
                my_subjects.append((cell?.id.text!)!)
            }
            if subjects_to_remove.index(of: (cell?.id.text!)!) != nil{
                subjects_to_remove.remove(at: subjects_to_remove.index(of: (cell?.id.text!)!)!)
            }
        }
    }
    
    @IBAction func setSubjects(sender: UIButton) {
        
        // first unset the subjects
        var dictionary1 = [String:String]()
        
        for i in 0 ..< subjects_to_remove.count  {
            dictionary1[self.subject_name_list[self.subject_id_list.index(of: self.subjects_to_remove[i])!]] = self.subjects_to_remove[i] as String
        }
        
        let server_ip = MiscFunction.getServerIP()
        let teacher = SessionManager.getLoggedInUser()
        
        
        let unset_url = "\(server_ip)/teachers/unset_subjects/\(teacher)/"
        
        Alamofire.request(unset_url, method: .post, parameters: dictionary1, encoding: JSONEncoding.default)
            .responseJSON { response in
                
        }
        
        // now, set the subjects selected by user
        var dictionary = [String:String]()

        for i in 0 ..< my_subjects.count    {
            dictionary[subject_name_list[(subject_id_list.index(of: my_subjects[i]))!]] = my_subjects[i] as String
            
        }
        
        
        let url = "\(server_ip)/teachers/set_subjects/\(teacher)/"
        Alamofire.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default)
            .responseJSON { response in
                
        }
        performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
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
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "SetSubjectVC"
    }
}
