//
//  MiscFunctions.swift
//  Classup1
//
//  Created by Atul Gupta on 29/08/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Just


var server_ip: String = ""

class MiscFunction  {
    
    class func sendRequestToServer(url: String, key: String,  list: inout [String], sender: String)  {
        
        print("url=\(url)")
        let j = JSON(Just.get(url).json!)
        
        let count: Int? = j.count
        
        switch sender   {
            case "LoginVC":
                list.append(j["user_status"].stringValue)
                list.append(j["login"].stringValue)
                list.append(j["is_staff"].stringValue)
            case "AttendanceSummaryGetWorkingDays":
                list.append(j["working_days"].stringValue)
            
            default:
                if (count! > 0)  {
                    if let ct = count {
                        for index in 0...ct-1 {
                            //let _name = j[index][key]
                            if let name = j[index][key].string {
                                list.append(name)
                            }
                            // this is to deal with id field in db which is stored as integer
                            if let _ = j[index][key].int {
                                let name = j[index][key]
                                let name1 = String(stringInterpolationSegment: name)
                                list.append(name1)
                            }
                        }
                    }
                }
        }
    }
    
    class func decomposeDate(date_picker: UIDatePicker, day: inout String, month: inout String, year: inout String) {
        let date = date_picker.date
        let calendar = NSCalendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        day = String(describing: components.day)
        month = String(describing: components.month)
        year = String(describing: components.year)
    }
    
    class func getCurrentYear() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        let year = String(describing: components.year)
    
        return year
    }
    
    class func getLastYear() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let unitFlags = Set<Calendar.Component>([.day, .month, .year])
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        let last_year = String(describing: components.year!-1)

        
        return last_year
    }

    class func getInitialServerIP(usr:String) -> String  {
        //server_ip = "http://127.0.0.1:8000"
        server_ip = "https://www.classupclient.com"
        
        return server_ip;
    }
    
    class func getServerIP() -> String  {
        return server_ip
    }
    
    class func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    
}
