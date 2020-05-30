//
//  User.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/22/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import UIKit

struct User{
    var name:String="";
    var emailID:String="";
    var friends:[String]=[];
    var latestMessages:[String:Message] = [:];
    var ProfileImage:String?;
    
    mutating func parseUserInfo(_ data:[String:Any]){
        self.name = data["name"] as? String ?? "User";
        self.emailID = data["emailID"] as? String ?? "a@b.com";
        self.friends = data["friends"] as? [String] ?? [""];
        self.latestMessages = (data["latestMessage"] as? [String:[String:String]])!.mapValues({(dict) in
            return Message(dict["messageBody"]!, dict["timeStamp"]!, sender: MessageSender(sender: dict["sender"]!), reciever: MessageSender(sender: dict["receiver"]!))
        });
        self.ProfileImage = data["profileImage"] as! String;
    }
    
    func asDict() -> [String:[String:String]]{
        return self.latestMessages.mapValues({$0.asDict()});
    }
}
