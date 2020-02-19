//
//  ChatLogCollectionViewCell.swift
//  wakeapp
//
//  Created by Naga Murala on 2/7/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import UIKit

class ChatLogCollectionViewCell: UICollectionViewCell {
    var messageView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    var bubbleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        ///Dummy initialization to stick to sizeForItemAt of collection view
        super.init(coder: coder)
        initialize()
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    func initialize() {
        addSubview(bubbleView)
        addSubview(messageView)
        setConstraints()
    }
    
    func configureCell(message: Message) {
        self.messageView.text = message.messageText
    }
    
    
    deinit {
        print("De-initialization from ChatLogCollectionViewCell")
    }
}

extension ChatLogCollectionViewCell {
    //MARK:- SET CONSTRAINTS
    func setConstraints() {
        bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        messageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        messageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        setNeedsUpdateConstraints()
    }
}
