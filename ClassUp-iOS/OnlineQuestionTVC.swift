//
//  OnlineQuestionTVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 19/05/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just

class QuestionModel: NSObject   {
    var id: String
    var question: String
    var option_a: String
    var option_b: String
    var option_c: String
    var option_d: String
    var option_marked: String
    
    init(id: String, question: String, option_a: String, option_b: String, option_c: String, option_d: String, option_marked: String)  {
        self.id = id
        self.question = question
        self.option_a = option_a
        self.option_b = option_b
        self.option_c = option_c
        self.option_d = option_d
        self.option_marked = option_marked
        super.init()
    }
}

class OnlineQuestionTVC: UITableViewController {
    var test_id: String = ""
    var student_id: String = ""
    var question_list: [QuestionModel] = []
    
    var timer: Timer = Timer()
    var duration: Int = 30 * 60
    var min_remaining: Int = 30
    var sec_remaining: Int = 0
    var time_remaining: String = "30:00"
    var lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let server_ip: String = MiscFunction.getServerIP()
        let url: String = "\(server_ip)/online_test/get_online_questions/\(test_id)/"
        
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                var q_no: Int = 1
                for index in 0...ct-1   {
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                    }
                    
                    let question: String = "Q " + String(q_no) + "  " + j[index]["question"].string!
                    let option_a: String = "A. " + j[index]["option_a"].string!
                    let option_b: String = "B. " + j[index]["option_b"].string!
                    let option_c: String = "C. " + j[index]["option_c"].string!
                    let option_d: String = "D. " + j[index]["option_d"].string!
                    
                    question_list.append(QuestionModel(id:id, question: question, option_a:option_a, option_b: option_b, option_c: option_c, option_d: option_d, option_marked: "X"))
                    q_no += 1
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        let submit_button = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(OnlineQuestionTVC.submit(_:)))
        navigationItem.rightBarButtonItems = [submit_button]
        runTimer()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return question_list.count
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(OnlineQuestionTVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        duration -= 1
        min_remaining = duration / 60
        sec_remaining = duration % 60
        
        time_remaining = String(format: "Time Left %02i:%02i", min_remaining, sec_remaining)
        
        lable.text = time_remaining
        self.navigationItem.titleView = lable
        
        if duration < 0    {
            showAlert(title: "Time Over", message: "Time Over. Please Submit your Test Now")
            timer.invalidate()
            let totalSection = tableView.numberOfSections
            for section in 0..<totalSection {
                let totalRows = tableView.numberOfRows(inSection: section)
                
                for row in 0..<totalRows    {
                    let cell = tableView.cellForRow(at: IndexPath(row: row, section: section))
                    if let segment = cell?.viewWithTag(5) as? UISegmentedControl    {
                        segment.isEnabled = false
                    }
                }
            }
        }
    }
    
    func submit(_ sender:UIButton)   {
        let prompt: String = "Are you sure that you want submit this Online Test?"
        let alert: UIAlertController = UIAlertController(title: "Please Confirm", message: prompt, preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            self.duration = -1
            self.timer.invalidate()
            let totalSection = self.tableView.numberOfSections
            for section in 0..<totalSection {
                let totalRows = self.tableView.numberOfRows(inSection: section)
                
                for row in 0..<totalRows    {
                    let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                    if let segment = cell?.viewWithTag(5) as? UISegmentedControl    {
                        segment.isEnabled = false
                    }
                }
            }
            
            self.navigationItem.hidesBackButton = false
            self.navigationItem.rightBarButtonItems = nil
            self.showAlert(title: "Test Submitted", message: "Test has been Submitted")
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "question_cell", for: indexPath) as! QuestionCell
        
        cell.delegate = self
        cell.selectionStyle = .none
        
        if duration < 0 {
            cell.option_selector.isEnabled = false
            let cells = self.tableView.visibleCells as! Array<QuestionCell>
            for cell in cells{
                cell.option_selector.isEnabled = false
            }
        }
        
        cell.question_id.text = question_list[indexPath.row].id
        
        cell.question.text = question_list[indexPath.row].question
        cell.option_a.text = question_list[indexPath.row].option_a
        cell.option_b.text = question_list[indexPath.row].option_b
        cell.option_c.text = question_list[indexPath.row].option_c
        cell.option_d.text = question_list[indexPath.row].option_d
        
        switch question_list[indexPath.row].option_marked   {
        case "A":
            cell.selected_option.selectedSegmentIndex = 0
            cell.option_a.textColor = UIColor.blue
            cell.option_b.textColor = UIColor.black
            cell.option_c.textColor = UIColor.black
            cell.option_d.textColor = UIColor.black
            break
        case "B":
            cell.selected_option.selectedSegmentIndex = 1
            cell.option_a.textColor = UIColor.black
            cell.option_b.textColor = UIColor.blue
            cell.option_c.textColor = UIColor.black
            cell.option_d.textColor = UIColor.black
            break
        case "C":
            cell.selected_option.selectedSegmentIndex = 2
            cell.option_a.textColor = UIColor.black
            cell.option_b.textColor = UIColor.black
            cell.option_c.textColor = UIColor.blue
            cell.option_d.textColor = UIColor.black
            break
        case "D":
            cell.selected_option.selectedSegmentIndex = 3
            cell.option_a.textColor = UIColor.black
            cell.option_b.textColor = UIColor.black
            cell.option_c.textColor = UIColor.black
            cell.option_d.textColor = UIColor.blue
            break
        case "X":
            cell.selected_option.selectedSegmentIndex = -1
            cell.option_a.textColor = UIColor.black
            cell.option_b.textColor = UIColor.black
            cell.option_c.textColor = UIColor.black
            cell.option_d.textColor = UIColor.black
            break
        default:
            break
        }
        
        return cell
    }
   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ParentMenuVC
        destinationVC.triggeringMenu = "OnlineTest"
        let count = self.navigationController?.viewControllers.count
        self.navigationController?.viewControllers.remove(at: count! - 2)
     }
}
