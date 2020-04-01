//
//  MessageHistoryCellTableViewCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 04/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class MessageHistoryCellTableViewCell: UITableViewCell {
    @IBOutlet weak var message_date: UILabel!
//    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var message: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
