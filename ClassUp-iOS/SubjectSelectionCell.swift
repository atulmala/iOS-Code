//
//  SubjectSelectionCell.swift
//  Classup1
//
//  Created by Atul Gupta on 06/10/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit

class SubjectSelectionCell: UITableViewCell {

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
