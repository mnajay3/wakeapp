//
//  ContactsTableViewCell.swift
//  wakeapp
//
//  Created by Naga Murala on 11/1/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detaillLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(user:User) {
        self.titleLabel?.text = user.userName
        self.detaillLabel?.text = user.userEmail
        self.profileImageView.image = nil
        guard let profileImageURL = user.profilleImageURL else {
            return
        }
        //Cache logic available in the UIImage view extension
        self.profileImageView.loadImageViewWithUrl(urlStr: profileImageURL)
    }
}
