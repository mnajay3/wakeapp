//
//  Message.swift
//  wakeapp
//
//  Created by Naga Murala on 1/15/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import Foundation

struct Message: Codable {
    var fromId: String?
    var toId: String?
    var timeStamp: Int?
    var messageText: String?
}
