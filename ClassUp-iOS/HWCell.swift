//
//  HWCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 01/05/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class HWCell: UITableViewCell {

    @IBOutlet weak var due_date: UILabel!
    @IBOutlet weak var the_class: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var id: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
