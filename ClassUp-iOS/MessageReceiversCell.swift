//
//  MessageReceiversCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 09/12/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class MessageReceiversCell: UITableViewCell {
    @IBOutlet weak var student_name: UILabel!
    @IBOutlet weak var message: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
