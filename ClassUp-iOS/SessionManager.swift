//
//  SessionManager.swift
//  Classup1
//
//  Created by Atul Gupta on 15/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import Foundation
import AWSMobileAnalytics

var logged_in_user: String = ""
var school_id: NSString = ""
var exam_id: String = ""
var exam_type: String = ""
var exam_title: String = ""
var exam_start_date: String = ""
var exam_end_date: String = ""

var analtics: AWSMobileAnalytics? = nil
class SessionManager    {
    
    class func setLoggedInUser(user: String)    {
        logged_in_user = user
    }
    
    class func getLoggedInUser() -> String   {
        return logged_in_user
    }
    
    class func logout() {
        logged_in_user = ""
    }
    
    class func whetherLoggedIn() -> Bool    {
        if logged_in_user != "" {
            return true
        }
        else    {
            return false
        }
    }
    
    class func setSchoolId(id: String)  {
        school_id = id as NSString
    }
    
    class func getSchoolId() -> String  {
        return school_id as String
    }
    
    class func set_exam_id(id: String)  {
        exam_id = id
    }
    
    class func get_exam_id() -> String   {
        return exam_id as String
    }
    
    class func set_exam_type(ex_type: String) {
        exam_type = ex_type
    }
    
    class func get_exam_type() -> String    {
        return exam_type
    }
    
    class func set_exam_title(title: String)    {
        exam_title = title
    }
    
    class func get_exam_title() -> String   {
        return exam_title
    }
    
    // 15/09/2017 provision for analytics
    class func setAnalytics(analytics: AWSMobileAnalytics)  {
        analtics = analytics
    }
    
    class func getAnalytics() -> AWSMobileAnalytics {
        return analtics!
    }
    
    // 03/02/2019 provision for restricing the dates to start and end dates of exam while scheduling tests
    class func set_start_date(start_date: String) {
        exam_start_date = start_date
    }
    class func get_start_date() -> String {
        return exam_start_date
    }
    
    class func set_end_date(end_date: String)   {
        exam_end_date = end_date
    }
    class func get_end_date() -> String {
        return exam_end_date
    }
}
