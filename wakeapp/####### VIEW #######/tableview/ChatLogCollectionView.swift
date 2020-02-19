//
//  ChatLogCollectionView.swift
//  wakeapp
//
//  Created by Naga Murala on 2/6/20.
//  Copyright © 2020 Naga Murala. All rights reserved.
//

import UIKit

class ChatLogCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var messages: [Message] = []
    var chatPartner: User? {
        didSet{
            self.fetchMessages()
        }
    }
    
    //MARK:-INITIALIZATION METHODS
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    func initialize() {
        dataSource = self
        delegate = self
        register(ChatLogCollectionViewCell.self, forCellWithReuseIdentifier: "messageItem")
        contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    //MARK:- COLLECTIONVIEW DELEGATE AND DATASOURCE METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let item = self.dequeueReusableCell(withReuseIdentifier: "messageItem", for: indexPath) as! ChatLogCollectionViewCell
        item.configureCell(message: messages[indexPath.item])
        if let text = messages[indexPath.item].messageText {
            item.bubbleWidthAnchor?.constant = estimateHeightOfCell(text: text).width + 32
        }
        return item
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].messageText {
            height = estimateHeightOfCell(text: text).height +  20
        }
        return CGSize(width: self.frame.width, height: height)
    }
    
    //MARK:- FETCH MESSAGES
    func fetchMessages() {
        let messageFetchOperation = MessageFetchOperation()
        messageFetchOperation.fetchMessageFromFirebase { [weak self](message) in
            let messageId = message.getChatPartnerID()
            guard messageId == self?.chatPartner?.uid else { return }
            self?.messages.append(message)  
            guard let msgs = self?.messages else { return }
            self?.messages = msgs.sorted(by: {
                msg1, msg2 in
                msg1.timeStamp! < msg2.timeStamp!
            })
            DispatchQueue.main.async {
                self?.reloadData()
            }
        }
    }
    
    //MARK:- ESTIMATE HEIGHT OF CELL
    func estimateHeightOfCell(text: String) -> CGRect {
        //Width is bubble view width and the height is some arbitary height
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
