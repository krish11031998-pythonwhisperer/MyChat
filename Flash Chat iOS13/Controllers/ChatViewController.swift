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

class DateLabel : UILabel{
    
    override var intrinsicContentSize: CGSize{
        var originalSize = super.intrinsicContentSize;
        self.roundedCorner((originalSize.height + 12)/2)
        return CGSize(width: originalSize.width+16 , height: originalSize.height+12);
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
    var timeStamps:[String] = [];
    var timeStampedMessages:[String:[Message]]?;
    var TSM:[[Message]]?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.delegate = self;
        self.chatTableView.dataSource = self;
        self.messageTextfield.delegate = self;
        self.navigationItem.setHidesBackButton(true, animated: false);
        self.navigationItem.title = self.receiver?.name ?? "User";
        if let NC = self.navigationController?.navigationBar{
            NC.barTintColor = .orange
            NC.largeTitleTextAttributes = [.foregroundColor:UIColor.white];
        }else{
            print("No NC");
        }
//        self.navigationController?.navigationBar.barTintColor = .black;
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
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
    
    func sortAllMessages(){
        self.TSM  = [];
        self.timeStampedMessages = [:]
        if let safeMessages = self.allMessages{
            var timeFormatter = DateFormatter();
            timeFormatter.dateStyle = .medium;
            timeFormatter.timeStyle = .medium;
            safeMessages.forEach { (Message) in
                var time = Message.timeStamp.components(separatedBy: "at")[0];
                if !self.timeStamps.contains(time){
                    self.timeStamps.append(time);
                }
                if self.timeStampedMessages != nil{
                    if self.timeStampedMessages?[time] != nil{
                        self.timeStampedMessages?[time]?.append(Message);
                    }else{
                        self.timeStampedMessages?[time] = [Message];
                    }
                }else{
                    self.timeStampedMessages = ["\(time)":[Message]]
                }
                
            }
            
            self.timeStamps.sort { (T1, T2) -> Bool in
                return timeFormatter.date(from: T1)?.compare(timeFormatter.date(from: T2)!) == .orderedAscending;
            }
            self.timeStamps.forEach { (time) in
//                if self.TSM != nil{
                    self.TSM?.append(self.timeStampedMessages?[time] as! [Message]);
//                }else{
//                    self.TSM = [self.timeStampedMessages?[time] as! [Message]]
//                }
                
            }
        }
        
    }


}

// MARK: - UITableDelegate, UITableDataSource

extension ChatViewController : UITableViewDelegate ,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let safeMessages = self.allMessages else {return 0}
//        return safeMessages.count;
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.TSM?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.timeStamps.count > 0 && self.timeStamps.count >= section{
            var view = UIView();
            var label = DateLabel();
            label.text = self.timeStamps[section];
            label.textColor = .black;
            label.textAlignment = .center;
            label.roundedCorner(12.0);
            label.textColor = .white;
            label.translatesAutoresizingMaskIntoConstraints = false;
            
            view.addSubview(label);
            label.backgroundColor = .systemGreen;
            
            var contraints = [
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ];
            
            NSLayoutConstraint.activate(contraints);
            return view;
        }else{
            return UIView();
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.TSM?[section].count ?? 0
    
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let safeMessages = self.allMessages, let sender = self.sender, let receiver = self.receiver else { return UITableViewCell()}
//        var message = safeMessages[indexPath.row];
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell;
//        cell.messageLabel.text = message.messageBody ?? "Test";
//        cell.updateCell(message, sender, receiver);
//        return cell;
        guard let safeTSM = self.TSM, let sender = self.sender, let receiver = self.receiver else {return UITableViewCell()}
        var message = safeTSM[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell;
        cell.messageLabel.text = message.messageBody ?? "Test";
        cell.updateCell(message, sender, receiver);
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
            self.sortAllMessages();
            self.chatTableView.reloadData();
            if let TSM = self.TSM , messages.count > 0{
                var section = TSM.count - 1;
                var row = TSM[section].count - 1;
                let indexPath = IndexPath(row: row , section: section)
                self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
    }
}
