//
//  SelectDateClassSectionSubjectVC.swift
//  Classup1
//
//  Created by Atul Gupta on 25/08/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Foundation
import AWSMobileAnalytics
import Just


class SelectDateClassSectionSubjectVC: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    // the following variable stores which menu option was clicked in the previous screen
    var trigger: String = ""
    
    // the button which is at the bottom of the screen. Its caption will depend upon the sender variable
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Pickers to select date, class, section, and subject
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var classPicker: UIPickerView!
    @IBOutlet weak var date_label: UILabel!
    
    var d: String = "1"
    var m: String = "1"
    var y: String = "1970"
    
    var exam_type: String = ""
    var exam_title: String = ""
    var max_marks: String = ""
    var passing_marks: String = ""
    var whether_grade_based: String = ""
    var test_comments: String = ""
    
    // lists to hold classes, sections and subject
    var class_list: [String] = []
    var section_list: [String] = []
    var subject_list: [String] = []
    var class_section_subject_list: [[String]] = [[], [], []]
    
    var selected_class: String = ""
    var selected_section: String = ""
    var selected_subject: String = ""
    
    var right_menu: String = ""
    
    var image: UIImage!
    
    @IBAction func goToAttendanceOrScheduleTest(sender: UIButton)
    {
        MiscFunction.decomposeDate(date_picker: datePicker, day: &d, month: &m, year: &y)
        
        // chances are that the teacher may select the default entries in the class/section/subject
        // picker. In this case the didSelectRow method would not fired and hence we will not get any
        // values in selected_class, selected_section, and selected subject. In this case we will have
        // to get the first values from the respective lists
        
        if (selected_class == "")   {
            selected_class = class_list[0]
        }
        
        if (selected_section == "") {
            selected_section = section_list[0]
        }
        
        if (selected_subject == "") {
            selected_subject = subject_list[0]
        }
        
        // now depending upon whether we have to take attendance or schedule test
        // we will have to take different actions
        switch(trigger)  {
            case "takeUpdateAttendance":
                // perform the segue to navigate to the Take Attendance Screen
                
                performSegue(withIdentifier: "to_take_attendance", sender: self)
                
            case "scheduleTest":
                if selected_subject == "Main"   {
                    showAlert(title: "Test cannot be scheudled for Main", message: "Test cannot be created for Main please select another subject.")
                    break
                }
                let analytics: AWSMobileAnalytics = SessionManager.getAnalytics()
                let eventClient: AWSMobileAnalyticsEventClient = analytics.eventClient
                let event: AWSMobileAnalyticsEvent = eventClient.createEvent(withEventType: "Schedule Test")
                eventClient.addGlobalAttribute(SessionManager.getLoggedInUser(), forKey: "user")
                eventClient.record(event)
                eventClient.submitEvents()
                
                exam_type = SessionManager.get_exam_type()
                // if it is a term test then no need to get test max marks & passing marks. Otherwise ask
                if exam_type == "term"  {
                    let index = d.index(d.startIndex, offsetBy: 9)
                    let dd = self.d.substring(from: index)
                    let date: String = dd.substring(to: dd.index(before: dd.endIndex))
                    let mm = self.m.substring(from: index)
                    let month: String = mm.substring(to: mm.index(before: mm.endIndex))
                    let yy = self.y.substring(from: index)
                    let year: String = yy.substring(to: yy.index(before: yy.endIndex))
                    let alert: UIAlertController = UIAlertController(title: "Confirm Schedule Test", message: "Are you sure to schedule test of \(self.selected_subject), Class: \(self.selected_class)-\(self.selected_section) on \(date )/\(month)/\(year) for \(self.exam_title)?", preferredStyle: .alert )
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                        let server_ip = MiscFunction.getServerIP()
                        let school_id: String = SessionManager.getSchoolId()
                        let user: String = SessionManager.getLoggedInUser()
                        let exam_id: String = SessionManager.get_exam_id()
                        let index = self.d.index(self.d.startIndex, offsetBy: 9)
                        let dd = self.d.substring(from: index)
                        let date = dd.substring(to: dd.index(before: dd.endIndex))
                        
                        let mm = self.m.substring(from: index)
                        let month = mm.substring(to: mm.index(before: mm.endIndex))
                        
                        let yy = self.y.substring(from: index)
                        let year = yy.substring(to: yy.index(before: yy.endIndex))
                        let max_marks = "80"
                        let pass_marks = "33"
                        let one = "1"
                        let syllabus = "Half yearly syllabus"
                        let url = "\(server_ip)/academics/create_test1/\(school_id)/\(self.selected_class)/\(self.selected_section)/\(self.selected_subject)/\(user)/\(date)/\(month)/\(year)/\(max_marks)/\(pass_marks)/\(one)/\(syllabus)/\(exam_id)/"
                        let url_string = url.replacingOccurrences(of: " ", with: "%20")
                        
                        Just.post(url_string)
                        self.performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
                        return
                    })
                    alert.addAction(confirmAction)
                    present(alert, animated: true, completion: nil)
                }
                else    {
                    // this is not a term test. perform segue to navigate to get max marks, pass marks, grade based and comments
                    performSegue(withIdentifier: "get_test_details", sender: self)
            }
            
            case "HWListVC":
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
            }
        default:
            print("default", terminator: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // No title for the back button in navigation section
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        // set the caption of the submit button
        switch trigger   {
            case "takeUpdateAttendance":
                right_menu = "Take Attendance"
                // attendance for future date is not allowed
                datePicker.maximumDate = NSDate() as Date
            case "scheduleTest":
                right_menu = "Schedule Test"
            case "HWListVC":
                right_menu = "Take Pic"
                date_label.text = "Due Date"
            default:
                right_menu = "Next"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        classPicker.delegate = self
        classPicker.dataSource = self
        
        let right_button = UIBarButtonItem(title: right_menu, style: .done, target: self, action: #selector(SelectDateClassSectionSubjectVC.goToAttendanceOrScheduleTest(sender:)))
        navigationItem.rightBarButtonItems = [right_button]
        
        // We need to get the class, section and subject in their respective arrays
        // 05/03/17 - we need to make sure that apis are called only during the first call to this function
        if class_list.count == 0 {
            let server_ip: String = MiscFunction.getServerIP()
            let school_id: String = SessionManager.getSchoolId()
            let teacher: String = SessionManager.getLoggedInUser()
            
            let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
            
            let sectionURL = "\(server_ip)/academics/section_list/\(school_id)/?format=json"
            let subjectURL2 = "\(server_ip)/academics/subject_list/\(school_id)/?format=json"
            
            let subjectURL = "\(server_ip)/teachers/teacher_subject_list/\(teacher)/?format=json"
        
            MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectDateClassSectionSubjectTVC")
            MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectDateClassSectionSubjectTVC")
            MiscFunction.sendRequestToServer(url: subjectURL, key: "subject", list: &subject_list, sender: "SelectDateClassSectionSubjectTVC")
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            
            // if teacher has not chosen subjects no subjects would be returned. Then get all the subjects
            if (subject_list.count<1) {
                MiscFunction.sendRequestToServer(url: subjectURL2, key: "subject_name", list: &subject_list, sender: "SelectDateClassSectionSubjectTVC")
            }
            
            class_section_subject_list[0] = class_list
            class_section_subject_list[1] = section_list
            class_section_subject_list[2] = subject_list
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //activityIndicator.stopAnimating()
    }
    
    
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int    {
        return class_section_subject_list.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return class_section_subject_list[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return class_section_subject_list[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_class = class_section_subject_list[0][(classPicker.selectedRow(inComponent: 0))]
        selected_section = class_section_subject_list[1][(classPicker?.selectedRow(inComponent: 1))!]
        selected_subject = class_section_subject_list[2][(classPicker?.selectedRow(inComponent: 2))!]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // we are showing class, section, and subject. They all need different widths
        switch component    {
        case 0: // class
            return 100
        case 1: // section
            return 40
        case 2: // subject
            return 200
        default:
            return 50
        }
        
    }
    
    // get the selected date from date picker
    func dateHandler(sender: UIDatePicker)  {
        let date_formatter = DateFormatter()
        date_formatter.timeStyle = DateFormatter.Style.short
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            performSegue(withIdentifier: "to_review_hw", sender: self)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = d.index(d.startIndex, offsetBy: 9)
        let dd = d.substring(from: index)
        
        let mm = m.substring(from: index)
        
        let yy = y.substring(from: index)

        switch trigger  {
            case "takeUpdateAttendance":
                let destinationVC = segue.destination as! TakeAttendanceVC
                destinationVC.the_class = selected_class
                destinationVC.section = selected_section
                destinationVC.subject = selected_subject
                
                // date, month, and year contains "optional( ) - we need to remove optional and parantheses
                let index = d.index(d.startIndex, offsetBy: 9)
                let dd = d.substring(from: index)
                destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
                let mm = m.substring(from: index)
                destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
                let yy = y.substring(from: index)
                destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))
                if subject_list.contains("Main")    {
                    destinationVC.whether_main = true
                }
                else    {
                    destinationVC.whether_main = false
                }
                
            case "scheduleTest":
                if exam_type != "term"  {
                    let destinationVC = segue.destination as! TestDetailsVC
                    destinationVC.the_class = selected_class
                    destinationVC.section = selected_section
                    destinationVC.subject = selected_subject
                    destinationVC.exam_title = exam_title
                    
                    // date, month, and year contains "optional( ) - we need to remove optional and parantheses
                    
                    destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
                    
                    destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
                    
                    destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))
            }
            
            case "scheduleTermTest":
                let destinationVC = segue.destination as! MainMenuVC
                destinationVC.comingFrom = "scheduleTermTest"
            
            case "HWListVC":
                let destinationVC = segue.destination as! ReviewHWVC
                destinationVC.sender = "CreateHW"
                destinationVC.the_class = selected_class
                destinationVC.section = selected_section
                destinationVC.subject = selected_subject
                
                // date, month, and year contains "optional( ) - we need to remove optional and parantheses
                let index = d.index(d.startIndex, offsetBy: 9)
                let dd = d.substring(from: index)
                destinationVC.d = dd.substring(to: dd.index(before: dd.endIndex))
                let mm = m.substring(from: index)
                destinationVC.m = mm.substring(to: mm.index(before: mm.endIndex))
                let yy = y.substring(from: index)
                destinationVC.y = yy.substring(to: yy.index(before: yy.endIndex))
                
                destinationVC.image = image
                
            default:
                break
        }
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
