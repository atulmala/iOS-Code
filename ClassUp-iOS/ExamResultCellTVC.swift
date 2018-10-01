//
//  ExamResultCellTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ExamResultCellTVC: UITableViewCell {

    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var max_marks: UILabel!
    @IBOutlet weak var marks_obtained: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
