//
//  ChatLLogViewModal.swift
//  wakeapp
//
//  Created by Naga Murala on 1/15/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation
import PromiseKit
import Firebase

class ChatLogViewModal: NSObject {
    var message: Message?
    
    var toUser: User? {
        didSet {
            let fromId = Auth.auth().currentUser?.uid
            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
            message = Message(fromId: fromId, toId: toUser?.uid, timeStamp: timeStamp, messageText: "")
        }
    }
    
    
    func loadMessageInFirebase(_ messageText: String) -> Promise<Message> {
        Promise<Message> { seal in
            self.message?.messageText = messageText
            guard let message = message else {
                seal.reject(UserError.inputValuesAreEmpty)
                return
            }
            let messagePersistOperation = MessagePersistOperation(message: message)
            messagePersistOperation.completionBlock = { [unowned self] in
                ///Activity after comletion of Operation
                guard let exception = messagePersistOperation.wakeAppException else {
                    seal.fulfill(self.message!)
                    return
                }
                seal.reject(exception)
            }
            let operationQueue = OperationQueues()
            operationQueue.userOperationQueue.addOperation(messagePersistOperation)
        }
        
    }
}
