//
//  NewMessageViewController.swift
//  GameOfChat
//
//  Created by ChandlerZou on 2018/10/3.
//  Copyright © 2018 zouhuanlin. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    let cellId = "cellid"
    
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapShot) in
            if let dic = snapShot.value as? [String: Any] {
                let user = User(dictionary: dic)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(user.name,user.email)
            }
            
        }, withCancel: nil)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier:
//        cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
//        cell.imageView?.image = UIImage(named: "nedstark")
//        cell.imageView?.contentMode = .scaleAspectFill
        if let profileImageUrl = user.profileImageURL{
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error{
                    print(error)
                    return
                }
                DispatchQueue.main.async {
//                    cell.imageView?.image = UIImage(data: data!)
                }
            }
        }
        return cell
    }


}

class UserCell: UITableViewCell{
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nedstark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        
        //constraint
        NSLayoutConstraint.activate([profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40)])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 56, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
}
