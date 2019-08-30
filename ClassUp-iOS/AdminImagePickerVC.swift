//
//  AdminImagePickerVC.swift
//  ClassUp-iOS
//
//  Created by Atul "The Advanced Prototype" Gupta on 30/08/19.
//  Copyright © 2019 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import UIKit

class AdminImagePickerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var image_picker: UIImageView!
    
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
            
            let next_button = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(AdminImagePickerVC.next(sender:)))
            navigationItem.rightBarButtonItems = [next_button,]
        }
    }
    
    @IBAction func next(sender: UIButton) {
        performSegue(withIdentifier: "admin_enter_message_for_pic", sender: self)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picked_image = info[UIImagePickerControllerOriginalImage] as? UIImage    {
            image_picker.contentMode = .scaleAspectFit
            image_picker.image = picked_image
            image_picked = true
            the_image = picked_image
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AdminPicSelectedVC
        destinationVC.coming_from = coming_from
        destinationVC.image = the_image
    }
}
