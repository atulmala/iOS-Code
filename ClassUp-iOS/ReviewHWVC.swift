//
//  ReviewHWVC.swift
//  ClassUp-iOS
//
//  Created by Atul Gupta on 02/05/17.
//  Copyright © 2017 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit
import SDWebImage

class ReviewHWVC: UIViewController, UIScrollViewDelegate {
    var sender: String = ""
    var id: String = ""
    var location: String = ""

    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var hw_image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll_view.minimumZoomScale = 0.5
        scroll_view.maximumZoomScale = 6.0
        scroll_view.contentSize = hw_image.frame.size
        scroll_view.contentInset = UIEdgeInsets.zero
        
        scroll_view.scrollIndicatorInsets = UIEdgeInsets.zero;

        // Do any additional setup after loading the view.
        
        hw_image.setShowActivityIndicator(true)
        hw_image.setIndicatorStyle(.gray)
        hw_image.sd_setImage(with: URL(string: location), placeholderImage: UIImage(named: "placeholder.png"))
        hw_image.setShowActivityIndicator(false)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return hw_image
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.        // Pass the selected object to the new view controller.
    }
    */

}
