//
//  UserRegistrationDelegate.swift
//  wakeapp
//
//  Created by Naga Murala on 10/15/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
protocol UserRegistrationDelegate: NSObjectProtocol {
    func triggerErrorResponse(errorDict:WakeAppException)
    func triggerSuccessResponse(status: String)
}
