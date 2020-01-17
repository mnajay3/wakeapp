//
//  UserRegistrationOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 10/6/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import Firebase


class RegistrationRecord {
    var state = UserRegistrationOperation.RegistrationStatus.new
    var user: User
    init(user: User) {
        self.user = user
    }
}

class OperationQueues {
    lazy var userOperationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "User registration queue"
        return queue
    }()
}

class UserRegistrationOperation: AsynchronousOperation {
    
    enum RegistrationStatus {
        case new, pending, processed, failed
    }

    var registrationRecord: RegistrationRecord
    var exception: WakeAppException?
    
    init(registrationRecord: RegistrationRecord) {
        self.registrationRecord = registrationRecord
        super.init()
    }
    override func main() {
        guard !isCancelled else { return }
        self.registrationRecord.state = .pending
        Auth.auth().createUser(withEmail: self.registrationRecord.user.userEmail, password: self.registrationRecord.user.encryptedData!){ [unowned self](result, error) in
            defer { self.finish() }
            if error != nil {
                let errorMessage = error?.localizedDescription ?? "Error occured while user registration process"
                self.exception = WakeAppException.wakeAppException(message: errorMessage, code: "110125")
                self.registrationRecord.state = .failed
                return
            }
            self.registrationRecord.user.uid = result?.user.uid
            self.registrationRecord.state = .processed
        }
    }
    
}
