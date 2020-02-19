//
//  ViewController.swift
//  wakeapp
//
//  Created by Naga Murala on 10/3/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

class MessagesViewController: UITableViewController {
    var messagesViewModal: MessagesViewModal?
    var messages: [String: [Message]] = [:]
    var messagesArray:[Message] = []
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesViewModal = MessagesViewModal()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(handleCreateNewMessage))
        //Fetch active user details if active
        checkUserStatus()
        
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "messageCell")
    }
    //MARK:- TABLE VIEW CONTROLLER DELLEGATE, DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        let message = self.messagesArray[indexPath.row]
        ///Fetch   user  details from Firebase
        
        
        let _ = messagesViewModal?.fetchUserDetails(id: message.getChatPartnerID()).map({ user in
            cell.configureCell(message: message, user: user)
        })
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messagesArray[indexPath.row]
        let _ = messagesViewModal?.fetchUserDetails(id: message.getChatPartnerID())
            .map({ [unowned self]user in
            self.launchChatLog(toUser: user)
        })

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    //MARK:- PROMISEKIT
    func checkUserStatus() {
        guard let viewModal = self.messagesViewModal, viewModal.isUserActive() else {
            handleSignOut()
            return
        }
        /// Invoking promise with firstly
        firstly {
            viewModal.fetchLoginUserDetails()
        }.done {
            [unowned self] usr in
            self.setNavigationBarImageAndTitle(user: usr)
            self.fetchMessages()
        }.catch {
            error in
            self.showAlert(withTitle: "LLogin User!", andMessage: error.localizedDescription)
        }
    }
    
    //MARK:- NAVIGATION BAR IMAGE VIEW AND TITLE
    func setNavigationBarImageAndTitle(user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        /// Set profile Image
        let profileImageView = UIImageView(frame: CGRect(origin:.zero, size: CGSize(width: 40, height: 40)))
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        if let profileImageViewURL = user.profilleImageURL {
            profileImageView.loadImageViewWithUrl(urlStr: profileImageViewURL)
        }
        titleView.addSubview(profileImageView)
        
        /// Set user name
        let label = UILabel(frame: CGRect(x: 45, y: -25, width: titleView.bounds.width, height: 100))
        label.text = user.userName
        titleView.addSubview(label)
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(launchChatLog))
        //        titleView.addGestureRecognizer(tapGesture)
        self.navigationItem.titleView = titleView
    }
    
    //MARK:- OBJC functions
    @objc func handleSignOut() {
        self.messagesViewModal?.handleSignOut(complition: {[weak self] (error) in
            guard let self = self else { return }
            /// Show alert, if signout is unsuccessful
            guard let err = error  else {
                self.messages.removeAll()
                self.messagesArray.removeAll()
                self.tableView.reloadData()
                return
            }
            self.showAlert(withTitle: "Error!", andMessage: err)
            return
        })
        displaySignInOrSignUpPage()
    }
    
    /// Display Create new message page
    @objc func handleCreateNewMessage() {
        //MARK:- Class methods
        /// Display Login/Signup Page after succesful login
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let contactsViewController : ContactsViewController = mainStoryBoard.instantiateViewController(withIdentifier: "newMessageSB") as! ContactsViewController
        contactsViewController.modalPresentationStyle = .formSheet
        ///Set the delegate to launch chat logview controller on contact selection
        contactsViewController.messageVC = self
        self.present(contactsViewController, animated: true, completion: nil)
        
    }
    
    //MARK:- Class methods
    func displaySignInOrSignUpPage() {
        /// Display Login/Signup Page after succesful login
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController : LoginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "wakeappID") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.delegate = self
        
        self.present(loginViewController,animated: true, completion: nil)
    }
    
    //MARK:- LAUNCH CHAT LOG CONTROLER
    func launchChatLog(toUser: User?) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let chatLogVC : ChatLogController = mainStoryBoard.instantiateViewController(withIdentifier: "chatLogVC") as! ChatLogController
        chatLogVC.modalPresentationStyle = .fullScreen
        chatLogVC.navigationItem.title = toUser?.userName ?? ""
        chatLogVC.chatLogViewModal.toUser = toUser
        
        self.navigationController?.pushViewController(chatLogVC,animated: true)
    }
    
    //MARK:- FETCH MESSAGES
    func fetchMessages() {
        let messageFetchOperation = MessageFetchOperation()
        messageFetchOperation.fetchMessageFromFirebase { [unowned self](message) in
            let uid = Auth.auth().currentUser?.uid
            let messageId = (uid == message.fromId!) ? message.toId! : message.fromId!
            if let _ = self.messages[messageId] {
                self.messages[messageId] = self.messages[messageId]! + [message]
                let unSorted : [Message] = self.messages[messageId]!
                self.messages[messageId] = unSorted.sorted(by: {
                    msg1, msg2 in
                    msg1.timeStamp! > msg2.timeStamp!
                })
            } else {
                self.messages[messageId] = [message]
            }
            self.messagesArray = Array(self.messages.values).map{ $0.first! }.sorted(by:  { $0.timeStamp! > $1.timeStamp! })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    //MARK:- Deinitialization
    deinit {
        print("Hi: I am deinit in ViewController")
    }
}

