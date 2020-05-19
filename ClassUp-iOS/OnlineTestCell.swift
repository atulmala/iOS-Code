//
//  OnlineTestCell.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 18/05/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class OnlineTestCell: UITableViewCell {
    @IBOutlet weak var test_date: UILabel!
    @IBOutlet weak var subject_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
