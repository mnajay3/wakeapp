//
//  ChatLogOperation.swift
//  wakeapp
//
//  Created by Naga Murala on 1/15/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

class ChatLogOperation: AsynchronousOperation {
    
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
        let ref = Database.database().reference().child("messages")
        ///Firebase generates a unique ref id
        let childAutoRef = ref.childByAutoId()
        ///Load the message in firebase db
        childAutoRef.updateChildValues(["text" : message.messageText])
        self.finish()
    }
    
    
    
    
}
