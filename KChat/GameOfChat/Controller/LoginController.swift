//
//  LoginController.swift
//  GameOfChat
//
//  Created by ChandlerZou on 2018/10/2.
//  Copyright © 2018 zouhuanlin. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController {
    
    
    let inputContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
   
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
  
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        
    }
    
    @objc private func handleRegister(){
        print("123")
        guard let email = emailTextField.text, let password = passwordTextField.text,let name = nameTextField.text else{
            print("form invalid")
            return
        }
    
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error{
                print("Something wrong \(error)")
                return
            }
            guard let user = authResult?.user else{
                return
            }
            
            let ref = Database.database().reference()
            let userRef = ref.child("users").child(user.uid)
            let values = ["names": name, "email": email]
            userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err{
                    print(err)
                    return
                }
                print("Saved successfully")
            })
            
        }
    }
    
    func setupProfileImageView(){
        NSLayoutConstraint.activate([profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)])
    }
    
    
    func setupInputsContainerView(){
        NSLayoutConstraint.activate([inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            inputContainerView.heightAnchor.constraint(equalToConstant: 150)])
        inputContainerView.addSubview(nameTextField)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTextField)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 0),
            nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)])
        
        NSLayoutConstraint.activate([nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor),
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)])
        //email
        NSLayoutConstraint.activate([emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12),
                                     emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0),
                                     emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
                                     emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)])
        
        NSLayoutConstraint.activate([emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor),
                                     emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
                                     emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
                                     emailSeparatorView.heightAnchor.constraint(equalToConstant: 1)])
        
        // password
        NSLayoutConstraint.activate([passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12),
                                     passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0),
                                     passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
                                     passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)])
        
    }
    
    func setupLoginRegisterButton(){
        NSLayoutConstraint.activate([loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 50)])
    }
        
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }

    

}

extension UIColor{
    convenience init(r: CGFloat,g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
}
