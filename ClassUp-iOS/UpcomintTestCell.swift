//
//  UpcomintTestCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 20/06/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class UpcomintTestCell: UITableViewCell {
    @IBOutlet weak var test_date: UILabel!
    @IBOutlet weak var test_topics: UILabel!
    @IBOutlet weak var test: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
