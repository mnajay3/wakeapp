//
//  ContactsTableView.swift
//  wakeapp
//
//  Created by Naga Murala on 11/1/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit
import Foundation

class ContactsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    weak var parentDelegate: ContactsViewController?
    var contacts: [User]?
    let cellIdentifier = "contactsViewCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        dataSource = self
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        self.addGestureRecognizer(swipeGesture)
    }
    
    //The following method will get invoked from custome table view(not from the storyboard)
    public init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        //        self.register(ContactsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        delegate = self
        dataSource = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        self.addGestureRecognizer(swipeGesture)
    }
    
    //MARK:- TableView DATASOURCE methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contacts = self.contacts else { return 0}
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactsTableViewCell
        guard let _cell = cell else { return UITableViewCell() }
        guard let contacts = self.contacts, !contacts.isEmpty else { return _cell }
        _cell.configureCell(user: contacts[indexPath.row])
        return _cell
    }
    
    //MARK:- TableView DELEGATE methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let var1 = self.contacts, !var1.isEmpty else { return }
        self.parentDelegate?.itemSelected(toUser: var1[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //MARK:- Gesture recognizer
    @objc func handleSwipeGesture() {
        self.parentDelegate?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Deinitialization
    deinit {
        print("ContactsTableView deinitialization")
    }
    
}
