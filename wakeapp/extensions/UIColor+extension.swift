//
//  UIColor+extension.swift
//  wakeapp
//
//  Created by Naga Murala on 10/3/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
