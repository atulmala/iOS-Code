//
//  StuAttSummaryCellTVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 26/03/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class StuAttSummaryCellTVC: UITableViewCell {

    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var tot_days: UILabel!
    @IBOutlet weak var present_days: UILabel!
    @IBOutlet weak var percentage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
