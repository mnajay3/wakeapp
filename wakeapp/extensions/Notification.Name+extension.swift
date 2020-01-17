//
//  Notification.Name+extension.swift
//  wakeapp
//
//  Created by Naga Murala on 10/5/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let onAuthenticationSuccess = Notification.Name("FireBaseAuthenticationSuccess")
    static let onRegistrationFailure = Notification.Name("FireBaseRegistrationError")
    static let onFirebaseLoadFailure = Notification.Name("FireBaseDatabaseLoadError")
}
