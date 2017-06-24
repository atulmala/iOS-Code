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
    var marks: String
    var grade: String
    var student: String
    var roll_no: String
    var parent_name: String
    
    init(id: String, r: String, m: String, g: String, s: String, pn: String) {
        self.id  = id
        self.marks = m
        self.grade = g
        self.student = s
        self.roll_no = r
        self.parent_name = pn
        super.init()
    }
}
