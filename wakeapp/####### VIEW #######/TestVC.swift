//
//  TestVC.swift
//  wakeapp
//
//  Created by Naga Murala on 10/24/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import Foundation
import UIKit

class TestVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    deinit {
        print("Deallocating TestVC")
    }
}
