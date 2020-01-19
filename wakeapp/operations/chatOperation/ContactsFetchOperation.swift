//
//  ContactsFetchOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 1/16/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

class ContactsFetchOperation: AsynchronousOperation {
    var exception: WakeAppException?
    var contacts: [User] = []
    override init() {
        
    }
    
    override func main() {
        ///Early termination, if the task is already cancelled
        guard !isCancelled else {
            self.finish()
            return
        }
        
        Database.database().reference().child("contacts").observe(.childAdded, with: { [unowned self] (snapShot) in
            guard let contactsDict = snapShot.value as? [String: AnyObject]
                else {
                    self.exception = WakeAppException.wakeAppException(message: UserError.contactsEmpty.localizedDescription, code: "000")
                    self.finish()
                    return
            }
            print(contactsDict)
            for (key,child) in contactsDict {
                let user = User(uid: key,
                                userName: child["username"] as? String ?? "NA",
                                userEmail: child["email"] as? String ?? "NA",
                                encryptedData: "",
                                profilleImageURL: child["profileImageURL"] as? String ?? nil)
                if  user.userName != "NA"   &&
                    user.userEmail != "NA"  &&
                    user.uid != Auth.auth().currentUser?.uid
                {
                    self.contacts.append(user)
                }
            }
            self.finish()
        })
    }
    
}
