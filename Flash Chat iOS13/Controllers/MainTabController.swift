//
//  MainTabController.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/26/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    var um:UserManager?;
    var user:User?;
    var friends:[User]?;
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
    }
    
    func updateCurrentUser(_ um:UserManager, _ user:User , _ friends:[User]){
        self.um = um;
        self.user = user;
        self.friends = friends;
        self.performSegue(withIdentifier: K.ch, sender: <#T##Any?#>)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
