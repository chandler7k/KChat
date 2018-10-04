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
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapShot) in
                
                if let dic = snapShot.value as? [String: Any]{
                    self.navigationItem.title = dic["names"] as? String
                }
//                self.navigationItem.title =
                print(snapShot)
            }, withCancel: nil)
            
            
        }
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
        present(loginController, animated: true, completion: nil)
    }


}

