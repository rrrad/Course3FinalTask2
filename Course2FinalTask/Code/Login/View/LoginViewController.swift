//
//  LoginViewController.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 28/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

protocol LoginViewControllerOutputProtocol {
    var callBack: ((Eerr, Bool) -> Void)? {get set}
}

class LoginViewController: UIViewController, LoginViewControllerOutputProtocol {
    
    var callBack: ((Eerr, Bool) -> Void)?
    private var dataManager = LoginDataManager()
    
    private lazy var loginButton:UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(hexString: "#007AFF")
        button.addTarget(self, action: #selector(logWithButton), for: .touchUpInside)
        button.alpha = 0.3
        button.isEnabled = false
        return button
    }()
    
    
    private lazy var loginTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.placeholder = "username"
        tf.returnKeyType = .send
        tf.autocorrectionType = .no
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.placeholder = "password"
        tf.returnKeyType = .send
        tf.keyboardType = .asciiCapable
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // жест для того чтобы убирать клавиатуру при касании вью
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(endEditingTextField))
        view.addGestureRecognizer(tapGesture)
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(loginButton)
        view.addSubview(passwordTextField)
        view.addSubview(loginTextField)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    @objc
    func endEditingTextField(){
        view.endEditing(true)
    }
    
    @objc
    func logWithButton()  {
        self.view.endEditing(true)
        actionLogin()
    }
    
    
    func actionLogin() {
        if callBack != nil {
            self.callBack!(.submit, true)
        }
        dataManager.sendRequest(login: loginTextField.text!, password: passwordTextField.text!)
        dataManager.LogIn = {[weak self] (eerr) in
            DispatchQueue.main.async {
                self?.callBack!(eerr, false)
            }
        }
    }
    
    //MARK: - constraint
    
    override func viewDidLayoutSubviews() {
        
        var topSafeArea: CGFloat
        if #available(iOS 11.0, *){
            topSafeArea = view.safeAreaInsets.top
        } else {
            topSafeArea = topLayoutGuide.length
        }
        
        loginTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: topSafeArea + 30).isActive = true
        loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16).isActive = true
        loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 8).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 100).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}

//MARK: - TextFireldDelegate
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if loginButton.isEnabled {
            actionLogin()
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            if textField.text!.count == 0 {
                return false
            } else {
                return true
            }
        }
        
        if textField == loginTextField  {
            if passwordTextField.text!.isEmpty {return true}
        } else {
            if loginTextField.text!.isEmpty {return true}
        }
        
        if string == "", (textField.text!.count ) <= 1 {
            loginButton.alpha = 0.3
            loginButton.isEnabled = false
        } else {
            loginButton.alpha = 1
            loginButton.isEnabled = true
        }
        
        return true
    }
    
}

