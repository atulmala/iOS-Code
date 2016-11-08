//
//  TestMarksEntryHeaderCell.swift
//  Classup1
//
//  Created by Atul Gupta on 28/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit

class TestMarksEntryHeaderCell: UITableViewCell {

    @IBOutlet weak var roll_no: UILabel!
    @IBOutlet weak var full_name: UILabel!
    @IBOutlet weak var absent: UILabel!
    @IBOutlet weak var marks: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
