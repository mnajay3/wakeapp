//
//  LoginVCViewModal.swift
//  wakeapp
//
//  Created by Naga Murala on 10/5/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

enum RegistrationInputs: String {
    case uid, username, email, profileImageURL, pwd="password"
    
    var localized: String {
      return NSLocalizedString(self.rawValue, comment: "")
    }
}

class LoginVCViewModal: NSObject{
    var user: User?
    weak var delegate: UserRegistrationDelegate?
  
    //MARK:- SIGNUP USER
    /// Register the user in fire base auth and store the profile image in firebase storage followed by persist the user in fire base realtime database
    func registerAndPostUser(profileImage: UIImage, completion: @escaping (Bool)-> Void) {
        guard let user = self.user else {
                   print("User is null, plese check")
                   completion(false)
                   return
               }
        guard (self.user?.encryptedData) != nil else {
            print("User password is null, plese check")
            completion(false)
            return
        }
        guard let _ = self.user?.userEmail else {
            print("User Email is null, plese check")
            completion(false)
            return
        }
        guard let _ = self.user?.userName else {
            print("User name is null, plese check")
            completion(false)
            return
        }
        guard let imageData = profileImage.jpegData(compressionQuality: 0.1) as? Data else {
            print("Hi ajay, Unable to cnvert profile image to data")
            return
        }
        let userInput = UserInput(user: user, profileImage: imageData)
        let adapterOperation = AdapterOperation(userInput: userInput)
        adapterOperation.completionBlock = {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let exception = adapterOperation.exception {
                    //TODO:- Change this call to promise kit
                    self.delegate?.triggerErrorResponse(errorDict: exception)
                    return
                }
                print("User persistance is successful")
                self.user  = adapterOperation.userInput.user
                completion(true)
            }
        }
        //NSOperation queues
        let operationQueues = OperationQueues()
        operationQueues.userOperationQueue.addOperation(adapterOperation)
    }
    
    //MARK:- SINGIN USER
    func loginUser() -> Promise<User> {
        return Promise<User>{ seal in
            guard let user = self.user else {
                print("User is null, plese check")
                seal.reject(UserError.inputValuesAreEmpty)
                return
            }
            guard (self.user?.encryptedData) != nil else {
                print("User password is null, plese check")
                seal.reject(UserError.inputValuesAreEmpty)
                return
            }
            guard let _ = self.user?.userEmail else {
                print("User Email is null, plese check")
                seal.reject(UserError.inputValuesAreEmpty)
                return
            }
            let loginRecord = LoginRecord(user: user)
            let loginUserOperation = LoginUserOperation(loginRecord: loginRecord)
            loginUserOperation.completionBlock = { [unowned self] in
                DispatchQueue.main.async {
                    guard let uid = loginUserOperation.loginRecord.user.uid else {
                        if let error = loginUserOperation.exception  {
                            seal.reject(error)
                            return
                        }
                        seal.reject(UserError.invalidUserSnapShot)
                        return
                    }
                    self.user?.uid = uid
                    seal.fulfill(self.user!)
                }
            }
            ///NSOperation queues
            let operationQueue = OperationQueues()
            operationQueue.userOperationQueue.addOperation(loginUserOperation)
        }
    }
}
