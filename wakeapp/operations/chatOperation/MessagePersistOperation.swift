//
//  MessagePersistOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 1/15/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

class MessagePersistOperation: AsynchronousOperation {
    
    var message: Message
    var wakeAppException: WakeAppException?
    
    init(message: Message) {
        self.message = message
    }
    
    override func main() {
        ///Early termination, if the task is already cancelled
        guard !isCancelled else {
            self.finish()
            return
        }
        /// Create firebase db reference
        let ref = Database.database()
            .reference()
        
        ///Firebase generates a unique ref id
        let childAutoRef = ref.child("messages")
            .childByAutoId()
        
        ///Message Dictionary
        let messageDict: [String: Any] = ["fromId" : message.fromId!,
                                          "toId" : message.toId!,
                                          "timeStamp" : message.timeStamp!,
                                          "messageText" : message.messageText!]
        
        ///Load message in firebase database
        childAutoRef.updateChildValues(messageDict) { [unowned self](error, ref) in
            if error != nil {
                self.wakeAppException = WakeAppException.wakeAppException(
                    message: "Unable to load the message in Firebase", code: "000"
                )
                self.finish()
                return
            }
            
            ///Load message ID under the From ID
            Database.database()
                .reference()
                .child("user-messages")
                .child(self.message.fromId!)
                .updateChildValues([childAutoRef.key! : 0])
            
            ///Load message ID under the To ID to display messages in both the users
            Database.database()
                .reference()
                .child("user-messages")
                .child(self.message.toId!)
                .updateChildValues([childAutoRef.key! : 0])
            
            self.finish()
            
        }
    }
    
    
    
    
}
