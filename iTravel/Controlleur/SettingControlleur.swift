//
//  SettingControlleur.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 06/02/2022.
//

import UIKit
import FirebaseAuth


class SettingControlleur: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var changePhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilImageView.dowloadImage(imageUrl: USER.imageUrl)
        usernameTextField.text = USER.username
    }
    
    @IBAction func logountAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: Segues.logoutToLogin, sender: nil)
        } catch {
            self.displayAlertError(title: "Ouch", message: "An error has occurred, try again")
        }
    }
    
    @IBAction func updateAction(_ sender: Any) {
        if usernameTextField.text != nil {
            updateNameAndProfilImage(username: usernameTextField.text!)
        }
    }
    
    @IBAction func updateImageProfil(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        changePhotoButton.isHidden = true
        activityIndicator.color = .black
        activityIndicator.startAnimating()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.originalImage] as? UIImage {
                self?.profilImageView?.image = image
                self?.profilImageView?.contentMode = .scaleAspectFill
            }
            self?.changePhotoButton.isHidden = false
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func sendToStorage() {
        guard profilImageView.image != nil, let data = profilImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        Stockage().addImage(reference: Reference().myProfilImage, data: data) { (success, urlString) -> (Void) in
            guard let resultat = success, resultat == true, urlString != nil  else { return }
            BDD().updateUser(dictionary: ["imageUrl": urlString! as AnyObject], completion: { (user) -> (Void) in
                if user != nil {
                    USER = user!
                }
            })
        }
    }
    
    
    // J'ai ajouté cela car tu faisais 2 call et ca les rappelais en boucle
    func updateNameAndProfilImage(username: String) {
        guard profilImageView.image != nil, let data = profilImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        Stockage().addImage(reference: Reference().myProfilImage, data: data) { (success, urlString) -> (Void) in
            guard let resultat = success, resultat == true, urlString != nil  else { return }
            BDD().updateUser(dictionary: ["imageUrl": urlString! as AnyObject, "username": username as AnyObject], completion: { (user) -> (Void) in
                if user != nil {
                    USER = user!
                    self.displayAlertError(title: "Great", message: "You have succefully update your username and your profil picture")
                }
            })
        }
    }
}
