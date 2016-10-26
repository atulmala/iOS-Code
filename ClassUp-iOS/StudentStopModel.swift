//
//  StudentStopModel.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 20/06/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import Foundation


class StudentStopModel:NSObject {
    var id: String
    var full_name: String
    var bus_stop: String
    var roll_no: String
    var whether_present: Bool
    
    init(id: String, full_name: String, bus_stop: String, roll_no: String, whether_present: Bool)  {
        self.id = id
        self.full_name = full_name
        self.bus_stop = bus_stop
        self.roll_no = roll_no
        self.whether_present = whether_present
        
        super.init()
    }
}
