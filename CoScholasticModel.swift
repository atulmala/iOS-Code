//
//  CoScholasticModel.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 13/10/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import Foundation

class CoScholasticModel: NSObject   {
    var id: String
    var term: String
    var full_name: String
    var parent: String
    var grade_work_ed: String
    var grade_art_ed: String
    var grade_health: String
    var grade_dscpln: String
    var remarks_class_teacher: String
    var promoted_to_class: String
    
    init(id: String, term: String, full_name: String, parent: String,
         grade_work_ed: String, grade_art_ed: String, grade_health: String, grade_dscpln: String,
         remarks_class_teacher: String, promoted_to_class: String)  {
        self.id = id
        self.term = term
        self.full_name = full_name
        self.parent = parent
        self.grade_work_ed = grade_work_ed
        self.grade_art_ed = grade_art_ed
        self.grade_health = grade_health
        self.grade_dscpln = grade_dscpln
        self.remarks_class_teacher = remarks_class_teacher
        self.promoted_to_class = promoted_to_class
        super.init()
    }
}
