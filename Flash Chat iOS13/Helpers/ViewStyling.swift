//
//  ViewStyling.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/29/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func roundedCorners(_ pixels:CGFloat = 0.0){
        var width = self.layer.frame.width;
        self.layer.cornerRadius = pixels;
        self.clipsToBounds = true;
    }
    
    func setupElement(_ placeholder:String="", _ pixels:CGFloat=0.0){
        if let textfield = self as? UITextField{
            print("Accepting \(placeholder) as a textfield");
            textfield.roundedCorner(pixels);
            textfield.placeholder = placeholder;
        }
        else if let button = self as? UIButton{
            button.roundedCorner(pixels);
            print("Accepting \(placeholder) as a button");
            button.backgroundColor = .magenta;
            button.setTitle(placeholder, for: .normal);
            button.titleLabel?.textColor = .white;
        }
        else if let imageView = self as? UIImageView{
            imageView.roundedCorner(pixels);
            imageView.layer.masksToBounds = false;
        }
    }
}
