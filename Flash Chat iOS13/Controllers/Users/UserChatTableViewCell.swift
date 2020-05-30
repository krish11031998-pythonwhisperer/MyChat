//
//  TableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/22/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class UserChatTableViewCell: UITableViewCell {

    var UserInfo:User?;
    var LM:Message?;
    @IBOutlet weak var UserLabel: UILabel!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var CharacterAvatar: UIView!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var DPImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func updateUserDetails(_ user:User,_ LM:Message){
        self.UserInfo = user;
        self.LM = LM;
        if let url = user.ProfileImage, url != ""{
            self.CharacterAvatar.isHidden = true;
            self.UserLabel.isHidden = true;
            self.DPImage.downloadImage(url);
            self.DPImage.roundedCorner(20.0);
        }else{
            self.DPImage.isHidden = true;
        }
        self.updateUI();
    }
    
    func updateUI(){
        if let safeUserInfo = self.UserInfo, let LM = self.LM{
                self.UserLabel.text = String(Array(safeUserInfo.name)[0]);
                self.UserName.text = safeUserInfo.name;
                self.Message.text = LM.messageBody;
            self.TimeLabel.text = LM.timeStamp.components(separatedBy: "at")[1];
                self.CharacterAvatar.roundedCorner(25.0);
            }
        
    }
    
    func checkDay(TS:String) -> String{
        let day:Double = 24*3600;
        let TSFormatted = DateFormatter()
        let today = Date();
        print(TSFormatted.date(from: TS));
        if let TSF = TSFormatted.date(from: TS){
            if today.timeIntervalSince(TSF)/day > 1{
                return String(TS.components(separatedBy: "at")[0]);
            }else{
                return String(TS.components(separatedBy: "at")[1])
            }
        }
        return TS
       
    }
    
}
