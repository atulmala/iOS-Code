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
    var pt_marks: String
    var multi_asses_marks: String
    var notebook_sub_marks: String
    var sub_enrich_marks: String
    var prac_marks: String
    
    init(id: String, r: String, m: String, g: String, s: String,
         pn: String, pt: String, ma: String, nb: String, sub: String, prac: String) {
        self.id  = id
        self.marks = m
        self.grade = g
        self.student = s
        self.roll_no = r
        self.parent_name = pn
        self.pt_marks = pt
        self.multi_asses_marks = ma
        self.notebook_sub_marks = nb
        self.sub_enrich_marks = sub
        self.prac_marks = prac
        super.init()
    }
}
