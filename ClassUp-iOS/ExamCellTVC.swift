//
//  ExamCellTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ExamCellTVC: UITableViewCell {

    @IBOutlet weak var exam_title: UILabel!
    @IBOutlet weak var exam_id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
