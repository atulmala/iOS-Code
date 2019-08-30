//
//  ParentImageVideoTVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 30/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Just


class ParentImageVideoTVC: UITableViewController {
    var student_id: String = ""
    var student_name: String = ""
    
    var image_list: [ImageVideoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150.0

        let server_ip: String = MiscFunction.getServerIP()
        let url: String = "\(server_ip)/pic_share/get_pic_video_list_teacher/\(student_id)/?format=json"
        
        let j = JSON(Just.get(url).json!)
        let count: Int? = j.count
        if (count! > 0)  {
            if let ct = count   {
                for index in 0...ct-1   {
                    var id: String = ""
                    if let _ = j[index]["id"].int {
                        let the_id = j[index]["id"]
                        id = String(stringInterpolationSegment: the_id)
                        
                        let date: String = j[index]["creation_date"].string!
                        // the date we have received is in yyyy-mm-dd format. Let's convert it to dd/mm/yy format
                        let yyyymmdd = date
                        let yy = yyyymmdd[2...3]
                        let mm = yyyymmdd[5...6]
                        let dd = yyyymmdd[8...9]
                        let ddmmyy = dd + "/" + mm +  "/"   + yy
                        
                        let type: String = j[index]["type"].string!
                        let the_class: String = j[index]["the_class"].string!
                        let section: String = j[index]["section"].string!
                        let description: String = j[index]["descrition"].string!
                        let location: String = j[index]["location"].string!
                        let short_link: String = j[index]["short_link"].string!
                        
                        image_list.append(ImageVideoModel(id: id, date: ddmmyy, type: type, the_class: the_class, section: section, location: location, short_link: short_link, description: description))
                    }
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
        lable.textColor = UIColor.black
        lable.font = lable.font.withSize(12)
        lable.numberOfLines = 0
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Shared Image/Videos"
        self.navigationItem.titleView = lable
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return image_list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "image_video_cell", for: indexPath) as! ImageVideoCell
        
        // Configure the cell...
        cell.date.text = image_list[indexPath.row].date
        cell.type.text = image_list[indexPath.row].type
        
        let class_sec: String = "\(image_list[indexPath.row].the_class)-\(image_list[indexPath.row].section)"
        cell.the_class.text = class_sec
        
        cell.short_link.text = image_list[indexPath.row].short_link
        
        cell.short_link.isEditable = false
        cell.short_link.isSelectable = true
        cell.short_link.dataDetectorTypes = UIDataDetectorTypes.link
        cell.short_description.text = image_list[indexPath.row].description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}
