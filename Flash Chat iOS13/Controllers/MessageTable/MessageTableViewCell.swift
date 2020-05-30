//
//  MessageTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/21/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

extension UIView{
    func roundedCorner( _ pixels:CGFloat=0.0){
        self.layer.cornerRadius = (pixels != 0.0) ? pixels : self.layer.frame.size.width / 2.0;
        self.clipsToBounds=true;
    }
}

struct MessageCellData{
    var username:String?;
    var avatar:UIView?;
    var name:UILabel?;
    var color:UIColor?;
    var DP:UIImageView?;
}

class MessageTableViewCell: UITableViewCell {

   var message:Message?;
    var currentUser:User?;
    var otherUser:User?;
    var UDPOne:UIImage?;
    var UDPTwo:UIImage?;
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var AvatarView: UIView!
    @IBOutlet weak var AvatarName: UILabel!
    @IBOutlet weak var AvatarTwo: UIView!
    @IBOutlet weak var AvatarTwoName: UILabel!
    @IBOutlet weak var FriendImage: UIImageView!
    @IBOutlet weak var DPOne: UIImageView!
    @IBOutlet weak var DPTwo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    
    
    let timeformatter = DateFormatter();
    
    func updateMessage(_ message:Message, _ CUser:User, _ OUser:User){
        self.message = message;
        self.currentUser = CUser;
        self.otherUser = OUser;
        self.updateUI();
    }
    
    func resetAllProprety(){
        self.messageLabel.text = "";
        self.timeStamp.text = "";
    }
    
    func updateUI(){

            if let safeMessage = self.message {
                self.messageLabel.text = safeMessage.messageBody;
                self.timeStamp.text = safeMessage.timeStamp;
                guard let sender = safeMessage.sender, let receiver = safeMessage.reciever, let currentUser = self.currentUser , let otherUser = self.otherUser else {return}
                self.updateUserIcon((sender.sender == currentUser.emailID) ? currentUser : otherUser)
        }
    }
    
    func updateUserIcon(_ sender:User){
        var avatar:UIView;
        var name:UILabel;
        var color:UIColor;
        var username:String;
        var UDP:UIImageView;
        if sender.emailID == self.currentUser?.emailID{
            self.AvatarTwo.isHidden = true;
            self.AvatarTwoName.isHidden = true;
            self.DPTwo.isHidden = true;
            avatar = self.AvatarView;
            name = self.AvatarName;
            color = .systemBlue;
            UDP = self.DPOne;
        }
        else{
            self.AvatarView.isHidden = true;
            self.AvatarName.isHidden = true;
            self.DPOne.isHidden = true;
            avatar = self.AvatarTwo
            name = self.AvatarTwoName;
            color = .systemGray;
            UDP = self.DPTwo;
        }
        username = sender.name as! String;
        if let url = sender.ProfileImage, url != ""{
            UDP.downloadImage(url);
            UDP.roundedCorner(20.0);
            avatar.isHidden = true;
            name.isHidden = true;
         }else{
            avatar.roundedCorner();
            name.text = String(Array(username)[0]).uppercased();
        }
            self.messageView.backgroundColor = color;
            self.messageView.roundedCorner(10.0);
            
        
            
    }
    
}
