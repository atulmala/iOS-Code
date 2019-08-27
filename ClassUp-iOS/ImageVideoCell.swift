//
//  ImageVideoCell.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 17/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ImageVideoCell: UITableViewCell {
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var the_class: UILabel!
    @IBOutlet weak var short_link: UITextView!
    @IBOutlet weak var short_description: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
