//
//  ActivityGroupCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 27/11/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ActivityGroupCell: UITableViewCell {
    @IBOutlet weak var group_id: UILabel!
    @IBOutlet weak var group_name: UILabel!
    @IBOutlet weak var group_incharge: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
