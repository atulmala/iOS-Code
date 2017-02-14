//
//  SelectClassBulkSMSVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 14/02/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Just

class ClassListSource:NSObject {
    var the_class: String
    
    init(the_class: String)  {
        self.the_class = the_class
        super.init()
    }
}


class SelectClassBulkSMSVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var class_list: [ClassListSource] = []
    var selection: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the api to get the list of classes
        let server_ip: String = MiscFunction.getServerIP()
        let school_id: String = SessionManager.getSchoolId()
        let url: String = "\(server_ip)/academics/class_list/\(school_id)/?format=json";
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    let the_class: String = j[index]["standard"].string!
                    class_list.append(ClassListSource(the_class: the_class))
                }
            }
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return class_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "class_selection_cell", for: indexPath as IndexPath) as! ClassListCell
        
        // Configure the cell...
        // we are storing id, class, section, date, month, and year as hidden in the cell
        // so that we can access them in Cell specific view controller.
        cell.the_class.text = class_list[indexPath.row].the_class
        
        cell.selectionStyle = .none
        if (selection.index(of: class_list[indexPath.row].the_class as String) != nil)  {
            cell.accessoryType = .checkmark
        }
        else    {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! ClassListCell!
        
        if cell?.accessoryType == .checkmark    {
            cell?.accessoryType = .none
            if selection.index(of: (cell?.the_class.text!)!) != nil{
                selection.remove(at: selection.index(of: (cell?.the_class.text!)!)!)
            }
            
        }
        else    {
            cell?.accessoryType = .checkmark
            
            if selection.index(of: (cell?.the_class.text!)!) == nil{
                selection.append((cell?.the_class.text!)!)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
