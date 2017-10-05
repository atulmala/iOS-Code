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
    
    // 15/09/2017 provision for analytics
    class func setAnalytics(analytics: AWSMobileAnalytics)  {
        analtics = analytics
    }
    
    class func getAnalytics() -> AWSMobileAnalytics {
        return analtics!
    }
}
