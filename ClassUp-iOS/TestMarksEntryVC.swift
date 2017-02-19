//
//  TestMarksEntryVC.swift
//  Classup1
//
//  Created by Atul Gupta on 26/09/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Just
import SwiftyJSON

class TestMarksEntryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_save: UIButton!
    
    @IBOutlet weak var toMainMenu: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var test_id: String = ""
    var whether_grade_based: Bool = false
    
    var test_marks_list: [TestMarksModel] = []
    var marks_id_list: [String] = []
    var test_id_list: [String] = []
    var student_name_list:[String] = []
    var roll_no_list: [String] = []
    var marks_list: [String] = []
    var grade_list: [String] = []
    
    var test_type: [String] = []
    var max_marks: [String] = []
    var pass_marks: [String] = []
    
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    
    var pm: String = ""
    var mm: String = ""
    
    @IBAction func marksEntered(sender: UITextField) {
    }
    
    
    @IBAction func saveMarks(sender: UIButton) {
        MarksProcessing.save_marks_list(whether_grade_based: whether_grade_based)
        showAlert(title: "Done", message: "Marks/Grades Saved")
    }
    
    @IBAction func submitMarks(sender: UIButton)  {
        // first, check if marks/grade for any student have been left to be filled
        for i in 0 ..< test_marks_list.count    {
            if !whether_grade_based {
                if test_marks_list[i].marks == "-5000.00" || test_marks_list[i].marks == "-5000"
                {
                    let student = test_marks_list[i].student
                    let roll_no = test_marks_list[i].roll_no
                    
                    let message = "Please enter marks for Roll No: \(roll_no) \(student) or mark as Absent"
                    let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    present(alertController, animated: true, completion: nil)
                    
                    return
                }
            }
            else    {
                if test_marks_list[i].grade == "-5000.00" || test_marks_list[i].grade == "-5000"
                    || test_marks_list[i].grade == "" {
                    let student = test_marks_list[i].student
                    let roll_no = test_marks_list[i].roll_no
                    
                    let message = "Please enter grades for Roll No: \(roll_no) \(student) or mark as Absent"
                    let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    present(alertController, animated: true, completion: nil)
                    return
                }
            }
        }

        if MarksProcessing.submit_marks_list(whether_grade_based: whether_grade_based) == true   {
            performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // when the keyboard appears, the cells in the bottom gets hidden. We need to move the cells up
        // when the keyboard appears. So we register for keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(TestMarksEntryVC.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TestMarksEntryVC.keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let server_ip: String = MiscFunction.getServerIP()
        var url: String = "\(server_ip)/academics/get_test_marks_list/\(test_id)/"
        var j = JSON(Just.get(url).json!)
        var count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    var roll_no: String = ""
                    if let _ = j[index]["roll_no"].int {
                        let the_roll_no = j[index]["roll_no"]
                        roll_no = String(stringInterpolationSegment: the_roll_no)
                    }
                    let full_name: String = j[index]["student"].string!
                    let grade: String = j[index]["grade"].string!
                    var marks_obtained: String = j[index]["marks_obtained"].string!
                    if let _ = j[index]["marks_obtained"].int{
                        let mo = j[index]["marks_obtained"]
                        marks_obtained = String(stringInterpolationSegment: mo)
                    }
                    
                    test_marks_list.append(TestMarksModel(id: id, r: roll_no, m: marks_obtained, g: grade,s:full_name) )
                }
            }
        }
        
        MarksProcessing.set_marks_list(list: test_marks_list)
        
        // get the test type - whether it is grade based or marks based test
        url = "\(server_ip)/academics/get_test_type/\(test_id)/"
        j = JSON(Just.get(url).json!)
        count = j.count
        if (count! > 0)  {
            
            mm = j[0]["max_marks"].stringValue
            pm = j[0]["passing_marks"].stringValue
            if j[0]["grade_based"].stringValue == "true"   {
                whether_grade_based = true
            }
            else    {
                whether_grade_based = false
            }
        }
        
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.white
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        
        if whether_grade_based  {
            lable.text = "Grades Entry     \(the_class)-\(section)        \(subject)"
        }
        else    {
            lable.text = "Marks Entry     \(the_class)-\(section)        \(subject)"
        }
        self.navigationItem.titleView = lable
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(note: NSNotification) {
        let info: NSDictionary = note.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(note: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test_marks_list.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header_cell = tableView.dequeueReusableCell(withIdentifier: "header_cell") as! TestMarksEntryHeaderCell
        header_cell.backgroundColor = UIColor.cyan
        
        header_cell.roll_no.text = "Roll No"
        header_cell.full_name.text = "Name"
        if whether_grade_based  {
            header_cell.marks.text = "Grade"
            btn_save.setTitle("Save Grades", for: .normal)
            btn_submit.setTitle("Submit Grades", for: .normal)
        }
        else    {
            header_cell.marks.text = "Marks"
        }
        
        header_cell.absent.text = "Abs?"
        
        return header_cell
    }
    
    func dismissKeyboard()  {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marks_entry_cell", for: indexPath as IndexPath) as! TestMarksEntryCell
        
        cell.selectionStyle = .none
        
        cell.marks_entry_id.isHidden = true
        cell.marks_entry_id.text = test_marks_list[indexPath.row].id
        cell.roll_no.text = test_marks_list[indexPath.row].roll_no
        cell.full_name.numberOfLines = 0
        cell.full_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.full_name.text = test_marks_list[indexPath.row].student
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TestMarksEntryVC.dismissKeyboard))
        

        cell.addGestureRecognizer(tap)
        
        var m: String = ""
        if !whether_grade_based {
            m = MarksProcessing.get_marks_list()[indexPath.row].marks
            cell.marks.keyboardType = UIKeyboardType.decimalPad
            cell.whether_grade_based = false
            cell.max_marks = mm
            
        }
        else    {
            m = MarksProcessing.get_marks_list()[indexPath.row].grade
            cell.whether_grade_based = true
        }
        
        switch(m)   {
        case "-5000.00":
            m = ""
            cell.whether_absent.setOn(false, animated: false)
            cell.backgroundColor = UIColor.white
            break
        case "-1000.00":
            m = "ABS"
            cell.whether_absent.setOn(true, animated: false)
            cell.marks.isUserInteractionEnabled = false
            break
        case "-5000":
            m = ""
            cell.whether_absent.setOn(false, animated: false)
            cell.backgroundColor = UIColor.white
            break
        case "-1000":
            m = "ABS"
            cell.whether_absent.setOn(true, animated: false)
            cell.marks.isUserInteractionEnabled = false
            break
        default:
            cell.whether_absent.setOn(false, animated: false)
        }
        
        if !whether_grade_based {
            if ((m != "") && (m != "ABS"))  {
                if (NumberFormatter().number(from: m)?.intValue)! < (NumberFormatter().number(from: pm)?.intValue)!   {
                    cell.marks.backgroundColor = UIColor.yellow
                }
                else {
                    cell.marks.backgroundColor = UIColor.white
                }
            }
            else {
                cell.marks.backgroundColor = UIColor.white
            }
        }
        cell.marks.text = m
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        
        
        self.navigationItem.title = "Test Marks Entry"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "TestMarksEntryVC"
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
