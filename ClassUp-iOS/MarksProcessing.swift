//
//  MarksProcessing.swift
//  Classup1
//
//  Created by Atul Gupta on 30/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Alamofire
import AWSMobileAnalytics

var marks_list: [TestMarksModel] = []

class MarksProcessing: UIViewController  {
    
    class func set_marks_list(list: [TestMarksModel])   {
        marks_list = list
    }
    
    class func update_marks_list(id: String, marks: String, marks_type: String, whether_higher_class: Bool? = false)   {
        var marks = marks
        for i in 0 ..< marks_list.count    {
            if marks_list[i].id == id   {
                switch marks_type   {
                    case "main_marks":
                        if marks == ""  {
                            marks = "-5000.00"
                        }
                        marks_list[i].marks = marks
                        marks_list[i].grade = marks
                        break
                    case "pt_marks":
                        if marks == ""  {
                            marks = "-5000.0"
                        }
                        marks_list[i].pt_marks = marks
                        break
                    case "notebook_marks":
                        if marks == ""  {
                            marks = "-5000.0"
                        }
                        marks_list[i].notebook_sub_marks = marks
                        break
                    case "sub_enrich_marks":
                        if marks == ""  {
                            marks = "-5000.0"
                        }
                        marks_list[i].sub_enrich_marks = marks
                        break
                    case "prac_marks":
                        if marks == ""  {
                            marks = "-5000.0"
                        }
                        if whether_higher_class! {
                            marks_list[i].prac_marks = marks
                        }
                    break
                    default:
                        break
                }
                break
            }
        }
    }
    
    class func get_marks_list() -> [TestMarksModel]  {
        return marks_list
    }
    
    class func save_marks_list(whether_grade_based: Bool)    {
        var marks_dictionary = [String:[String:String]]()
        var marks_dictionary1 = [String:String]()
        
        for i in 0 ..< marks_list.count    {
            
            if !whether_grade_based {
                marks_dictionary[marks_list[i].id] = [
                    "marks": marks_list[i].marks,
                    "pa": marks_list[i].pt_marks,
                    "notebook": marks_list[i].notebook_sub_marks,
                    "subject_enrich": marks_list[i].sub_enrich_marks,
                    "prac_marks": marks_list[i].prac_marks
                ]
            }
            else    {
                marks_dictionary1[marks_list[i].id] = marks_list[i].grade
            }
        }
        
        let server_ip = MiscFunction.getServerIP()
        let url = "\(server_ip)/academics/save_marks/"
        
        if !whether_grade_based {
            Alamofire.request(url, method: .post, parameters: marks_dictionary, encoding: JSONEncoding.default).responseJSON { response in
            }
        }
        else    {
            Alamofire.request(url, method: .post, parameters: marks_dictionary1, encoding: JSONEncoding.default).responseJSON { response in
            }
        }
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Saved Marks")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
    }
    
    class func submit_marks_list(whether_grade_based: Bool) -> Bool   {
        var marks_dictionary = [String:[String:String]]()
        var marks_dictionary1 = [String:String]()
                
        var id_array: [String] = []
        for i in 0 ..< marks_list.count    {
            id_array.append(marks_list[i].id)
            if !whether_grade_based {
                marks_dictionary[marks_list[i].id] = [
                    "marks": marks_list[i].marks,
                    "pa": marks_list[i].pt_marks,
                    "notebook": marks_list[i].notebook_sub_marks,
                    "subject_enrich": marks_list[i].sub_enrich_marks,
                    "prac_marks": marks_list[i].prac_marks
                ]
            }
            else   {
                marks_dictionary1[marks_list[i].id] = marks_list[i].grade
            }
        }
        let server_ip = MiscFunction.getServerIP()
        let school_id = SessionManager.getSchoolId()
        let url = "\(server_ip)/academics/submit_marks/\(school_id)/"
        if !whether_grade_based {
            Alamofire.request(url, method: .post, parameters: marks_dictionary, encoding: JSONEncoding.default).responseJSON { response in
            }
        }
        else    {
            Alamofire.request(url, method: .post, parameters: marks_dictionary1, encoding: JSONEncoding.default).responseJSON { response in
            }
        }
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Submit Marks")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
        
        
        return true
    }
}


