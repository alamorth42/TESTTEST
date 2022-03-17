//
//  RemarkTableViewCell.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 10/02/2022.
//

import UIKit

class RemarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var remarkLabel: UILabel!
    
    static let identifier = "DestinationRemarkCell"
    var remark: Remark!
    
    
    func configure(remark: Remark) {
        self.remark = remark
        usernameLabel.text = self.remark.user.username
        profilImageView.dowloadImage(imageUrl: self.remark.user.imageUrl)
        remarkLabel.text = self.remark.text
    }
    
    
}
