//
//  QuestionCell.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 20/05/20.
//  Copyright © 2020 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import Alamofire

class QuestionCell: UITableViewCell {
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var question_id: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var option_a: UILabel!
    @IBOutlet weak var option_b: UILabel!
    @IBOutlet weak var option_d: UILabel!
    @IBOutlet weak var option_c: UILabel!
    @IBOutlet weak var option_selector: UISegmentedControl!
    
    var delegate: OnlineQuestionTVC?
    @IBAction func marks_answer(_ sender: UISegmentedControl) {
        
        var answer_marked: String = "X"
        if let i = delegate?.question_list.index(where: { $0.id == id.text })  {
            switch sender.selectedSegmentIndex {
            case 0:
                answer_marked = "A"
                option_a.textColor = UIColor.blue
                option_b.textColor = UIColor.black
                option_c.textColor = UIColor.black
                option_d.textColor = UIColor.black
                delegate?.question_list[i].option_marked = "A"
                break
            case 1:
                answer_marked = "B"
                option_a.textColor = UIColor.black
                option_b.textColor = UIColor.blue
                option_c.textColor = UIColor.black
                option_d.textColor = UIColor.black
                delegate?.question_list[i].option_marked = "B"
                break
            case 2:
                answer_marked = "C"
                option_a.textColor = UIColor.black
                option_b.textColor = UIColor.black
                option_c.textColor = UIColor.blue
                option_d.textColor = UIColor.black
                delegate?.question_list[i].option_marked = "C"
                break
            case 3:
                answer_marked = "D"
                option_a.textColor = UIColor.black
                option_b.textColor = UIColor.black
                option_c.textColor = UIColor.black
                option_d.textColor = UIColor.blue
                delegate?.question_list[i].option_marked = "D"
                break
            default:
                break;
            }
            
            let server_ip: String = MiscFunction.getServerIP()
            let student_id = delegate?.student_id
            let question_id = self.question_id.text
            var params = [String:String]()
            params["student_id"] = student_id
            params["question_id"] = question_id
            params["answer_marked"] = answer_marked
            
            let url: String = "\(server_ip)/online_test/mark_answer/"
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
                .responseJSON { response in
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var selected_option: UISegmentedControl!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
