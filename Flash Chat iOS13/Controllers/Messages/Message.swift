//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/21/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation

class Message{
    var messageBody:String;
     var timeStamp:String;
     var sender:MessageSender?;
     var reciever:MessageSender?;
     
     init(_ message:String, _ time:String, sender:MessageSender?=nil, reciever:MessageSender?=nil){
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
    
    static func parseDict(_ MDict:[String:String]) -> Message{
        var M = Message(MDict["messageBody"] as! String, MDict["timeStamp"] as! String, sender: MessageSender(sender: MDict["sender"] as! String), reciever: MessageSender(sender: MDict["receiver"] as! String));
        return M;
    }
    
    func asDict() -> [String:String]{
        guard let sender = self.sender?.sender , let receiver = self.reciever?.sender else {return [:]}
        return ["messageBody":self.messageBody,"timeStamp":self.timeStamp,"sender":sender,"receiver":receiver]
    }
    
    static func checkMessages(_ M1:Message, _ M2:Message) -> Bool{
        return (M1.messageBody == M2.messageBody && M1.timeStamp == M2.timeStamp && M1.sender?.sender == M2.sender?.sender && M1.reciever?.sender == M2.reciever?.sender)
    }
     
    static func checkMessageinMessages(messages:[Message], searchMessage:Message) -> Bool{
        for message in messages{
            if Message.checkMessages(message, searchMessage){
                return true
            }
        }
        return false
    }
}
