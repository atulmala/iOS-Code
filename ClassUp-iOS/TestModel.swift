//
//  TestModel.swift
//  Classup1
//
//  Created by Atul Gupta on 24/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import Foundation

class TestModel: NSObject{
    var id: String
    var date: String
    var the_class: String
    var section: String
    var subject: String
    var max_marks: String
    var grade_based: String
    var test_type: String
    
    init(id: String, date: String, the_class: String, section: String, subject: String, mm: String,  grade_based: String, test_type: String) {
        self.id = id
        self.date = date
        self.the_class = the_class
        self.section = section
        self.subject = subject
        self.max_marks = mm
        self.grade_based = grade_based
        self.test_type = test_type
        
        super.init()
    }
}
