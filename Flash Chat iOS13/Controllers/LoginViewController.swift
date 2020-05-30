//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    var user:User?;
    var friends:[User]?;
    var email:String?;
    var userManager:UserManager?;
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var allMessages:Array<Message>?;
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = self.emailTextfield.text , let password = self.passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult,error) in
                guard let strongSelf = self, let user = authResult?.user else {
                    if let error = error{
                        print("There was an error \(error.localizedDescription)");
                        
                    }
                    return
                }
                print("User with email ID : \(user.email!)");
                strongSelf.email = user.email!;
                strongSelf.userManager = UserManager(user.email!);
                strongSelf.userManager?.delegate = self;
                strongSelf.userManager?.findUser();                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.loginSegue{
            let destination = segue.destination as! AllChatsViewController;
            if let userManager = self.userManager, let user = self.user, let friends = self.friends{
                destination.updateCurrentUser(userManager,user,friends);
            }
        }
    }
    
    func PerformSegue(){
        if let user = self.user ,  let friends = self.friends{
             self.performSegue(withIdentifier: K.loginSegue, sender: self);
//            self.performSegue(withIdentifier: K.tabControllerfromLogin, sender: self)
        }
    }
}

extension LoginViewController : UserUpdates{
    
    func updateUser(_ thisUser: User) {
        self.user = thisUser;
        self.userManager?.getFriends();
    }
    
    func updateFriends(_ friends: [User]) {
        self.friends = friends;
        self.PerformSegue();
    }
}
