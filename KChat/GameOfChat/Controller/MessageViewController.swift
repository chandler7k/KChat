//
//  ViewController.swift
//  GameOfChat
//
//  Created by ChandlerZou on 2018/10/2.
//  Copyright © 2018 zouhuanlin. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let newMessageImage = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: .plain, target: self, action: #selector(handleNewMessage))
        //user not login
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        checkIfUserLoggedIn()
    }
    
    //MARK: - Check user logged
    func checkIfUserLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            
            fetchUserAndSetUpNavBarTitle()
            
        }
    }
    
    func fetchUserAndSetUpNavBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else{
            return 
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapShot) in
            
            if let dic = snapShot.value as? [String: Any]{
//                self.navigationItem.title = dic["names"] as? String
                let user = User(dictionary: dic)
                self.setupNavBarWithUser(user: user)
                
            }
    
            print(snapShot)
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user:User){
        self.navigationItem.title = user.name
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = UIColor.red
        titleView.translatesAutoresizingMaskIntoConstraints = true
        
        self.navigationItem.titleView = titleView
        let profileImageView = UIImageView()
        
        if let url = user.profileImageURL{
            profileImageView.loadImageWithCacheWithUrlString(urlString: url)
        }
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = true
        titleView.addSubview(profileImageView)
        NSLayoutConstraint.activate([profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor),
                                     profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
                                     profileImageView.widthAnchor.constraint(equalToConstant: 40),
                                     profileImageView.heightAnchor.constraint(equalToConstant: 40)])
        
    }
    @objc private func handleNewMessage(){
        let newMessageController = NewMessageViewController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }

    
    @objc private func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
            
        let loginController = LoginController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
    }


}

