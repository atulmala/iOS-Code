//
//  SubjectSelection.swift
//  Classup1
//
//  Created by Atul Gupta on 06/10/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import Foundation

class SubjectModel: NSObject    {
    var id: NSString
    var subject: NSString
    
    init(id: String, subject: String)   {
        self.id = id as NSString
        self.subject = subject as NSString
        
        super.init()
    }
}
