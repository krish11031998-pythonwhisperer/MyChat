//
//  DownloadImages.swift
//  Flash Chat iOS13
//
//  Created by Krishna Venkatramani on 5/29/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import UIKit
var imageCache = NSCache<NSString,UIImage>();


extension UIImageView{
    
    func downloadImage(_ urlString:String){
        
        self.image = nil
        
        if let setImage = imageCache.object(forKey: urlString as! NSString){
            self.image = setImage;
            return
        }else{
            if let url = URL(string: urlString){
                URLSession.shared.dataTask(with: url) { (data, resp, err) in
                    guard let safeData = data, let downloadImage = UIImage(data: safeData) else {
                        if let err = err{
                            print("There was an error! \(err)");
                        }else{
                            print("There was an error!");
                        }
                        return;
                    }
                    DispatchQueue.main.async {
                        imageCache.setObject(downloadImage , forKey: urlString as! NSString);
                        self.image = downloadImage;
                    }
                }.resume();
            }

        }
        
        
    }
}

