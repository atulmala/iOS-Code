//
//  StudentSelectionCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 08/01/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class StudentSelectionCell: UITableViewCell {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var full_name: UILabel!
    @IBOutlet weak var roll_no: UILabel!
    @IBOutlet weak var parent_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
