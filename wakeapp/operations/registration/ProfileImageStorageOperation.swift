//
//  ProfileImageStorageOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 11/21/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

class ProfileImageStorageOperation : AsynchronousOperation {
    var userInput: UserInput
    var exception: WakeAppException?
    enum StorageStatus {
        case new, pending, processed, failed
    }
    init(userInput: UserInput) {
        self.userInput = userInput
        super.init()
    }
    
    override func main() {
        /// Move forward only if the task is not cancelled already
        guard !isCancelled else { return }
        
        /// create a firebase storage reference with universal unique identifier(UUID)
        let uuid = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child(uuid+".jpg")
        
        /// Store the image in fire base storage
        
        storageRef.putData(self.userInput.profileImage, metadata: nil) { (metaData, error) in
            if error != nil {
                let errorMessage = error?.localizedDescription ?? "Error occured while user registration process"
                self.exception = WakeAppException.wakeAppException(message: errorMessage, code: "110125")
                self.finish()
                return
            }
            storageRef.downloadURL { (url, err) in
                defer {
                    self.finish()
                }
                if err != nil {
                    let errorMessage = error?.localizedDescription ?? "Error occured while user registration process"
                    self.exception = WakeAppException.wakeAppException(message: errorMessage, code: "110125")
                    return
                }
                self.userInput.user.profilleImageURL = url?.absoluteString
            }
            
        }
        
    }
    
}
