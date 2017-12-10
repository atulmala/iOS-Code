//
//  ArrangementCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 23/11/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ArrangementCell: UITableViewCell {
    @IBOutlet weak var period: UILabel!

    @IBOutlet weak var class_sec: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
