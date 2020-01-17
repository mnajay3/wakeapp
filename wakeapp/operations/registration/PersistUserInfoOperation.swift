//
//  PersistUserInfoOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 10/10/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

class PersistRecord {
    var state = PersistUserInfoOperation.PersistStatus.new
    var userDict: [String: String] = [:]
    var user: User {
        didSet {
//            if let uid = self.user.uid {
//                self.userDict[RegistrationInputs.uid.localized] = uid
//            }
            if let userName = self.user.userName {
                self.userDict[RegistrationInputs.username.localized] = userName
            }
            self.userDict[RegistrationInputs.email.localized] = !self.user.userEmail.isEmpty ? self.user.userEmail : ""
            if let profileImageurl = self.user.profilleImageURL {
                self.userDict[RegistrationInputs.profileImageURL.localized] = profileImageurl
            }
        }
    }
    init(user: User) {
        self.user = user
    }
}

class PersistUserInfoOperation: AsynchronousOperation {
    enum PersistStatus {
        case new, pending, processed, failed
    }
    
    var persistRecord: PersistRecord
    var exception: WakeAppException?
    init(persistRecord: PersistRecord) {
        self.persistRecord = persistRecord
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        self.persistRecord.state = .pending
        let dbRef = Database.database().reference(fromURL: "https://wakeapp-b254d.firebaseio.com")
        guard let uid = self.persistRecord.user.uid else {
            self.persistRecord.state = .failed
            self.finish()
            return
        }
        dbRef.child("contacts").child("users").child(uid).updateChildValues(self.persistRecord.userDict){
           [unowned self] (error, ref) in
            defer
            {
                self.finish()
            }
            guard error == nil else {
                let errorMessage = error?.localizedDescription ?? "Error occured while user registration process"
                self.exception = WakeAppException.wakeAppException(message: errorMessage, code: "110125")
                self.persistRecord.state = .failed
                return
            }
            self.persistRecord.state = .processed
        }
    }
}
