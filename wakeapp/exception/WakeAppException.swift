//
//  WakeAppException.swift
//  wakeapp
//
//  Created by Naga Murala on 10/13/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation


enum WakeAppException: LocalizedError {
    case wakeAppException(message:String, code: String)
    
    var errorDescription: String? {
        switch self {
        case let .wakeAppException(message, _):
            return "\(message)"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case let .wakeAppException(message, _):
            return message
        }
    }
}
