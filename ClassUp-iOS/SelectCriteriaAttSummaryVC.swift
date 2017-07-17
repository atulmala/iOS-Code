//
//  SelectCriteriaAttSummaryVC.swift
//  Classup1
//
//  Created by Atul Gupta on 14/10/15.
//  Copyright © 2015 Atul Gupta. All rights reserved.
//

import UIKit

class SelectCriteriaAttSummaryVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch (pickerView) {
        case class_sub_sec_picker:
            return class_section_subject_list.count
            
            
        case month_picker:
            return 2
            
            //case year_picker:
            //return 1
            
        default:
            break
            
        }
        // just for the sake of compilation!
        return 20

    }


    func showAttSummary(sender: UIButton) {
        performSegue(withIdentifier: "showAttSummary", sender: self)

    }
    
    @IBOutlet weak var class_sub_sec_picker: UIPickerView!
    //@IBOutlet weak var year_picker: UIPickerView!
    @IBOutlet weak var month_picker: UIPickerView!
    
    var m: String = ""
    var y: String = ""
    
    // lists to hold classes, sections and subject
    var class_list: [String] = []
    var section_list: [String] = []
    var subject_list: [String] = []
    var class_section_subject_list: [[String]] = [[], [], []]
    var month_year_list:[[String]] = [[], []]
    
    var month_list: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var year_list:[String] = ["Current Year", "Last Year", "Till Date"]
    
    var selected_class: String = ""
    var selected_section: String = ""
    var selected_subject: String = ""
    
    var selected_month = ""
    var selected_year = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        month_picker.delegate = self
        month_picker.dataSource = self
        //year_picker.delegate = self
        //year_picker.dataSource = self
        
        month_year_list[0] = month_list
        month_year_list[1] = year_list
        
        // We need to get the class, section and subject in their respective arrays
        
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let teacher: String = SessionManager.getLoggedInUser()
        
        let classURL = "\(server_ip)/academics/class_list/\(school_id)/?format=json"
        
        let sectionURL = "\(server_ip)/academics/section_list/\(school_id)?format=json"
        let subjectURL2 = "\(server_ip)/academics/subject_list/\(school_id)?format=json"
        
        let subjectURL = "\(server_ip)/teachers/teacher_subject_list/\(teacher)/?format=json"
        //print("subject url=\(subjectURL)")
        MiscFunction.sendRequestToServer(url: classURL, key: "standard", list: &class_list, sender: "SelectDateClassSectionSubjectTVC")
        MiscFunction.sendRequestToServer(url: sectionURL, key: "section", list: &section_list, sender: "SelectDateClassSectionSubjectTVC")
        
        
        MiscFunction.sendRequestToServer(url: subjectURL, key: "subject", list: &subject_list, sender: "SelectDateClassSectionSubjectTVC")
        // if teacher has not chosen subjects no subjects would be returned. Then get all the subjects
        if (subject_list.count<1) {
            MiscFunction.sendRequestToServer(url: subjectURL2, key: "subject_name", list: &subject_list, sender: "SelectDateClassSectionSubjectTVC")
        }
        
        
        class_section_subject_list[0] = class_list
        class_section_subject_list[1] = section_list
        class_section_subject_list[2] = subject_list
        
        // No title for the back button in navigation section
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain,
            target: nil, action: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 16/07/2017 - moving the Show Attendance button to the navigation bar
        
        let show_button = UIBarButtonItem(title: "Show", style: .done, target: self, action: #selector(SelectCriteriaAttSummaryVC.showAttSummary(sender:)))
        navigationItem.rightBarButtonItems = [show_button]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int    {
        switch (pickerView) {
            case class_sub_sec_picker:
                return class_section_subject_list.count
                
            case month_picker:
                return 2
            
            //case year_picker:
                //return 1
            
            default:
                break

        }
        // just for the sake of compilation!
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (pickerView) {
        case class_sub_sec_picker:
            //print("row for class/sec/sub picker=\(class_section_subject_list[component][row])")
            return class_section_subject_list[component][row]
        case month_picker:
            //return month_list[row]
            return month_year_list[component][row]
        //case year_picker:
            //return year_list[row]
        default:
            return "Not Available"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(pickerView)  {
            case class_sub_sec_picker:
                return class_section_subject_list[component].count
            case month_picker:
                //return month_list.count
                return month_year_list[component].count
            //case year_picker:
                //return year_list.count
                //break
            default:
                break
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(pickerView)  {
            case class_sub_sec_picker:
                selected_class = class_section_subject_list[0][class_sub_sec_picker.selectedRow(inComponent: 0)]
                //print("Selected class=\(selected_class)")
                selected_section = class_section_subject_list[1][class_sub_sec_picker.selectedRow(inComponent: 1)]
                //print("selected section=\(selected_section)")
                selected_subject = class_section_subject_list[2][class_sub_sec_picker.selectedRow(inComponent: 2)]
                //print("selected subject=\(selected_subject)")
                break
            case month_picker:
                //selected_month = month_list[month_picker.selectedRowInComponent(0)]
                selected_month = month_year_list[0][month_picker.selectedRow(inComponent: 0)]
                selected_year = month_year_list[1][month_picker.selectedRow(inComponent: 1)]
                //print("selected month=\(selected_month)")
                //print("Selected year=\(selected_year)")
                break
            //case year_picker:
               // selected_year = year_list[year_picker.selectedRowInComponent(0)]
               // print("selected year=\(selected_year)")
               // break
            default:
                break
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // different picker require different widths
        switch pickerView   {
            case month_picker:
                switch component    {
                case 0: // month
                    return 100
                case 1: // year
                    return 150
                
                default:
                    return 50
            }
            //case year_picker:
               // return 150
            case class_sub_sec_picker:
                // we are showing class, section, and subject. They all need different widths
                switch component    {
                    case 0: // class
                        return 60
                    case 1: // section
                        return 70
                    case 2: // subject
                        return 200
                    default:
                        return 50
                }
            default:
                return 50
        }
    }
    
    // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as!   ShowAttendanceSummaryVC
        
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
        
        if selected_month == "" {
            selected_month = month_list[0]
        }
        
        if (selected_year == "")    {
            selected_year = year_list[0]
        }

        vc.the_class = selected_class
        vc.sec = selected_section
        vc.sub = selected_subject
        vc.month = selected_month
        vc.year = selected_year
    }
    


}
