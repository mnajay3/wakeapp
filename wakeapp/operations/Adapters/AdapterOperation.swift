//
//  UserRegistrationAdapterOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 10/12/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import UIKit

class AdapterOperation: AsynchronousOperation {
    var userInput : UserInput
    var exception: WakeAppException?
    var operationQueue: OperationQueue = OperationQueue()
    
    init(userInput: UserInput) {
        self.userInput = userInput
        /// Make sure to call super init method to trigger main methos
        super.init()
    }
    
    override func main() {
        let registrationRecord = RegistrationRecord(user: self.userInput.user)
        let persistRecord = PersistRecord(user: self.userInput.user)
        
        //MARK:- OPERATION INITIALIZATIONS
        let userRegistration = UserRegistrationOperation(registrationRecord: registrationRecord)
        let userPersistance =  PersistUserInfoOperation(persistRecord: persistRecord)
        let profileImgStorage = ProfileImageStorageOperation(userInput: userInput)
        
        //MARK:- ADAPTER BLOCK OPERATION
        /// Mediator operation to set response from registration operation and profile image storage operation to user persistence operation
        let adapter = BlockOperation() {
            [unowned userRegistration,unowned profileImgStorage, unowned userPersistance, unowned self] in
            userPersistance.persistRecord.user = userRegistration.registrationRecord.user
            userPersistance.persistRecord.user.profilleImageURL = profileImgStorage.userInput.user.profilleImageURL
            
            /// Hold the final user object in userinput
            self.userInput.user = userPersistance.persistRecord.user
        }
        
        //MARK:- OPERATION COMPLITION BLOCKS
        userRegistration.completionBlock = { [unowned self] in
            if let exception = userRegistration.exception {
                self.operationQueue.cancelAllOperations()
                self.exception = exception
                if !self.isFinished {
                    self.finish()
                }
            }
        }
        profileImgStorage.completionBlock = {
            if let exception = profileImgStorage.exception {
                self.exception = exception
                self.operationQueue.cancelAllOperations()
                if !self.isFinished {
                    self.finish()
                }
            }
        }
        userPersistance.completionBlock = { [unowned self] in
            if !self.isFinished {
                self.finish()
            }
            if let exception = userPersistance.exception {
                self.exception = exception
            }
        }
        
        //MARK:- ADD OPERATION DEPENDENCIES
        /// userRegistrationOperation -> profileImageStorageOperation -> adapterOperation -> userPersistanceOperation
        profileImgStorage.addDependency(userRegistration)
        adapter.addDependency(profileImgStorage)
        userPersistance.addDependency(adapter)
        
        //MARK:- OPERATION QUEUE - Operations trigger point
        self.operationQueue.addOperations([userRegistration, adapter, profileImgStorage, userPersistance], waitUntilFinished: true)
    }
}
