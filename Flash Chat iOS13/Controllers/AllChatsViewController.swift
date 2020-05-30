//
//  AllChatsViewController.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/22/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class AllChatsViewController: UIViewController {

    @IBOutlet weak var allChatsTable: UITableView!
    var userName:String?;
    var userEmailID:String?;
    var Friends:[User]?;
    var CurrentUser:User?;
    var currentUserDP:UIImage?;
    var userManager:UserManager?;
    var selectedFrnd:User?;
    var chatFriends:[User]?;
    var timeFormatter = DateFormatter();
    var imageCache = NSCache<NSString,UIImage>();
    override func viewDidLoad() {
        super.viewDidLoad();
        self.timeFormatter.timeStyle = .medium;
        self.timeFormatter.dateStyle = .medium;
        self.allChatsTable.register(UINib(nibName: K.chatcellNibName, bundle: nil), forCellReuseIdentifier: K.chatcellIdentifier);
        self.allChatsTable.dataSource = self;
        self.allChatsTable.delegate = self;
        self.setupUserManager();
        self.setupNavBarItem();
        if self.Friends?.count ?? 0 > 0{
            self.allChatsTable.reloadData();
        }
        // Do any additional setup after loading the view.
    }
    
    func setupNavBarItem(){
        self.navigationItem.setHidesBackButton(true, animated: false);
        var logoutButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.UserInfo))
        var addbutton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus.fill"), style: .plain, target: self, action: #selector(self.AddFrndSegue));
        var newMessageButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(self.NewMessageSegue))
        self.navigationItem.rightBarButtonItems = [newMessageButton,addbutton];
        self.navigationItem.leftBarButtonItem =  logoutButton;
        self.navigationController?.navigationBar.prefersLargeTitles = true;
    }
    
    
    func logout(){
        do{
            try Auth.auth().signOut();
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true);
        }catch let signoutError as NSError{
            print("there is was an error while loggin out\(signoutError)");
        }
        
    }
    
    func setupUserManager(){
        guard let userManager = self.userManager else {return}
        userManager.delegate = self;
    }
    
    @objc func NewMessageSegue(){
        print("This function works just fine");
        self.performSegue(withIdentifier: K.newMessageSegue, sender: self)
    }
    
    @objc func AddFrndSegue(){
        self.performSegue(withIdentifier: K.addSegue, sender: self)
    }
    
    @objc func UserInfo(){
        self.performSegue(withIdentifier: K.userInfoSegue, sender: self);
    }
    
    func updateCurrentUser(_ UM:UserManager, _ thisUser:User, _ friends:[User]){
        DispatchQueue.main.async {
            self.userManager = UM;
            self.CurrentUser = thisUser;
            self.Friends = friends;
            self.allChatsTable.reloadData();
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.addSegue{
            let destination = segue.destination as! AddFriendsViewController;
            destination.delegate = self;
        }else if segue.identifier == K.ChatSegue{
            let destination = segue.destination as! ChatViewController;
            destination.delegate = self;
            destination.updateDetails(self.CurrentUser!,self.selectedFrnd!,self.userManager!)
        }else if segue.identifier == K.newMessageSegue{
            let destination = segue.destination as! NewMessageViewController;
            destination.delegate = self;
            destination.updateAllFriends(self.Friends ?? [])
        }else if segue.identifier == K.userInfoSegue{
            let destination = segue.destination as! UserInfoViewController;
            destination.delegate = self;
            destination.updateUserInfo(self.CurrentUser!)
        }
        
    }
    
    func findSpeakUsers() -> Array<User>{
        var friends:Array<User> = [];
        if let UF = self.Friends , let LMF = self.CurrentUser?.latestMessages{
            let LM = Array(LMF.values).sorted { (M1, M2) -> Bool in
                self.timeFormatter.date(from: M1.timeStamp)!.compare(self.timeFormatter.date(from: M2.timeStamp)!) == .orderedAscending
            }
            friends = UF.filter({ (user) -> Bool in
                return LMF.keys.contains(user.emailID)
            })
        }
        return friends
        
    }
}

// MARK: - TableView

extension AllChatsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let count = self.Friends?.count else {return 1}
        return self.findSpeakUsers().count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friends = self.findSpeakUsers();
        let user = friends[indexPath.row];
        var image:UIImage?;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.chatcellIdentifier , for:indexPath) as! UserChatTableViewCell;
        var LM = self.CurrentUser?.latestMessages[user.emailID]!;
        cell.updateUserDetails(user, LM!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userFriend = self.findSpeakUsers()[indexPath.row];
        self.selectedFrnd = userFriend;
        self.performSegue(withIdentifier: K.ChatSegue, sender: self);
    }

}

// MARK: - UserManager
extension AllChatsViewController:UserUpdates{
   
    func updateFriends(_ friends: [User]) {
            DispatchQueue.main.async{
                if let Friends = self.Friends{
                    for friend in friends{
                        if !(Friends.contains(where: { (user) -> Bool in
                            return user.emailID == friend.emailID
                        })){
                            self.Friends?.append(friend)
                        }
                    }
                }
                else{
                    self.Friends = friends;
                }
                self.chatFriends = self.findSpeakUsers();
               self.allChatsTable.reloadData();
            }
            
        }
}

// MARK: - AddFriends

extension AllChatsViewController:AddFriend{
    func updateFriends(_ friendEmail: String) {
        self.CurrentUser?.friends.append(friendEmail);
        self.userManager?.addFriends(self.CurrentUser?.friends ?? []);
    }
    
    
}

// MARK: - UpdateFromChatView

extension AllChatsViewController:UpdateFromChatView{
    func updateUser() {
        self.CurrentUser = self.userManager?.thisUser;
        self.allChatsTable.reloadData();
    }
}

// MARK: - ChoosenUser

extension AllChatsViewController: ChoosenUser{
    func updateChoosenUser(_ user: User) {
        self.selectedFrnd = user
        self.performSegue(withIdentifier: K.ChatSegue, sender: self)
    }
    
    
}

// MARK: - CurrentUserInfo

extension AllChatsViewController: UserInfoUpdate{
    
    func logoutUser(){
        self.logout();
    }
    
    func updateUserProfileImage(_ DP: UIImage) {
        self.userManager?.uploadUserImage(DP);
    }
}
