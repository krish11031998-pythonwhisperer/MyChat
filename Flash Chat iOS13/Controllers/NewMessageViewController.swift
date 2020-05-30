//
//  NewMessageViewController.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/26/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

protocol ChoosenUser{
    func updateChoosenUser(_ user:User);
}

class NewMessageViewController: UIViewController {

    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var UserTable: UITableView!
    var Friends:[User] = [];
    var delegate:ChoosenUser?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UserTable.dataSource = self;
        self.UserTable.delegate = self;
        // Do any additional setup after loading the view.
        self.UserTable.register(UINib(nibName: K.usercellNibName, bundle: nil), forCellReuseIdentifier: K.usercellIdentifier);
        
    }
    
    func updateAllFriends(_ friends:[User]){
        self.Friends = friends;
    }
    
}

extension NewMessageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Friends.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = Friends[indexPath.row]
        let cell = self.UserTable.dequeueReusableCell(withIdentifier: K.usercellIdentifier, for: indexPath) as! UserTableViewCell;
        cell.updateCell(user);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.Friends[indexPath.row];
        self.dismiss(animated: true) {
            self.delegate?.updateChoosenUser(user);
        }
        
        
    }
    
}
