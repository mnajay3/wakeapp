//
//  ContactsViewModal.swift
//  wakeapp
//
//  Created by Naga Murala on 10/19/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit


public enum UserError: Error {
    case invalidUserSnapShot
    case inputValuesAreEmpty
    case contactsEmpty
    case uidIsNullOrEmpty
}

class MessagesViewModal: NSObject {
    var user: User?
    //MARK:- Check the user is active
    func isUserActive() -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        //        Database.database().reference().child("users").child(uid).observeSingleEvent(of:.value,with:{
        //            (snapshot) in
        //            print("Hi Ajay: snapshot: ", snapshot)
        //        })
        self.user?.uid = uid
        return true
    }
    
    //MARK:- Signout the user
    func handleSignOut(complition: (String?)->()) {
        guard let _ = Auth.auth().currentUser?.uid else {
            complition(nil)
            return
        }
        do {
            try Auth.auth().signOut()
            complition(nil)
        } catch let err{
            print("Unable to sign out the user: ", err.localizedDescription)
            complition(err.localizedDescription)
        }
    }
    
    /// Promise kit to fetch current User details
    func fetchLoginUserDetails() -> Promise<User> {
        Promise<User>{seal in
            if let localUser = self.user, let _ = localUser.userName {
                seal.fulfill(localUser)
            }
            guard let uid = Auth.auth().currentUser?.uid else {
                seal.reject(UserError.uidIsNullOrEmpty)
                return
            }
            let _ = fetchUserDetails(id: uid).map{ user in
                self.user = user
                seal.fulfill(user)
            }.ensure {
                ///Google the usage
            }
        }
    }
    
    func fetchUserDetails(id: String) -> Promise<User> {
        Promise<User> { seal in
            Database.database().reference().child("contacts").child("users").child(id).observeSingleEvent(of: .value, with: { snapshot in
                guard let userDict = snapshot.value as? [String: AnyObject] else {
                    seal.reject(UserError.invalidUserSnapShot)
                    return
                }
                let userName = userDict["username"] as? String ?? "N/A"
                let email = userDict["email"] as? String ?? "N/A"
                let profileImageURL = userDict["profileImageURL"] as? String ?? "N/A"
                let currentUser = User(uid: id, userName: userName, userEmail:email,profilleImageURL: profileImageURL)
                seal.fulfill(currentUser)
            }, withCancel: nil)
        }
    }
    
}
