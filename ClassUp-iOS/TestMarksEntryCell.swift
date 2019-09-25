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
    
    @IBOutlet weak var lbl_marks: UILabel!
    @IBOutlet weak var sub_enrich_marks: UITextField!
    @IBOutlet weak var notebook_sub_marks: UITextField!
    @IBOutlet weak var prac_marks: UITextField!
    @IBOutlet weak var pt_marks: UITextField!
    @IBOutlet weak var multi_asses_marks: UITextField!
    @IBOutlet weak var lbl_pt: UILabel!
    @IBOutlet weak var lbl_ma: UILabel!
    @IBOutlet weak var lbl_se: UILabel!
    @IBOutlet weak var lbl_nb: UILabel!
    
    var delegate: UIViewController?
    var max_marks: String = ""
    var whether_grade_based: Bool = false

       
    @IBAction func markAbsence(sender: UISwitch) {
        if sender.isOn    {
            marks.isUserInteractionEnabled = false
            marks.isEnabled = false
            marks.text = "ABS"
            let id = marks_entry_id.text
            let m = "-1000.00"
            MarksProcessing.update_marks_list(id: id!, marks: m, marks_type: "main_marks")
            
        }
        if !sender.isOn{
            marks.isEnabled = true
            marks.text = ""
            marks.isUserInteractionEnabled = true
            let id = marks_entry_id.text
            let m = "-5000.00"
            MarksProcessing.update_marks_list(id: id!, marks: m, marks_type: "main_marks")
        }
    }
    
    @IBAction func updateMarks(_ sender: UITextField) {
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
                if (NumberFormatter().number(from: m!)?.floatValue)! > (NumberFormatter().number(from: max_marks)?.floatValue)!    {
                    _ = NumberFormatter().number(from: m!)
                    marks.text = ""
                    let alertController = UIAlertController(title: "Warning", message: "Marks entered: \(m!) for Roll No: \(full_name.text!) are more than Max Marks: \(max_marks)", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    delegate?.present(alertController, animated: false)
                    return
                }
            }
        }
        MarksProcessing.update_marks_list(id: id!, marks: m!, marks_type: "main_marks" )
    }
    
    @IBAction func updatePAMarks(_ sender: UITextField) {
        let id = marks_entry_id.text
        var m = pt_marks.text
        if m == "." {
            m = "0"
        }
        
        if m != ""  {
            if (NumberFormatter().number(from: m!)?.floatValue)! > 10.0   {
                _ = NumberFormatter().number(from: m!)
                pt_marks.text = ""
                let alertController = UIAlertController(title: "Warning", message: "PA Marks entered: \(m!) for Roll No: \(full_name.text!) are more than Max Marks: 5", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                delegate?.present(alertController, animated: false)
                return
            }
        }
        MarksProcessing.update_marks_list(id: id!, marks: m!, marks_type: "pt_marks")
    }
    
    @IBAction func updateMultAssessMarks(_sender: UITextField)  {
        let id = marks_entry_id.text
        var m = multi_asses_marks.text
        if m == "." {
            m = "0"
        }
        
        if m != ""  {
            if (NumberFormatter().number(from: m!)?.floatValue)! > 10.0   {
                _ = NumberFormatter().number(from: m!)
                pt_marks.text = ""
                let alertController = UIAlertController(title: "Warning", message: "Multiple Assessment marks entered: \(m!) for Roll No: \(full_name.text!) are more than Max Marks: 5", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                delegate?.present(alertController, animated: false)
                return
            }
        }
        MarksProcessing.update_marks_list(id: id!, marks: m!, marks_type: "multi_asses_marks")
    }
    
    @IBAction func updatePracMarks(_ sender: UITextField) {
        let id = marks_entry_id.text
        var m = prac_marks.text
        
        if m == "." {
            m = "0"
        }
        MarksProcessing.update_marks_list(id: id!, marks: m!, marks_type: "prac_marks", whether_higher_class: true)
    }
    
    @IBAction func updateNoteBookMarks(_ sender: UITextField) {
        let id = marks_entry_id.text
        var m = notebook_sub_marks.text
        if m == "." {
            m = "0"
        }
        
        if m != ""  {
            if (NumberFormatter().number(from: m!)?.floatValue)! > 5.0   {
                _ = NumberFormatter().number(from: m!)
                notebook_sub_marks.text = ""
                let alertController = UIAlertController(title: "Warning", message: "Notebook Submission Marks entered: \(m!) for Roll No: \(full_name.text!) are more than Max Marks: 5", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                delegate?.present(alertController, animated: false)
                return
            }
        }
        MarksProcessing.update_marks_list(id: id!, marks: m!, marks_type: "notebook_marks")
    }
    
    @IBAction func updateSubEnrichMarks(_ sender: UITextField) {
        let id = marks_entry_id.text
        var m = sub_enrich_marks.text
        if m == "." {
            m = "0"
        }
        
        if m != ""  {
            if (NumberFormatter().number(from: m!)?.floatValue)! > 5.0   {
                _ = NumberFormatter().number(from: m!)
                sub_enrich_marks.text = ""
                let alertController = UIAlertController(title: "Warning", message: "Subject Enrichment Marks entered: \(m!) for Roll No: \(full_name.text!) are more than Max Marks: 5", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                delegate?.present(alertController, animated: false)
                return
            }
        }
        MarksProcessing.update_marks_list(id: id!, marks: m!, marks_type: "sub_enrich_marks")
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
