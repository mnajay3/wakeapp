//
//  ContactsTableViewModal.swift
//  wakeapp
//
//  Created by Naga Murala on 11/1/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit

class ContactsTableViewModal: NSObject {
    var contacts: [User] = []
    func getContacts() ->Promise<[User]> {
        return Promise {
            seal in
            //            Database.database().reference().child("users").observe(.childAdded, with: { [unowned self] (snapShot) in
            Database.database().reference().observe(.childAdded, with: { [unowned self] (snapShot) in
                guard let contactsDict = snapShot.value as? [String: AnyObject]
                    else {
                        return seal.reject(UserError.inputValuesAreEmpty)
                }
                for child in contactsDict.values {
                    let user = User(userName: child["username"] as? String ?? "NA",                      userEmail: child["email"] as? String ?? "NA",
                                    encryptedData: "",
                                    profilleImageURL: child["profileImageURL"] as? String ?? "NA")
                    self.contacts.append(user)
                }
                seal.fulfill(self.contacts)
            }) { (error) in
                seal.reject(error)
            }
            
        }
    }
}
