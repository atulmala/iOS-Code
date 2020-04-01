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
    
    var unit_or_term = ""
    var whether_higher_class = ""
    var subject_prac: Bool = false
    
    let prac_subjects: [String] = ["Biology", "Physics", "Chemistry",
                                   "Accountancy", "Business Studies", "Economics", "Fine Arts",
                                   "Information Practices", "Informatics Practices", "Computer Science", "Painting",
                                   "Physical Education"]
    let absent_values: [String] = ["-1000", "-1000.0", "-1000.00"]
    let null_values: [String] = ["-5000", "-5000.0", "-5000.00"]
    
    
    func saveMarks(sender: UIButton) {
        MarksProcessing.save_marks_list(whether_grade_based: whether_grade_based)
        showAlert(title: "Done", message: "Marks/Grades Saved")
    }
    
    func submitMarks(sender: UIButton)  {
        // first, check if marks/grade for any student have been left to be filled
            for i in 0 ..< test_marks_list.count    {
                let student = test_marks_list[i].student
                if !whether_grade_based {
                    if test_marks_list[i].marks == "-5000.00" || test_marks_list[i].marks == "-5000"    {
                        let message = "Please enter marks for Roll No: \(student) or mark as Absent"
                        let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                    
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        present(alertController, animated: true, completion: nil)
                        return
                    }
                
                    if unit_or_term == "term"   {
                        if whether_higher_class != "true"   {
                            if test_marks_list[i].pt_marks == "-5000.0" || test_marks_list[i].pt_marks == "-5000" {
                                let message = "Please enter PA marks for Roll No: \(student) or mark as Absent"
                                let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                present(alertController, animated: true, completion: nil)
                                return
                            }
                            if test_marks_list[i].multi_asses_marks == "-5000.0" || test_marks_list[i].multi_asses_marks == "-5000" {
                                let message = "Please enter Multi Assess marks for Roll No: \(student) or mark as Absent"
                                let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                present(alertController, animated: true, completion: nil)
                                return
                            }
                            if test_marks_list[i].notebook_sub_marks == "-5000.0" || test_marks_list[i].notebook_sub_marks == "-5000" {
                                let message = "Please enter Notebook Submission marks for Roll No: \(student) or mark as Absent"
                                let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                present(alertController, animated: true, completion: nil)
                                return
                            }
                            if test_marks_list[i].sub_enrich_marks == "-5000.0" || test_marks_list[i].sub_enrich_marks == "-5000" {
                                let message = "Please enter Subject Enrishment marks for Roll No: \(student) or mark as Absent"
                                let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                present(alertController, animated: true, completion: nil)
                                return
                            }
                        }
                        else    {
                            //if prac_subjects.contains(subject)  {
                            if subject_prac {
                            if !absent_values.contains(test_marks_list[i].marks)    {
                                    if null_values.contains(test_marks_list[i].prac_marks)  {
                                        let message = "Please enter Practical marks for Roll No: \(student) or mark as Absent"
                                        let alertController = UIAlertController(title: "Marks/Grade Submission Error", message: message, preferredStyle: .alert)
                                        
                                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        alertController.addAction(defaultAction)
                                        present(alertController, animated: true, completion: nil)
                                        return
                                    }
                                }
                            }
                        }
                    }
            }
            else    {
                if test_marks_list[i].grade == "-5000.00" || test_marks_list[i].grade == "-5000"
                    || test_marks_list[i].grade == "" {
                    let student = test_marks_list[i].student
                    
                    let message = "Please enter grades for Roll No: \(student) or mark as Absent"
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
        tableView.separatorColor = UIColor.blue
        
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
                    // 04/10/2017 - we do not display the roll no separately. Instead show the 
                    // serial number in front of the name and this can be considered as roll no
                    let prefix: String = String(index + 1)
                    var space: String
                    if prefix.characters.count == 1 {
                        space = ".    "
                    }
                    else{
                        space = ".  "
                    }
                    
                    let the_name: String = j[index]["student"].string!
                    let full_name = "\(prefix)\(space)\(the_name)"
                    let grade: String = j[index]["grade"].string!
                    var marks_obtained: String = j[index]["marks_obtained"].string!
                    if let _ = j[index]["marks_obtained"].int{
                        let mo = j[index]["marks_obtained"]
                        marks_obtained = String(stringInterpolationSegment: mo)
                    }
                    
                    // 04/10/2017 the request would also bring the PA marks, Notebook submission and sub 
                    // enrichment marks
                    let pt_marks: String = String(stringInterpolationSegment: j[index]["periodic_test_marks"])
                    let multi_asses_marks: String = String(stringInterpolationSegment: j[index]["multi_asses_marks"])
                    let notebook_sub_marks: String = String(stringInterpolationSegment:j[index]["notebook_marks"])
                    let sub_enrich_marks: String = String(stringInterpolationSegment: j[index]["sub_enrich_marks"])
                    
                    // 26/12/2017 practical marks for higher classes only if the class is a higer class
                    var prac_marks: String = "0.0"
                    if whether_higher_class == "true"   {
                        prac_marks = String(stringInterpolationSegment: j[index]["prac_marks"])
                    }
                    
                    let parent_name: String = j[index]["parent"].string!
                    
                    test_marks_list.append(TestMarksModel(id: id, r: roll_no, m: marks_obtained, g: grade,s:full_name, pn:parent_name, pt: pt_marks, ma: multi_asses_marks, nb: notebook_sub_marks, sub: sub_enrich_marks, prac: prac_marks))
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
        lable.textColor = UIColor.purple
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        
        let exam_title: String = SessionManager.get_exam_title()
        
        if whether_grade_based  {
            lable.text = "\(the_class)-\(section) \(subject) \(exam_title)"
        }
        else    {
            lable.text = "\(the_class)-\(section) \(subject) \(exam_title)"
        }
        self.navigationItem.titleView = lable
        
        // 24/06/2017 - moving Save and Submit button to navigation bar
        let save_button = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(TestMarksEntryVC.saveMarks(sender:)))
        
        let submit_button = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(TestMarksEntryVC.submitMarks(sender:)))
        navigationItem.rightBarButtonItems = [submit_button, save_button]
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(note: NSNotification) {
        let info: NSDictionary = note.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 100.0, 0.0)
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
    
    func dismissKeyboard()  {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marks_entry_cell", for: indexPath as IndexPath) as! TestMarksEntryCell
        cell.delegate = self
        
        cell.selectionStyle = .none
        
        cell.marks_entry_id.isHidden = true
        cell.marks_entry_id.text = test_marks_list[indexPath.row].id
        cell.full_name.numberOfLines = 0
        cell.full_name.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.full_name.text = test_marks_list[indexPath.row].student
        cell.parent_name.text = test_marks_list[indexPath.row].parent_name
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
        
        if unit_or_term != "term"   {
            cell.lbl_nb.isHidden = true
            cell.lbl_pt.isHidden = true
            cell.lbl_ma.isHidden = true
            cell.lbl_se.isHidden = true
            cell.pt_marks.isHidden = true
            cell.multi_asses_marks.isHidden = true
            cell.notebook_sub_marks.isHidden = true
            cell.sub_enrich_marks.isHidden = true
            cell.prac_marks.isHidden = true
        }
        else {
            if whether_higher_class == "true"   {
                cell.lbl_nb.isHidden = true
                cell.lbl_pt.isHidden = false
                cell.lbl_marks.text = "Theory"
                cell.lbl_pt.text = "Practical"
                cell.lbl_ma.isHidden = true
                cell.lbl_se.isHidden = true
                cell.pt_marks.isHidden = true
                cell.multi_asses_marks.isHidden = true
                cell.pt_marks.isEnabled = false
                cell.notebook_sub_marks.isHidden = true
                cell.sub_enrich_marks.isHidden = true
                
                if (test_marks_list[indexPath.row].prac_marks == "-5000.0" || test_marks_list[indexPath.row].prac_marks == "-5000")  {
                    cell.prac_marks.text = ""
                }
                else    {
                    cell.prac_marks.text = test_marks_list[indexPath.row].prac_marks
                }
                
                //if !prac_subjects.contains(subject) {
                if !subject_prac    {
                    cell.prac_marks.isEnabled = false
                    cell.prac_marks.text = "N/A"
                }
            }
            else    {
                cell.prac_marks?.removeFromSuperview()
            }
        }
        
        if (test_marks_list[indexPath.row].pt_marks == "-5000.0" || test_marks_list[indexPath.row].pt_marks == "-5000") {
            cell.pt_marks.text = ""
        }
        else{
            cell.pt_marks.text = test_marks_list[indexPath.row].pt_marks
        }
        
        if (test_marks_list[indexPath.row].multi_asses_marks == "-5000.0" || test_marks_list[indexPath.row].multi_asses_marks == "-5000")   {
            cell.multi_asses_marks.text = ""
        }
        else    {
            cell.multi_asses_marks.text = test_marks_list[indexPath.row].multi_asses_marks
        }
        
        if (test_marks_list[indexPath.row].notebook_sub_marks == "-5000.0" || test_marks_list[indexPath.row].notebook_sub_marks == "-5000")   {
            cell.notebook_sub_marks.text = ""
        }
        else{
            cell.notebook_sub_marks.text = test_marks_list[indexPath.row].notebook_sub_marks
        }
        
        if (test_marks_list[indexPath.row].sub_enrich_marks == "-5000.0" || test_marks_list[indexPath.row].sub_enrich_marks == "-5000") {
            cell.sub_enrich_marks.text = ""
        }
        else{
            cell.sub_enrich_marks.text = test_marks_list[indexPath.row].sub_enrich_marks
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if unit_or_term != "term"   {
            return 110
        }
        else{
            if whether_higher_class == "true"   {
                return 160
            }
            else    {
                return 200
            }
        }
    }
    
   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if unit_or_term != "term"   {
            return 91
        }
        else{
            if whether_higher_class == "true"   {
                return 120
            }
            else    {
                return 216
            }
        }
   }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        _ = self.navigationController?.navigationBar
        //nav?.barStyle = UIBarStyle.black
        
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
