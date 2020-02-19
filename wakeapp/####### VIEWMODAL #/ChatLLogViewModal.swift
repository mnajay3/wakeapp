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
//     var messages: [String: [Message]] = [:]

    
    var toUser: User? {
        didSet {
            let fromId = Auth.auth().currentUser?.uid
            message = Message(fromId: fromId, toId: toUser?.uid)
        }
    }
    
    
    func loadMessageInFirebase(_ messageText: String) -> Promise<Message> {
        Promise<Message> { [unowned self]seal in
            let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
            self.message?.messageText = messageText
            self.message?.timeStamp = timeStamp
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
            operationQueue.queue.addOperation(messagePersistOperation)
        }
    }
    ///Moved this method to ChatLogColllectionView: Make sure to put it back
//    func fetchMessages(chatPartner: User, completion: @escaping () -> ()) {
//        let messageFetchOperation = MessageFetchOperation()
//        messageFetchOperation.fetchMessageFromFirebase { [unowned self](message) in
//            let messageId = message.getChatPartnerID()
//            guard messageId == chatPartner.uid else { return }
//            guard nil != self.messages[messageId] else  {
//                self.messages[messageId] = [message]
//                completion()
//                return
//            }
//            self.messages[messageId] = self.messages[messageId]! + [message]
//            self.messages[messageId] = self.messages[messageId]?.sorted(by: {
//                msg1, msg2 in
//                msg1.timeStamp! > msg2.timeStamp!
//            })
//            completion()
//            //            DispatchQueue.main.async {
//            //                self.tableView.reloadData()
//            //            }
//        }
//    }
}
