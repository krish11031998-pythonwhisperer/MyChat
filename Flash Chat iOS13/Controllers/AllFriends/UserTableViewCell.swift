//
//  UserTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/26/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var AvatarView: UIView!
    @IBOutlet weak var AvatarInitial: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserDP: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ user:User){
        self.AvatarView.roundedCorner(20.0);
        self.AvatarInitial.text = String(Array(user.name)[0]);
        self.UserNameLabel.text = user.name;
        if let url = user.ProfileImage, url != ""{
            self.AvatarView.isHidden = true;
            self.AvatarInitial.isHidden = true;
            self.UserDP.downloadImage(url)
            self.UserDP.roundedCorner(20.0);
        }else{
            self.UserDP.isHidden = true;
        }
    }

    
}
