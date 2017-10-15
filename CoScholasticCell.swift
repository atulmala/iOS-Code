//
//  CoScholasticCell.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 13/10/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class CoScholasticCell: UITableViewCell {
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var full_name: UILabel!
    @IBOutlet weak var parent_name: UILabel!

    @IBOutlet weak var work_ed_grade: UISegmentedControl!
    @IBOutlet weak var art_ed_grade: UISegmentedControl!
    @IBOutlet weak var health_grade: UISegmentedControl!
    @IBOutlet weak var dscpln_grade: UISegmentedControl!
    @IBOutlet weak var ramarks: UITextField!
    @IBOutlet weak var promoted_to_class: UITextField!
    
    var delegate: CoScholasticTVC?
    
    @IBOutlet weak var promoted_lbl: UILabel!
    
    @IBAction func setGrade(_ sender: UISegmentedControl) {
        if let i = delegate?.grade_list.index(where: { $0.id == id.text })  {
            switch (sender) {
                case work_ed_grade:
                    switch sender.selectedSegmentIndex {
                        case 0:
                            delegate?.grade_list[i].grade_work_ed = "A"
                        case 1:
                            delegate?.grade_list[i].grade_work_ed = "B"
                        case 2:
                            delegate?.grade_list[i].grade_work_ed = "C"
                        default:
                            break;
                    }
                case art_ed_grade:
                    switch sender.selectedSegmentIndex {
                        case 0:
                            delegate?.grade_list[i].grade_art_ed = "A"
                        case 1:
                            delegate?.grade_list[i].grade_art_ed = "B"
                        case 2:
                            delegate?.grade_list[i].grade_art_ed = "C"
                        default:
                            break;
                    }
                case health_grade:
                    switch sender.selectedSegmentIndex {
                        case 0:
                            delegate?.grade_list[i].grade_health = "A"
                        case 1:
                            delegate?.grade_list[i].grade_health = "B"
                        case 2:
                            delegate?.grade_list[i].grade_health = "C"
                        default:
                            break;
                    }
                case dscpln_grade:
                    switch sender.selectedSegmentIndex {
                        case 0:
                            delegate?.grade_list[i].grade_dscpln = "A"
                        case 1:
                            delegate?.grade_list[i].grade_dscpln = "B"
                        case 2:
                            delegate?.grade_list[i].grade_dscpln = "C"
                        default:
                            break;
                    }
                default:
                    break
            }
        }
    }
    
    @IBAction func addRemarks(_ sender: UITextField) {
        if let i = delegate?.grade_list.index(where: { $0.id == id.text })  {
            delegate?.grade_list[i].remarks_class_teacher = ramarks.text!
        }
    }
    
    @IBAction func setPromoted(_ sender: UITextField) {
        if let i = delegate?.grade_list.index(where: { $0.id == id.text })  {
            delegate?.grade_list[i].promoted_to_class = promoted_to_class.text!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
