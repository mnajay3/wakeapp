//
//  User.swift
//  wakeapp
//
//  Created by Naga Murala on 10/6/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation

struct User: Codable {
    var uid: String?
    var userName: String?
    var userEmail: String
    var encryptedData: String?
    var profilleImageURL: String?
}
