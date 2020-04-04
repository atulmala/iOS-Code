//
//  OnlineClassCell.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 03/04/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class OnlineClassCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var the_class: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var topic: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var pdf_link: UITextView!
    @IBOutlet weak var youtube_link: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
