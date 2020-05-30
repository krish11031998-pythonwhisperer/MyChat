//
//  MessageDataManager.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/22/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

protocol MessageUpdates{
    func update(_ messages:Array<Message>);
}


class MessageDataManager{
    
    var delegate:MessageUpdates?;
    var ref:DocumentReference? = nil;
    var db = Firestore.firestore();
    var timeFormatter = DateFormatter();
    var sender:String?;
    var receiver:String?;
    var UM:UserManager?;
    init(_ sender:String , _ receiver:String, _ UM:UserManager) {
        timeFormatter.dateStyle = .medium;
        timeFormatter.timeStyle = .medium;
        self.sender = sender;
        self.receiver = receiver;
        self.UM = UM;
    }
    
    func sendData(_ data:Message){
        var ref:DocumentReference? = nil;
        self.timeFormatter.timeStyle = .medium;
        if let sender = data.sender?.sender, let receiver = data.reciever?.sender {
            ref = self.db.collection(K.FStore.collectionName).addDocument(data: [
                "sender" : "\(sender)",
                "receiver" : "\(receiver)",
                "messageBody" : "\(data.messageBody)",
                "timeStamp" : "\(data.timeStamp)"
            ]){ err in
                if let error = err{
                    print("Error while adding the document \(error)");
                }else{
                    print("The Message Data was successfully added to the database with the reference \(ref!.documentID)");
                    
                }
            }
        }
        
    }
    
    func readData(){
        guard let sender = self.sender, let receiver = self.receiver, let UM = self.UM ,let delegate = self.delegate else {return}
        let ref = self.db.collection(K.FStore.collectionName).whereField("sender", in: [sender,receiver])
        ref.addSnapshotListener{ (data,err) in
            var MessageArray:Array<Message>?;
            guard let safeData = data?.documents else {
                if let error = err{
                    print("there was an error with : \(error)");
                }
                return
            }
            MessageArray = safeData.filter({(m) in
                print(m.data());
                if let message = m.data()["receiver"] as? String{
                    return (message == receiver || message  == sender)
                }
                return false;
            }).map({ (message)->Message in
                if let safeMessage = message.data() as? [String:Any]{
                    return Message(safeMessage["messageBody"] as! String, safeMessage["timeStamp"] as! String , sender: MessageSender(sender: safeMessage["sender"] as! String), reciever: MessageSender(sender: safeMessage["receiver"] as! String));
                }
            }).filter({ return $0 != nil });
            print("This is how the messageArray looks like \(MessageArray!)");
            if var sortMessageArray = MessageArray{
                sortMessageArray.sort(by: {(messageOne,messageTwo)->Bool in
                    return self.timeFormatter.date(from: messageOne.timeStamp)!.compare(self.timeFormatter.date(from: messageTwo.timeStamp)!) == .orderedAscending
                });
                if let LM = sortMessageArray.last as? Message{
                    UM.updateLatestMessages(receiver,LM);
                }
                
                delegate.update(sortMessageArray);
            }
           
        }
        
    }
}
