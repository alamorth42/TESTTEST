//
//  MainImageView.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 10/02/2022.
//

import UIKit

class MainImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
        layer.borderColor = CGColor(red: 0.96, green: 0.37, blue: 0.42, alpha: 1.00)
        layer.borderWidth = 1
    }
    
}
