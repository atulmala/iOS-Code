//
//  StuNameCell.swift
//  Pods
//
//  Created by Atul Gupta on 24/02/17.
//
//

import UIKit

class StuNameCell: UITableViewCell {

    @IBOutlet weak var student_id: UILabel!
    @IBOutlet weak var student_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
