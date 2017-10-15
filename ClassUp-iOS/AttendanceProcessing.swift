//
//  AttendanceProcessing.swift
//  Classup1
//
//  Created by Atul Gupta on 12/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import Foundation

var absentee_list: [String] = []
var correction_list: [String] = []

class AttendanceProcessing  {
    
    class func add_to_absentee_list(id: String) {
        absentee_list.append(id)
        //print("added=\(id). Now absentee list=\(absentee_list)")
        
    }
    class func remove_from_absentee_list(id: String)    {
        if let index = absentee_list.index(of: id)  {
            absentee_list.remove(at: index)
        }
        
    }
    class func get_absentee_list() -> [String] {
        return absentee_list
        
    }
    class func set_absentee_list(list: [String])  {
        absentee_list = list
        //print(absentee_list)
    }
    class func add_to_correction_list(id: String)   {
        correction_list.append(id)
    }
    class func remove_from_correction_list(id: String)  {
        if let index = correction_list.index(of: id)  {
            correction_list.remove(at: index)
        }
    }
    class func get_correction_list() -> [String]
    {
        return correction_list
    }
}
