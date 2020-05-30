//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/20/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//
struct K {
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageTableViewCell"
    static let registerSegue = "goToChatsFromRegister"
    static let loginSegue = "goToChatsFromLogin"
    static let chatcellNibName = "UserChatTableViewCell"
    static let chatcellIdentifier = "UserChatCell"
    static let addSegue = "goToAddFriends"
    static let ChatSegue = "goToChat"
    static let newMessageSegue = "goToNewMessage"
    static let usercellNibName = "UserTableViewCell"
    static let usercellIdentifier = "UserDetailCell"
    static let tabControllerfromLogin = "goToChatTabsFromLogin"
    static let tabControllerfromRegister = "goToChatTabsFromRegister"
    static let userInfoSegue = "goToUserInfo"
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
