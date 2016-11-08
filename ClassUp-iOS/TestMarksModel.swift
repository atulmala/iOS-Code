//
//  TestMarksModel.swift
//  Classup1
//
//  Created by Atul Gupta on 27/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import Foundation

class TestMarksModel: NSObject  {
    var id: String
//    var test_id: String
//    var student_id: String
    var marks: String
    var grade: String
    var student: String
    var roll_no: String
    
//    init(id: String, t_id: String, s_id: String, m: String, g: String) {
    init(id: String, r: String, m: String, g: String, s: String) {
        self.id  = id
        
//        self.test_id = t_id
//        self.student_id = s_id
        self.marks = m
        self.grade = g
        self.student = s
        self.roll_no = r
        super.init()
    }
}
