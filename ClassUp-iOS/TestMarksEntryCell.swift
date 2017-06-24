//
//  TestMarksEntryCell.swift
//  Classup1
//
//  Created by Atul Gupta on 28/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit

class TestMarksEntryCell: UITableViewCell {
    @IBOutlet weak var parent_name: UILabel!
    @IBOutlet weak var marks_entry_id: UILabel!
    @IBOutlet weak var roll_no: UILabel!
    @IBOutlet weak var marks: UITextField!
    @IBOutlet weak var whether_absent: UISwitch!
    @IBOutlet weak var full_name: UILabel!
    
    var max_marks: String = ""
    var whether_grade_based: Bool = false
    
       
    @IBAction func markAbsence(sender: UISwitch) {
        if sender.isOn    {
            marks.isUserInteractionEnabled = false
            marks.isEnabled = false
            marks.text = "ABS"
            let id = marks_entry_id.text
            let m = "-1000.00"
            MarksProcessing.update_marks_list(id: id!, marks: m)
            
        }
        if !sender.isOn{
            marks.isEnabled = true
            marks.text = ""
            marks.isUserInteractionEnabled = true
            let id = marks_entry_id.text
            let m = "-5000.00"
            MarksProcessing.update_marks_list(id: id!, marks: m)
        }
    }
    
    @IBAction func updateMarks(sender: UITextField) {
        let id = marks_entry_id.text
        var m = marks.text
        if m == "." {
            m = "0"
        }
        
        if !whether_grade_based {
            // upon seeing the message the user would press back button and this will cause the 
            // text field to become blank. Since this function is triggered after every keystroke
            // excepion may occur. Hence check for blank value
            if m != ""  {
                if (NumberFormatter().number(from: m!)?.intValue)! > (NumberFormatter().number(from: max_marks)?.intValue)!    {
                    _ = NumberFormatter().number(from: m!)
                    marks.text = ""
                    let alertController = UIAlertController(title: "Warning", message: "Marks entered: \(m!) for \(full_name.text!) are more than Max Marks: \(max_marks)", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    return
                }
            }
        }
        MarksProcessing.update_marks_list(id: id!, marks: m!)
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
