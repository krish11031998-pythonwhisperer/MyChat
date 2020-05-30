//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel
extension UILabel{
    
    func wordLoop(_ word:String){
        var letterTimer:Double = 0.0;
        var count = 0;
        for letter in word{
            letterTimer = 0.1 * Double(count);
            Timer.scheduledTimer(withTimeInterval: letterTimer, repeats: false){ (timer) in
                self.text?.append(letter);
            }
            count+=1;
        }
        
    }

}

class WelcomeViewController: UIViewController {
    @IBOutlet weak var titleLabel: CLTypingLabel!
    var word = K.appName;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = word
//        self.titleLabel.wordLoop(word);
       
    }
    
    
    

}
