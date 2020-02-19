//
//  Message.swift
//  wakeapp
//
//  Created by Naga Murala on 1/15/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation
import Firebase

struct Message: Codable {
    var fromId: String?
    var toId: String?
    var timeStamp: Int?
    var messageText: String?
    
    func getTimeString() -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(timeStamp!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        let timeString = dateFormatter.string(from: time)
        return timeString
    }
    
    func getChatPartnerID() -> String {
        let uid = Auth.auth().currentUser?.uid
        //Condition to handle incoming and outgoing messages
        //Display from user profile picture for incoming messages
        return (uid == fromId!) ? toId! : fromId!
    }
}
