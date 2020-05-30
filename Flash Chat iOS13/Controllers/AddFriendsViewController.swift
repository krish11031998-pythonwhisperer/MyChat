//
//  AddFriendsViewController.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/23/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit


protocol AddFriend {
    func updateFriends(_ friendEmail:String)
}
class AddFriendsViewController: UIViewController {

    var delegate:AddFriend?;
    @IBOutlet weak var NameLabel: UITextField!
    @IBOutlet weak var EmailLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddFriend(_ sender: UIButton) {
        print(self.EmailLabel.text!);
        self.delegate?.updateFriends(self.EmailLabel.text!);
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil);
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
