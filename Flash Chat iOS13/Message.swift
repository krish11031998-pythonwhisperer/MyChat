//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/20/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation

class Message{
    
    var messageBody:String;
    var timeStamp:Date;
    var sender:MessageSender?;
    var reciever:MessageSender?;
    
    init(_ message:String, _ time:Date, sender:MessageSender?=nil, reciever:MessageSender?=nil){
        self.messageBody = message;
        self.timeStamp = time;
        guard let sender = sender , let reciever = reciever else {return}
        self.sender = sender;
        self.reciever = reciever;
    }
    
    var displayMessage:String{
        get{
            return self.messageBody;
        }
    }
    
    
}
