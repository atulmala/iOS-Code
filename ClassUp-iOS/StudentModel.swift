//
//  StudentModel.swift
//  Classup1
//
//  Created by Atul Gupta on 03/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import Foundation

class StudentModel:NSObject {
    var id: String
    var full_name: String
    var roll_no: String
    var whether_present: Bool
    // 18/06/2017 adding parent name
    var parent: String
    
    init(id: String, full_name: String, roll_no: String, whether_present: Bool, parent: String)  {
        self.id = id
        self.full_name = full_name
        self.roll_no = roll_no
        self.whether_present = whether_present
        self.parent = parent
        
        super.init()
    }
}
