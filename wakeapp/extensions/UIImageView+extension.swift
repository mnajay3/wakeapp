//
//  UIImageView+extension.swift
//  wakeapp
//
//  Created by Naga Murala on 12/18/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit
var cache = NSCache<AnyObject, UIImage>()
extension UIImageView {
    func loadImageViewWithUrl(urlStr: String) {
        self.image = UIImage(named: "unknown")
        if let cachedImage = cache.object(forKey: urlStr as AnyObject) {
            self.image = cachedImage as UIImage
            return
        }
        let url = URL(string: urlStr)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let downloadedImage =  UIImage(data: data!)
            cache.setObject(downloadedImage!, forKey: urlStr as AnyObject)
            DispatchQueue.main.async { [weak self] in
                self?.image = downloadedImage
                self?.setNeedsLayout()
            }
        }.resume()
    }
}
