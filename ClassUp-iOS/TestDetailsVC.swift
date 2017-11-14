//
//  TestDetailsVC.swift
//  Classup1
//
//  Created by Atul "The Advanced Prototype" Gupta on 23/09/15.
//  Copyright (c) 2015 Atul Gupta. All rights reserved.
//

import UIKit
import Alamofire
import Just


class TestDetailsVC: UIViewController {
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""
    var teacher: String = ""
    var d: String = ""
    var m: String = ""
    var y: String = ""
    
    var whether_grade_based = "1"       // 0 = grade based, 1 = not grade based
    
    var mm = ""
    var pm = ""
    var cmnts: String = ""
    var good_to_go: Bool = true

    @IBOutlet weak var max_marks: UITextField!
    @IBOutlet weak var pass_marks: UITextField!
    @IBOutlet weak var grade_based: UISwitch!
    @IBOutlet weak var comments: UITextView!
    
    @IBOutlet weak var toMainMenu: UIButton!
    @IBOutlet weak var activity_indicator: UIActivityIndicatorView!
    @IBAction func setGradeBased(sender: UISwitch) {
        // switch is off
        if !sender.isOn   {
            max_marks.isEnabled = true
            max_marks.text = ""
            max_marks.placeholder = "Max Marks"
            pass_marks.isEnabled = true
            pass_marks.text = ""
            pass_marks.placeholder = "Pass Marks"
                        whether_grade_based = "1"
        }
        // switch is on
        if sender.isOn    {
            max_marks.isEnabled = false
            max_marks.text = ""
            pass_marks.isEnabled = false
            pass_marks.text = ""
            whether_grade_based = "0"
            
            mm = max_marks.text!
            pm = pass_marks.text!
            
            
            good_to_go = true
        }
        
    }
    @IBAction func submit(sender: UIButton) {
        if !grade_based.isOn  {
            if (max_marks.text == ""  || max_marks.text == "0" || pass_marks.text == "")   {
                if max_marks.text == ""  {
                    showAlert(title: "Test Submission Error", message: "Max Marks cannot be blank")
                }
                if max_marks.text == "0" {
                    showAlert(title: "Test Submission Error", message: "Max Marks cannot be Zero")
                }
                if pass_marks.text == "" {
                    showAlert(title: "Test Submission Error", message: "Pass Marks cannot be blank")
                }
                good_to_go = false
            }
            else    {
                // the values supplied by user are acceptable.
                mm = max_marks.text!
                pm = pass_marks.text!
                good_to_go = true
                whether_grade_based = "1"
            }
            
        }
        if grade_based.isOn   {
            // in case of grade based test, max_marks and pass_marks are blank. We need to set these
            // to zero to enable proper formation of url
            mm = "0"
            pm = "0"
            whether_grade_based = "0"
            good_to_go = true
        }
        if (good_to_go)  {
            //activity_indicator.startAnimating()
            //om
            cmnts = "No Comments"
            
            // if user has not entered any comment, let's put a default comment, otherwise cause error in http call
            cmnts = comments.text!
            if cmnts == ""   {
                cmnts = "No Comments"
                
            }

            // remove any spcaces in comments as spaces causes error in http calls
            cmnts = cmnts.replacingOccurrences(of: " ", with: "%20")
            
            let server_ip = MiscFunction.getServerIP()
            let school_id = SessionManager.getSchoolId()
            let user = SessionManager.getLoggedInUser()
            
            let url = "\(server_ip)/academics/create_test1/\(school_id)/\(the_class)/\(section)/\(subject)/\(user)/\(d)/\(m)/\(y)/\(mm)/\(pm)/\(whether_grade_based)/\(cmnts)/unit/"
            
            let url_string = url.replacingOccurrences(of: " ", with: "%20")
            
            Just.post(url_string)

            performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comments.placeholderText = "Test Topics/Comments (Optional)"
        comments.layer.borderWidth = 1
        comments.layer.borderColor = UIColor.black.cgColor

        max_marks.keyboardType = UIKeyboardType.numberPad
        pass_marks.keyboardType = UIKeyboardType.numberPad
        
        // Defaul test is marks based. Hence grade_based switch should be off
        grade_based.setOn(false, animated: true)
        
        //max_marks.text = "0"
        //pass_marks.text = "0"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "TestDetailsVC"
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

}
