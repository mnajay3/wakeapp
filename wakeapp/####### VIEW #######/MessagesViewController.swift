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
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesViewModal = MessagesViewModal()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(handleCreateNewMessage))
        //Fetch active user details if active
        checkUserStatus()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(launchChatLog))
        titleView.addGestureRecognizer(tapGesture)
        self.navigationItem.titleView = titleView
    }
    
    //MARK:- OBJC functions
    @objc func handleSignOut() {
        self.messagesViewModal?.handleSignOut(complition: {[weak self] (error) in
            guard let self = self else { return }
            /// Show alert, if signout is unsuccessful
            guard let err = error  else { return }
            self.showAlert(withTitle: "Error!", andMessage: err)
            return
        })
        displaySignInOrSignUpPage()
    }
    
    /// Display Create new message page
    @objc func handleCreateNewMessage() {
        //MARK:- Class methods
        /// Display Login/Signup Page after succesful login
        let mainStoryBoard = UIStoryboard(name: "main", bundle: nil)
        let newMessageViewController : NewMessageViewController = mainStoryBoard.instantiateViewController(withIdentifier: "newMessageSB") as! NewMessageViewController
        self.navigationController?.pushViewController(newMessageViewController, animated: true)
        //        self.navigationController?.present(newMessageViewController, animated: true, completion: nil)
        
    }
    
    //MARK:- Class methods
    func displaySignInOrSignUpPage() {
        /// Display Login/Signup Page after succesful login
        let mainStoryBoard = UIStoryboard(name: "main", bundle: nil)
        let loginViewController : LoginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "wakeappID") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.delegate = self
        
        self.present(loginViewController,animated: true, completion: nil)
    }
    
    //MARK:- LAUNCH CHAT LOG CONTROLER
    @objc func launchChatLog() {
        let mainStoryBoard = UIStoryboard(name: "main", bundle: nil)
        let chatLogVC : ChatLogController = mainStoryBoard.instantiateViewController(withIdentifier: "chatLogVC") as! ChatLogController
        chatLogVC.modalPresentationStyle = .fullScreen
        
        
        self.navigationController?.pushViewController(chatLogVC,animated: true)
    }
    
    
    //MARK:- Deinitialization
    deinit {
        print("Hi: I am deinit in ViewController")
    }
}

