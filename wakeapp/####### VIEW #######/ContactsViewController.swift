//
//  ContactsViewController.swift
//  wakeapp
//
//  Created by Naga Murala on 10/31/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    @IBOutlet var contactsTableViewModal: ContactsTableViewModal!
    @IBOutlet weak var contactsTableView: ContactsTableView!
    
    var messageVC: MessagesViewController?
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.contactsTableView.tableFooterView = UIView()
        self.contactsTableView.parentDelegate = self
        self.fetchContacts()
    }
    
    //MARK:- Service call
    func fetchContacts() {
        self.contactsTableViewModal.getContacts().done { [weak self] (users) in
            let timer = DispatchTime.now() + 0
            DispatchQueue.main.asyncAfter(deadline: timer) {
                self?.contactsTableView.contacts = self?.contactsTableViewModal.contacts
                self?.contactsTableView.reloadData()
            }
        }.catch { (error) in
            self.showAlert(withTitle: "Contacts Error!", andMessage: error.localizedDescription)
        }
    }
    
    //MARK: TABLEVIEW Transitions
    func itemSelected(toUser: User?) {
        self.dismiss(animated: true) { [unowned self] in
            self.messageVC?.launchChatLog(toUser: toUser)
        }
    }
    
    
    //MARK:- DEINITIALIZATION
    deinit {
        print("ContactsViewControlller is deallocated")
    }
    
}
