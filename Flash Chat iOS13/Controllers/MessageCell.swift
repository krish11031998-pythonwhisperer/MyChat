//
//  MesasgeCell.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/30/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    var messageLabel = UILabel();
    var bubbleBackgroundView = UIView();
    var currentUser:User?;
    var otherUser:User?;
    var message:Message?;
    var cusender:Bool = false;
    var Mleadingconstraints:NSLayoutConstraint?;
    var Mtrailingconstraints:NSLayoutConstraint?;
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier);
        self.backgroundColor = UIColor(white: 0.95, alpha: 1);
        addSubview(self.bubbleBackgroundView);
        bubbleBackgroundView.backgroundColor = .green;
        bubbleBackgroundView.roundedCorner(10)
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
        
        
        bubbleBackgroundView.addSubview(messageLabel);

        messageLabel.numberOfLines = 0;
        messageLabel.translatesAutoresizingMaskIntoConstraints = false;
        let constraints = [ messageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
                            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
                            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
                            
                            bubbleBackgroundView.topAnchor.constraint(equalTo: self.messageLabel.topAnchor, constant: -16),
                            bubbleBackgroundView.leadingAnchor.constraint(equalTo: self.messageLabel.leadingAnchor, constant: -16),
                            bubbleBackgroundView.bottomAnchor.constraint(equalTo:self.messageLabel.bottomAnchor, constant: 16),
                            bubbleBackgroundView.trailingAnchor.constraint(equalTo: self.messageLabel.trailingAnchor, constant: 16)
                            
        ]
        NSLayoutConstraint.activate(constraints);
        
        Mleadingconstraints = messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32);
        Mtrailingconstraints = messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(_ message:Message , _ CUser:User, _ OUser:User){
        self.message = message;
        self.currentUser = CUser;
        self.otherUser = OUser;
        self.updateUI();
    }
    
    func cellAlignment(_ cusender:Bool=true){
        guard let MLC = self.Mleadingconstraints, let MTC = self.Mtrailingconstraints else {return}
        MLC.isActive = !cusender;
        MTC.isActive = cusender;
//        if !cusender{
//            MLC.isActive = true;
//            MTC.isActive = false
//        }else{
//            self.messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true;
//        }
    }
    
    func updateUI(){
        guard let message = self.message, let cuser = self.currentUser, let ouser = self.otherUser else {return}
        if message.sender!.sender == cuser.emailID{
            self.bubbleBackgroundView.backgroundColor = .systemBlue;
            self.cusender = true;
        }
        else{
            self.bubbleBackgroundView.backgroundColor = .gray;
            self.cusender = false;
        }
        self.cellAlignment(cusender);
    }
}
