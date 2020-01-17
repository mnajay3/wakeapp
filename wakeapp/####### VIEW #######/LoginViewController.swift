//
//  LoginViewController.swift
//  wakeapp
//
//  Created by Naga Murala on 10/3/19.
//  Copyright © 2019 Naga Murala. All rights reserved.
//
import UIKit
import PromiseKit

class LoginViewController: UIViewController, UserRegistrationDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var loginInputFieldsStackView: UIStackView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var loginOrRegisterButton: UIButton!
    @IBOutlet weak var loginVCViewModal: LoginVCViewModal!
    @IBOutlet weak var loginContainerViewHeight: NSLayoutConstraint!
    
    weak var delegate: MessagesViewController?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        return ai
    }()
    //MARK:- ViewController Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    func initialize() {
        self.loginVCViewModal.delegate = self
        self.profileName.delegate = self
        self.userEmail.delegate = self
        self.userPassword.delegate = self
        profileImage.backgroundColor = .none
        profileImage.image = UIImage(named: "gameofthrones_splash")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handelProfileImageViewEvent))
        profileImage.addGestureRecognizer(gesture)
        self.view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        self.loginOrRegisterButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
    }
    
    //MARK:-IBActions
    @IBAction func loginOrRegistrationButtonClicked(_ sender: Any) {
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            loginUserInFirebase()
            
        case 1:
            /// User input validation
            validateAndPersistUserModal()
            /// Display activity indicator
            showActivityIndicator()
            ///Register user in firebase
            registerUserInFirebase()
            
        default:
            print("Unknown index")
        }
        
    }
    
    @IBAction func ListenSegmentControlAction(_ sender: Any) {
        self.loginOrRegisterButton.setTitle(self.segmentControl.titleForSegment(at: self.segmentControl.selectedSegmentIndex), for: .normal)
        
        switch self.segmentControl.selectedSegmentIndex
        {
        case 0:
            self.profileName.isHidden = true
            self.loginContainerViewHeight.isActive = false
            self.loginContainerViewHeight = self.loginContainerView.heightAnchor.constraint(equalToConstant: 100)
            self.loginContainerViewHeight.isActive = true
        case 1:
            self.profileName.isHidden = false
            self.loginContainerViewHeight.isActive = false
            self.loginContainerViewHeight = self.loginContainerView.heightAnchor.constraint(equalToConstant: 150)
            self.loginContainerViewHeight.isActive = true
        default:
            print("Unknown index")
        }
    }
    
    //MARK:- SET PROFILE IMAGE
    @objc func handelProfileImageViewEvent() {
        self.handleProfileImageEvent()
    }
    
    //MARK:- Validate User Input
    func validateAndPersistUserModal() {
        /// Input field validation Null check
        guard let userName = self.profileName.text, let email = self.userEmail.text, let password = self.userPassword.text  else {
            self.showAlert(withTitle: "Error!", andMessage: "One or more input fields null")
            return
        }
        /// Input field validation Empty check
        guard !userName.isEmpty && !email.isEmpty && !password.isEmpty else {
            self.showAlert(withTitle: "Error!", andMessage: "One or more input fields Empty")
            return
        }
        let user = User(userName: userName, userEmail: email, encryptedData: password)
        self.loginVCViewModal.user = user
    }
    
    //MARK:- REGISTER USER IN FIREBASE
    func registerUserInFirebase() {
        /// Service invocation to Register the user and persist user information
        loginVCViewModal.registerAndPostUser(profileImage: self.profileImage.image!){
            [weak self] status in
            guard status else {
                self?.showAlert(withTitle: "Error!", andMessage: "User registration error occured")
                self?.activityIndicator.stopAnimating()
                return
            }
            self?.activityIndicator.stopAnimating()
            self?.dismiss(animated: true, completion: {
                self?.delegate?.messagesViewModal?.user = self?.loginVCViewModal.user
                self?.delegate?.checkUserStatus()
            })
        }
    }
    
    //MARK:- LOGIN USER IN FIREBASE
    func loginUserInFirebase() {
        /// Input field validation Null check
        guard let email = self.userEmail.text, let password = self.userPassword.text  else {
            self.showAlert(withTitle: "Error!", andMessage: "One or more input fields null")
            return
        }
        let user = User(userEmail: email, encryptedData: password)
        self.loginVCViewModal.user = user
        self.showActivityIndicator()
        ///Using PROMISKIT:  Login user service invocation
        let _ = self.loginVCViewModal.loginUser().done{ [unowned self] usr in
            self.dismiss(animated: true, completion: {
                self.delegate?.messagesViewModal?.user = self.loginVCViewModal.user
                self.delegate?.checkUserStatus()
            })
        }.ensure { [unowned self] in
            self.activityIndicator.stopAnimating()
        }.catch {
            [unowned self] error in
            self.showAlert(withTitle: "ERROR!", andMessage: error.localizedDescription)
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    
    //MARK:- StatusBar Configurations
    override var preferredStatusBarStyle: UIStatusBarStyle  {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- User Registration Delegate methods
    func triggerErrorResponse(errorDict: WakeAppException) {
        self.activityIndicator.stopAnimating()
        self.showAlert(withTitle: "Error!", andMessage: errorDict.errorDescription ?? "Something went wrong!")
    }
    
    func triggerSuccessResponse(status: String) {
        //TODO: on successfull scenario
    }
    
    //MARK:- TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    //MARK:- Deallocation of objects in deinit
    deinit {
        print("LoginViewController deallocation")
    }
}
