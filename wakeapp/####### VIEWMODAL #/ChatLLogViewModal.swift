//
//  ChatLLogViewModal.swift
//  wakeapp
//
//  Created by Naga Murala on 1/15/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation
import PromiseKit

class ChatLogViewModal: NSObject {
    var message: Message?
    
    func loadMessageInFirebase(_ messageText: String) -> Promise<Message> {
        Promise<Message> { seal in
            self.message = Message(messageText: messageText)
            
            let chatLogOperation = ChatLogOperation(message: message!)
            chatLogOperation.completionBlock = { [unowned self] in
                ///Activity after comletion of Operation
                guard let exception = chatLogOperation.wakeAppException else {
                    seal.fulfill(self.message!)
                    return
                }
                seal.reject(exception)
            }
            let operationQueue = OperationQueues()
            operationQueue.userOperationQueue.addOperation(chatLogOperation)
        }
        
    }
}
