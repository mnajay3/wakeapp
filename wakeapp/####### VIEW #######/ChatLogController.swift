//
//  ChatLogController.swift
//  wakeapp
//
//  Created by Naga Murala on 12/20/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//

import UIKit
import PromiseKit

class ChatLogController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var chatLogCollectionView: UICollectionView!
    @IBOutlet weak var chatLogInputViewContainer: UIView!
    @IBOutlet weak var chatLogInputTextField: UITextField!
    @IBOutlet weak var chatLogInputSendButton: UIButton!
    @IBOutlet var chatLogViewModal: ChatLogViewModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        firstly{
            self.chatLogViewModal.loadMessageInFirebase(self.chatLogInputTextField.text!)
        }.done {
            message in
            ///TODO: Future reference
        }.catch {
            error in
            self.showAlert(withTitle:"Message Load!", andMessage: error.localizedDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ///Even listener when enter key/return key is tapped on the keypad
        sendMessage("")
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Hi Ajay: Triggers when we enter into the text field")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    deinit {
        print("Hi Ajay: ChatLogController deallocated")
    }
}
