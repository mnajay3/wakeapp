//
//  UIAlertView+extension.swift
//  wakeapp
//
//  Created by Naga Murala on 10/5/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { action in
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
