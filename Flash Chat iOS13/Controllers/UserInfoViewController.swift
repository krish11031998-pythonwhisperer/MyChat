//
//  UserInfoViewController.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/26/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

protocol UserInfoUpdate {
    func logoutUser();
    func updateUserProfileImage(_ DP:UIImage)
}

extension UserInfoUpdate{
    func updateUserProfileImage(_ DP:UIImage){
        print("No DP available!");
    }
}

class UserInfoViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var BackGroundImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var EmailIDLabel: UILabel!
    @IBOutlet weak var Logout: UIButton!
    var delegate:UserInfoUpdate?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImagePicker();
        // Do any additional setup after loading the view.
    }
    var updatedDP:UIImage?;
    @IBAction func LogoutPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.logoutUser();
        }
    }
    
    @IBAction func UpdateUser(_ sender: UIButton) {
        self.dismiss(animated: true) {
            guard let safeUDP = self.updatedDP else {return}
            self.delegate?.updateUserProfileImage(safeUDP);
        }
    }
    
    func setupImagePicker(){
        self.BackGroundImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleImagePicker)));
        self.BackGroundImage.isUserInteractionEnabled = true;
    }
    
    @objc func handleImagePicker(){
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.allowsEditing = true;
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func updateUserInfo(_ user:User){
        DispatchQueue.main.async {
            self.UserName.text = user.name;
            self.EmailIDLabel.text = user.emailID;
            if let imageURL = user.ProfileImage , imageURL != ""{
                self.BackGroundImage.downloadImage(imageURL)
                self.BackGroundImage.contentMode = .scaleAspectFill
                self.BackGroundImage.roundedCorner(50.0);
            }else{
                self.BackGroundImage.image = UIImage(systemName: "person.fill");
            }
        }
        
    }

}


extension UserInfoViewController:UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel");
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage:UIImage?;

        if let edittedImage = info[.editedImage] as? UIImage{
            selectedImage = edittedImage;
        }else if let originalImage = info[.originalImage] as? UIImage{
            selectedImage = originalImage;
        }

        if let SImage = selectedImage{
            self.updatedDP = SImage;
            self.BackGroundImage.image = SImage;
            self.BackGroundImage.roundedCorner(50.0)
        }

        self.dismiss(animated: true, completion: nil)
    }
}
