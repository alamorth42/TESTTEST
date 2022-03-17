//
//  UIViewController+Extension.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 02/02/2022.
//

import UIKit

extension UIViewController {
    
    // MARK: - Fonction permettant d'afficher une notification à l'utilisateur.
    // MARK: - Function to display a notification to the user.
    func displayAlertError(title: String? = nil, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    // MARK: - Fonction pour fermer le clavier.
    // MARK: - Function to close the keyboard.
    func closeKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
