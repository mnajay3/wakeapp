//
//  MessageTableViewCell.swift
//  wakeapp
//
//  Created by Naga Murala on 1/23/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    //MARK:- IBOUTLET INITIALIZATION
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        iv.image = UIImage(named: "unknown")
        return iv
    }()
    var titleTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "HH:MM:SS"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.contentMode = .scaleAspectFill
        stackView.distribution = .fillEqually
        stackView.spacing = -15
        return stackView
    }()
    
    //MARK:- INITIALIZER METHODS
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- SUBVIEW SETUP
    func setup() {
        self.addSubview(profileImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
        self.stackView.addArrangedSubview(titleTimeView)
        self.stackView.addArrangedSubview(detailLabel)
        self.addSubview(stackView)
        setupConstraints()
    }
    
    //MARK:- CONSTRAINTS
    func setupConstraints() {
        //Profile Image
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        self.profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        //TitleLabel
        self.titleLabel.leftAnchor.constraint(equalTo: self.titleTimeView.leftAnchor).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.titleTimeView.rightAnchor, constant: -80).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.titleTimeView.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.titleTimeView.bottomAnchor).isActive = true
        
        //TimeLLabel
        self.timeLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.timeLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.timeLabel.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true
        self.timeLabel.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor).isActive = true
        
        //Stack View
        self.stackView.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor, constant: 5).isActive = true
        self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    //MARK:- DATA CONFIGURATION
    func configureCell(message: Message, user:User) {
        self.titleLabel.text = user.userName
        self.detailLabel.text = message.messageText
        self.profileImageView.image = nil
        guard let profileImageURL = user.profilleImageURL else {
            return
        }
        //Cache logic available in the UIImage view extension
        self.profileImageView.loadImageViewWithUrl(urlStr: profileImageURL)
        self.timeLabel.text = "\(message.getTimeString())"
    }
    
    deinit {
        print("De-initialization of Message Table view Cell")
    }
}
