//
//  UIImageView+Extension.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 09/02/2022.
//

import UIKit
import SDWebImage

extension UIImageView {
    func dowloadImage(imageUrl: String?) {
        guard let string = imageUrl, string != "", let url = URL(string: string) else { return }
        sd_setImage(with: url, completed: nil)
    }
  
    func downloadImagee(imageUrl: String, contentMode: UIView.ContentMode) {
        guard let url = NSURL(string: imageUrl) else {return}
        URLSession.shared.dataTask(with: url as URL, completionHandler: {
            (data, response, error) -> Void in
            
            print(data)
            print(response)
            print(error)
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                self.image = UIImage(data: data!)
                
                //if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
