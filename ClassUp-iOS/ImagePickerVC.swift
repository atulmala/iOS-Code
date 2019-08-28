//
//  ImagePickerVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 27/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class ImagePickerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image_pickeer: UIImageView!
    let imagePicker = UIImagePickerController()
    
    var coming_from: String = "share_pic"
    var image_picked: Bool = false
    var the_image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if image_picked {
            let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 440, height: 44))
            lable.textColor = UIColor.black
            lable.font = lable.font.withSize(12)
            lable.numberOfLines = 0
            lable.textAlignment = NSTextAlignment.center
            lable.text = "Please Preview"
            self.navigationItem.titleView = lable
            
            let select_from_gallery = UIBarButtonItem(title: "Select Students", style: .done, target: self, action: #selector(ImagePickerVC.select_students(sender:)))
            navigationItem.rightBarButtonItems = [select_from_gallery,]
        }
    }
    
    @IBAction func select_students(sender: UIButton) {
        performSegue(withIdentifier: "sel_student_for_pic_sharing", sender: self)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picked_image = info[UIImagePickerControllerOriginalImage] as? UIImage    {
            image_pickeer.contentMode = .scaleAspectFit
            image_pickeer.image = picked_image
            image_picked = true
            the_image = picked_image
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SelStudentForPicSharingVC
        destinationVC.coming_from = coming_from
        destinationVC.image = the_image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
