//
//  ExamCell.swift
//  Alamofire
//
//  Created by Atul Gupta on 23/05/18.
//

import UIKit

class ExamCell: UITableViewCell {

    @IBOutlet weak var exam_id: UILabel!
    @IBOutlet weak var exam: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
