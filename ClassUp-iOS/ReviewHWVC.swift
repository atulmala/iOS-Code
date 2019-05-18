//
//  ReviewHWVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 02/05/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ReviewHWVC: UIViewController, UIScrollViewDelegate {
    var sender: String = ""
    var id: String = ""
    var location: String = ""
    var image: UIImage!
    
    var d: String = ""
    var m: String = ""
    var y: String = ""
    var the_class: String = ""
    var section: String = ""
    var subject: String = ""

    @IBOutlet weak var nav_item: UINavigationItem!
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var hw_image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll_view.minimumZoomScale = 1.0
        scroll_view.maximumZoomScale = 6.0
        scroll_view.contentSize = hw_image.frame.size
        scroll_view.contentInset = UIEdgeInsets.zero
        scroll_view.scrollIndicatorInsets = UIEdgeInsets.zero;
        
        switch sender  {
            case "CreateHW":
                nav_item.title = "Review"
                nav_item.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action:#selector(ReviewHWVC.uploadHW))
                hw_image.image = image
                break
            case "TeacherApp":
                nav_item.title = "HW"
                hw_image.setShowActivityIndicator(true)
                hw_image.setIndicatorStyle(.gray)
                hw_image.sd_setImage(with: URL(string: location), placeholderImage: UIImage(named: "placeholder.png"))
                hw_image.setShowActivityIndicator(false)
            default:
                break
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return hw_image
    }
    
    func uploadHW() {
        //let date = Date()
        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyyMMdd_HHmmss"
        //let timestamp = formatter.string(from: (from:date) as! Date)
        let random = Int.random(in: 0 ..< 100000)
        let teacher: String = SessionManager.getLoggedInUser()
        let school_id: String = SessionManager.getSchoolId()
        let imageFileName: String = "\(teacher)_\(the_class)-\(section)_\(subject)_\(String(random)).jpg"
        
        
        let imageData:NSData = UIImageJPEGRepresentation(image, 85)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let due_date: String = "\(d)/\(m)/\(y)"
        
        let prompt: String = "Are you sure to upload this HW?"
        let alert: UIAlertController = UIAlertController(title: "Confirm HW Upload", message: prompt, preferredStyle: .alert )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            let parameters: Parameters = [
                "hw_image": strBase64,
                "image_name": imageFileName,
                "school_id": school_id,
                "teacher": teacher,
                "class": self.the_class,
                "section": self.section,
                "subject": self.subject,
                "d": self.d,
                "m": self.m,
                "y": self.y,
                "due_date": due_date
            ]
            
            Alamofire.request("\(server_ip)/academics/create_hw/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
            }
            self.performSegue(withIdentifier: "gotoMainMenuScreen", sender: self)
            self.dismiss(animated: true, completion: nil)
            return
        })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as! MainMenuVC
        destinationVC.comingFrom = "CreateHW"
    }
    

}
