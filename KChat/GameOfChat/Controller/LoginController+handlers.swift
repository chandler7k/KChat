//
//  LoginController+handlers.swift
//  GameOfChat
//
//  Created by ChandlerZou on 2018/10/4.
//  Copyright © 2018 zouhuanlin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func handleRegister(){
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
            guard let uid = authResult?.user.uid else{
                return
            }
            
            let imageName = UUID().uuidString
            let storegeRef = Storage.storage().reference().child("\(imageName).jpg")
            
            
            if let profileImage = self.profileImageView.image,let uploadData = profileImage.jpegData(compressionQuality: 0.1){
                storegeRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    guard let metadata = metadata else{
                        return
                    }
                    let size = metadata.size
                    print(size)
                    if let error = error{
                        print(error)
                    }
                    
                    storegeRef.downloadURL(completion: { (url, error) in
                        guard let url = url else{
                            return
                        }
                        let profileImageUrl = url.absoluteString
                        if let error = error{
                            print(error)
                            return
                        }
                        
                        let values = ["names": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabase(uid: uid, values: values)
                        
                    })
                    print(metadata)
                })
            }
        }
    }
    
    private func registerUserIntoDatabase(uid: String, values:[String:Any]){
        let ref = Database.database().reference()
        let userRef = ref.child("users").child(uid)
        
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err{
                print(err)
                return
            }
            self.dismiss(animated: true, completion: nil)
            self.messageController?.fetchUserAndSetUpNavBarTitle()
            print("Saved successfully")
        })
    }
    
    @objc func handleSelectedProfileImageView(){
        print(123)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage]{
            selectedImageFromPicker = editedImage as? UIImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage]{
            selectedImageFromPicker = originalImage as? UIImage
            print(originalImage)
        }
        
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        print(info)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
