//
//  LoginViewController+UIPickerVC.swift
//  wakeapp
//
//  Created by Naga Murala on 11/16/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit

extension LoginViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK:- Concrete methods
    func handleProfileImageEvent() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var finalImage: UIImage?
        if let edited = info[UIImagePickerController.InfoKey.editedImage], let editedImage = edited as? UIImage {
            finalImage = editedImage
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage], let image = originalImage as? UIImage{
            finalImage = image
        }
        self.profileImage.image = finalImage
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
