//
//  MainButton.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 02/02/2022.
//

import UIKit

class MainButton: UIButton {
    
    private let cornerRadius: CGFloat = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButton()
    }
    
    private func configureButton() {
        layer.cornerRadius = cornerRadius
    }
    
}
