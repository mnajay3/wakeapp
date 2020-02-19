//
//  MessageFetchOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 1/18/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

class MessageFetchOperation: NSObject {
    
    var wakeAppException: WakeAppException?
    override init() {
    }
    
    public func fetchMessageFromFirebase(completion: @escaping (Message)->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ///Fetch messageID's in user-messages node for the current user
        Database.database()
            .reference()
            .child("user-messages")
            .child(uid)
            .observe(.childAdded) { [weak self](snapshot) in
                let messageId = snapshot.key
                ///Fetch message details from messages node for each messageId
                Database.database().reference().child("messages").child(messageId).observeSingleEvent(of: .value) { (snapshot) in
                    
                    guard let messageDict = snapshot.value as? [String: AnyObject] else {
                        self?.wakeAppException = WakeAppException.wakeAppException(message: "Unable to fetch messages", code: "000")
                        return
                    }
                    
                    let message = Message(fromId: messageDict["fromId"] as? String ,
                                          toId: messageDict["toId"] as? String,
                                          timeStamp: messageDict["timeStamp"] as? Int,
                                          messageText: messageDict["messageText"] as? String)
                    
                    completion(message)
                }
        }
    }
}
