//
//  UserManager.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/22/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
protocol UserUpdates {
    func updateUser(_ thisUser:User);
    func updateFriends(_ friends:[User]);
}


extension UserUpdates{
    func updateUser(_ thisUser:User){
        print("This is a optional");
    }
    
    func updateFriends(_ friends:[User]){
        print("This is a optional firend");
    }
}

class UserManager{
    var thisUser  = User(name: "", emailID: "", friends: [], ProfileImage: nil);
    var Friends:[User]?;
    var emailID:String?;
    var userName:String?;
    let db = Firestore.firestore();
    var delegate:UserUpdates?;
    var refID:String?;
    var DPURL:String?;
    init( _ userEmailID:String,_ userName:String="") {
        self.userName = userName;
        self.emailID = userEmailID;
    }
    
    func setupUser(){
        self.findUser();
        self.getFriends();
    }
    
    func reloadUser() -> User{
        return self.thisUser;
    }
    
    func uploadUserImage(_ DP:UIImage){
        let pngData = DP.jpegData(compressionQuality: 0.75);
        guard let refID = self.refID else {return}
        let storage = Storage.storage().reference().child("\(refID)_DP.png");
        let SMD = StorageMetadata.init();
        SMD.contentType = "image/jpeg"
        if let uploadData = pngData{
            storage.putData(uploadData, metadata: SMD) { (metadata, err) in
                if let err = err{
                    print("There was an error! \(err)");
                    return
                }
                storage.downloadURL { (url, err) in
                    guard let safeURL = url else {
                        if let err = err{
                            print("There was an error while retrieving the DPURL \(err.localizedDescription)");
                        }
                        return
                    }
                    do{
                        try self.DPURL  = safeURL.absoluteString;
                        self.updateUserDP();
                    }catch{
                        print("There was an error while converting the DPURL to String");
                    }
                }
                
            }

        }
    }
        
    func findUser(){
        let ref  = self.db.collection("users").whereField("emailID", isEqualTo: self.emailID);
        ref.getDocuments { (query, err) in
                if let users = query?.documents{
                if users.count == 1{
                    let data = users[0].data();
                    self.refID = users[0].documentID;
                    self.thisUser.parseUserInfo(data);
                    print("Found the user! \(self.thisUser)")
                    self.delegate?.updateUser(self.thisUser);
                }
                else if users.count == 0{
                    print("There is no users, add users");
                    self.addUser();
                }
            }
            
        }
    }
    
    func addUser(){
        let userInfo:[String:Any] = [
            "name":self.userName,
            "emailID":self.emailID,
            "friends" : [],
            "latestMessage":[:],
            "profileImage":""
        ];
        self.thisUser.parseUserInfo(userInfo)
        var ref:DocumentReference? = nil;
        ref = db.collection("users").addDocument(data: userInfo){(error) in
            if let error = error{
                print("There was an error : \(error)");
            }
            else{
                print("Sucessfully added the user \(ref!.documentID)");
                self.delegate?.updateUser(self.thisUser);
            }
        }
        self.refID = ref?.documentID;
    }
    
    func addFriends(_ friends:[String]){
        self.thisUser.friends = friends;
        guard let safeRefId = self.refID else {return}
        var ref:DocumentReference? = nil;
        ref = db.collection("users").document(safeRefId)
        ref!.updateData([
            "friends":self.thisUser.friends
        ]){(error) in
            if let error = error{
                print("There was an error : \(error)");
            }
            else{
                print("Sucessfully added the a Friend \(ref!.documentID)");
                self.getFriends();
            }
        }
    }
    
    
    func updateLatestMessages(_ receiver:String, _ message:Message){
        if let latestMessage = self.thisUser.latestMessages[receiver]{
            if Message.checkMessages(latestMessage, message){
                return
            }
            
        }
        self.thisUser.latestMessages[receiver] = message;
        guard let safeRefID = self.refID else {return}
        let ref = self.db.collection("users").document(safeRefID);
        ref.updateData([
            "latestMessage":self.thisUser.asDict()
        ]){(err) in
            if let e = err{
                print("There was an error \(e)");
            }
            else{
                print("Sucessfully updated the document with DOCID \(safeRefID)");
                
            }
        }
    }

    
    func updateUserDP(){
        guard let safeRefID = self.refID, let safeDPURL =  self.DPURL else {return}
        self.thisUser.ProfileImage = safeDPURL;
        let ref = self.db.collection("users").document(safeRefID);
        ref.updateData([
            "profileImage": safeDPURL
        ]){(err) in
            if let err = err{
                print("There was an error \(err)");
            }
            else{
                print("Sucessfully updated the user data : \(safeRefID)");
                self.delegate?.updateUser(self.thisUser);
            }
        }
    }
    
    
    func getFriends(){
        var friends:Array<User> = [];
        let ref = self.db.collection("users");
        ref.getDocuments{ (users, err) in
            if let userDocs = users?.documents {
                for user in userDocs{
                    var userData = user.data();
                    if self.thisUser.friends.contains(userData["emailID"] as! String){
                        var friend = User();
                        friend.parseUserInfo(userData);
                        friends.append(friend);
                    }
                }
            self.delegate?.updateFriends(friends);
            }
        }
    }
}
