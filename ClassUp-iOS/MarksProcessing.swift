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
    
    class func update_marks_list(id: String, marks: String)   {
        var marks = marks
        for i in 0 ..< marks_list.count    {
            if marks_list[i].id == id   {
                if marks == ""  {
                    marks = "-5000.00"
                }
                marks_list[i].marks = marks
                marks_list[i].grade = marks
                break
            }
        }
    }
    
    class func get_marks_list() -> [TestMarksModel]  {
        return marks_list
    }
    
    class func save_marks_list(whether_grade_based: Bool)    {
        var marks_dictionary = [String:String]()
        
        var id_array: [String] = []
        
        for i in 0 ..< marks_list.count    {
            id_array.append(marks_list[i].id)
            
            if !whether_grade_based {
                marks_dictionary[marks_list[i].id] = marks_list[i].marks
            }
            else    {
                marks_dictionary[marks_list[i].id] = marks_list[i].grade
            }
        }
        
        let server_ip = MiscFunction.getServerIP()
        let url = "\(server_ip)/academics/save_marks/"
        
        
        Alamofire.request(url, method: .post, parameters: marks_dictionary, encoding: JSONEncoding.default).responseJSON { response in
        }
        
        let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
        let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
        let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Saved Marks")
        eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
        eventClient.record(event)
        eventClient.submitEvents()
    }
    
    class func submit_marks_list(whether_grade_based: Bool) -> Bool   {
        var marks_dictionary = [String:String]()
                
        var id_array: [String] = []
        for i in 0 ..< marks_list.count    {
            id_array.append(marks_list[i].id)
            if !whether_grade_based {
                marks_dictionary[marks_list[i].id] = marks_list[i].marks
            }
            else   {
                marks_dictionary[marks_list[i].id] = marks_list[i].grade
            }
        }
        let server_ip = MiscFunction.getServerIP()
        let school_id = SessionManager.getSchoolId()
        let url = "\(server_ip)/academics/submit_marks/\(school_id)/"
        Alamofire.request(url, method: .post, parameters: marks_dictionary, encoding: JSONEncoding.default).responseJSON { response in
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


