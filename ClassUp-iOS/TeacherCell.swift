//
//  TeacherCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 01/03/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class TeacherCell: UITableViewCell {

    @IBOutlet weak var teacher_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
