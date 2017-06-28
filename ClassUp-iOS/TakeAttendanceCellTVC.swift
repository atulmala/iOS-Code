//
//  TakeAttendanceCellTVC.swift
//  Classup1
//
//  Created by Atul Gupta on 04/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import UIKit

class TakeAttendanceCellTVC: UITableViewCell {

    @IBOutlet weak var absentee_id: UILabel!
    @IBOutlet weak var img_absent: UIView!
    // following six outlets corresponds to hidden lables in the cell. They will be used for api calls
    @IBOutlet weak var the_class: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var parent: UILabel!
    
    @IBOutlet weak var attendance_cell: UITableViewCell!
    
    
    @IBOutlet weak var whether_present: UISwitch!
    
    @IBOutlet weak var full_name: UILabel!
    
    @IBOutlet weak var roll_number: UILabel!
    // id outlet is actually going to be hidden. It will be used to deal with attendance processing
    @IBOutlet weak var id:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //img_absent.transform = CGAffineTransform(rotationAngle: -0.0872665);
    }

    @IBAction func attendanceMarked(sender: UISwitch) {
        if !sender.isOn   {
            //attendance_cell.backgroundColor = UIColor.redColor()
            img_absent.isHidden = false
            //attendance_cell.backgroundColor = UIColor.orange
            AttendanceProcessing.add_to_absentee_list(id: absentee_id.text!)
            AttendanceProcessing.remove_from_correction_list(id: absentee_id.text!)
        }
        else    {
            img_absent.isHidden = true
            //attendance_cell.backgroundColor = UIColor.green
            AttendanceProcessing.remove_from_absentee_list(id: absentee_id.text!)
            AttendanceProcessing.add_to_correction_list(id: absentee_id.text!)
            // if this attendance is an update then this student is marked as absent in the db. We need
            // mark this student as present in db
            
            
            // we also need to remove this student from the absentee list
            if let i = absentee_list.index(of: (id.text!))    {
                absentee_list.remove(at: i)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
