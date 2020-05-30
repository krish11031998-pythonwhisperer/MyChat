//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
class RegisterViewController: UIViewController {

    var userManager:UserManager?;
    var user:User?;
    var friends:[User]?;
    var emailID:String?;
    var userName:String?;
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    
    override func viewDidLoad() {
        self.nameTextField.setupElement("Name",5.0);
        self.emailTextfield.setupElement("Email",5.0);
        self.passwordTextfield.setupElement("Password",5.0);
        self.RegisterButton.setupElement("Register",5.0);
//        self.emailTextfield.roundedCorner();
//        self.passwordTextfield.roundedCorner();
//        self.RegisterButton.roundedCorner();
//        self.RegisterButton.titleLabel?.text = "Register";
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        print("Registering the user !");
        if let email = self.emailTextfield.text, let password = self.passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password){ (authResult,error) in
                guard let user = authResult?.user else {
                    if let error = error{
                        print("There is an error while creating the user, with Error : \(error.localizedDescription)");
                    }
                    return
                }
                self.emailID = user.email!;
                self.userManager = UserManager(self.emailID!, self.nameTextField.text ?? "User");
                self.userManager?.delegate = self;
                self.userManager?.findUser();
            }
        }
        
        
    }
    
    func PerformSegue(){
        if let user = self.user{
            self.performSegue(withIdentifier: K.registerSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.registerSegue{
            let destination = segue.destination as! AllChatsViewController;
            if let safeUser = self.user,let safeUserManager = self.userManager{
                destination.updateCurrentUser(safeUserManager,safeUser,[]);
            }
        }
    }
    
    
}


extension RegisterViewController: UserUpdates{
    
    func updateUser(_ thisUser: User) {
        self.user = thisUser;
        self.PerformSegue();
    }
    
}
