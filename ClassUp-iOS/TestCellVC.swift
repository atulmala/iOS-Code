//
//  TestCellVC.swift
//  Classup1
//
//  Created by Atul Gupta on 24/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit

class TestCellVC: UITableViewCell {

    @IBOutlet weak var test_id: UILabel!
    @IBOutlet weak var test_date: UILabel!
    @IBOutlet weak var the_class: UILabel!
    @IBOutlet weak var section: UILabel!
    
    @IBOutlet weak var max_marks: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var test_type: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
