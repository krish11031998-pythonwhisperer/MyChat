//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

protocol UpdateFromChatView {
    func updateUser();
}

extension Date{
    func timeNow()->String{
        var timeFormatter = DateFormatter();
        timeFormatter.timeStyle = .medium;
        timeFormatter.dateStyle = .medium;
        return timeFormatter.string(from: self);
        
    }
}

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var delegate:UpdateFromChatView?;
    var allMessages:Array<Message>?;
    let db = Firestore.firestore();
    var MessageManager:MessageDataManager?;
    var sender:User?;
    var receiver:User?;
    var receiverDP:UIImage?;
    var senderDP:UIImage?;
    var userManager:UserManager?;
    var messageCache:[String:MessageTableViewCell] = [:];
    var currentUser:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.delegate = self;
        self.chatTableView.dataSource = self;
        self.messageTextfield.delegate = self;
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = self.receiver?.name ?? "User";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Chats", style: .plain, target: self, action: #selector(self.revertBack))
        self.navigationItem.rightBarButtonItem?.isEnabled = true;
        self.navigationItem.leftBarButtonItem?.isEnabled = true;
//        self.chatTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier);
        self.chatTableView.register(MessageCell.self, forCellReuseIdentifier: K.cellIdentifier);
        self.chatTableView.backgroundColor = UIColor(white: 0.95, alpha: 1);
        self.setupMessageManager();
        self.currentUser = Auth.auth().currentUser?.email ?? "a@b.com";
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
        do{
            try Auth.auth().signOut();
            self.navigationController?.popToRootViewController(animated: true);
        }catch let signOuterror as NSError{
            print("There was an error \(signOuterror)")
        }
        
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        self.messageTextfield.endEditing(true);
    }
    
    
    func setupMessageManager(){
        guard let sender  = self.sender?.emailID , let receiver = self.receiver?.emailID, let UM = self.userManager else {return}
        self.MessageManager = MessageDataManager(sender, receiver,UM);
        self.MessageManager?.delegate = self;
        self.MessageManager?.readData();
    }
    
    @objc func revertBack(){
        self.delegate?.updateUser();
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateDetails(_ sender:User, _ receiver:User, _ userManager: UserManager){
        self.sender = sender;
        self.receiver = receiver;
        self.userManager = userManager;
    }

}

// MARK: - UITableDelegate, UITableDataSource

extension ChatViewController : UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let safeMessages = self.allMessages else {return 0}
        return safeMessages.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let safeMessages = self.allMessages, let sender = self.sender, let receiver = self.receiver else { return UITableViewCell()}
        var message = safeMessages[indexPath.row];
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageTableViewCell;
//        cell.updateMessage(message, sender, receiver);
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell;
        cell.messageLabel.text = message.messageBody ?? "Test";
        cell.updateCell(message, sender, receiver);
//        cell.updateUI();
//        var user = (message.sender?.sender == sender.emailID) ? sender : receiver
//        cell.updateUserIcon(user)
        return cell;
    }
    
    
}

// MARK: - UITextFeild

extension ChatViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let sender = self.sender?.emailID , let receiver = self.receiver?.emailID , let messageManager = self.MessageManager else {return}
        if let messageBody = self.messageTextfield.text {
            let timeNow = Date().timeNow();
            let newMessage = Message(messageBody, timeNow ,sender: MessageSender(sender: sender), reciever: MessageSender(sender: receiver));
            messageManager.sendData(newMessage);
            DispatchQueue.main.async {
                self.messageTextfield.text = "";
                
            }
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.messageTextfield.text == ""{
            self.messageTextfield.placeholder = "Pls type something !";
            return false
        }else{
            self.messageTextfield.endEditing(true);
            return true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.messageTextfield.endEditing(true);
        return true;
    }
    
    
}

// MARK: - MessageUpdate

extension ChatViewController: MessageUpdates{
    func update(_ messages: Array<Message>) {
        DispatchQueue.main.async {
            if let allMessages = self.allMessages{
                for message in messages{
                    if !allMessages.contains(where: { (M) -> Bool in
                        return Message.checkMessages(M, message);
                    }){
                        self.allMessages?.append(message);
                    }
                }
                
            }else{
                self.allMessages = messages
            }
            self.chatTableView.reloadData();
            if messages.count > 0{
                let indexPath = IndexPath(row: messages.count - 1 , section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
    }
}
