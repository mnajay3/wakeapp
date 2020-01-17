//
//  LoginUserOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 10/22/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

struct LoginRecord {
    var state = LoginUserOperation.LoginStatus.new
    var user: User
}
class LoginUserOperation : AsynchronousOperation {
    enum LoginStatus {
        case new, pending, processed, failed
    }
    var loginRecord: LoginRecord
    var exception: WakeAppException?
    init(loginRecord: LoginRecord) {
        self.loginRecord = loginRecord
        /// Must call super in operation init for asynchronous operations
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        self.loginRecord.state = .pending
        guard let password = self.loginRecord.user.encryptedData else {
            return
        }
        Auth.auth().signIn(withEmail: self.loginRecord.user.userEmail, password: password) { [weak self] (authData, error) in
            guard let self = self else { return }
            defer {
                self.finish()
            }
            guard error == nil else {
                let errorMessage = error?.localizedDescription ?? "Error occured while user login process"
                self.exception = WakeAppException.wakeAppException(message: errorMessage, code: "110125")
                self.loginRecord.state = .failed
                return
            }
            guard let uid = authData?.user.uid  else {
                return
            }
            self.loginRecord.user.uid = uid
            self.loginRecord.state = .processed
        }
        
    }
}
