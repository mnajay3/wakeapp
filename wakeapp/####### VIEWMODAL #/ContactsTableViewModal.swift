//
//  ContactsTableViewModal.swift
//  wakeapp
//
//  Created by Naga Murala on 11/1/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import PromiseKit

class ContactsTableViewModal: NSObject {
    var contacts: [User] = []
    func getContacts() ->Promise<[User]> {
        Promise<[User]> {
            [unowned self]seal in
            let contactFetchOperation = ContactsFetchOperation()
            contactFetchOperation.completionBlock = {
                if contactFetchOperation.contacts.isEmpty, let exception = contactFetchOperation.exception {
                    seal.reject(exception)
                }
                self.contacts = contactFetchOperation.contacts
                seal.fulfill(self.contacts)
            }
            let operationQueue = OperationQueues()
            operationQueue.queue.addOperation(contactFetchOperation)
        }
        
    }
}
