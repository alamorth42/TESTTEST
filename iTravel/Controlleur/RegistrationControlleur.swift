//
//  ViewController.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 02/02/2022.
//

import UIKit
import FirebaseAuth

class RegistrationController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Property
    
    // MARK: - IBOutles
    @IBOutlet weak var emailTextFild: UITextField!
    @IBOutlet weak var passwordTextFild: UITextField!
    @IBOutlet weak var userNameTextFild: UITextField!
    @IBOutlet weak var switchTermsOfPrivacy: UISwitch!
    @IBOutlet weak var profilImageView: UIImageView!
    
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        closeKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userId = Auth.auth().currentUser?.uid {
            checkUser(id: userId)
        }
    }
    
    // MARK: - IBActions
    
    // IBAction pour lancer la création du compte.
    // IBAction to start creating the account.
    @IBAction func signUpButtonAction(_ sender: Any) {
        userCreate()
    }
    
    @IBAction func importPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // IBAction pour retourner à la vue de connexion.
    // IBAction to return to the login view.
    @IBAction func signInButtonAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.toLogin, sender: nil)
    }
    
    // MARK: - Fonction permettant de créer un utilisateur.
    // MARK: - Function to create a user.
    private func userCreate() {
        guard let email = emailTextFild.text else { return }
        guard let password = passwordTextFild.text else { return }
        guard userNameTextFild.text != nil else { return }
        
        // Vérification que les textFields ne sont pas vides. Si un/les textField(s) sont vide(s), une alerte apparait à l'utilisateur.
        // Verification that the textFields are not empty. If one or more textField(s) are empty(s), an alert appears to the user.
        if emailTextFild.text == "" || passwordTextFild.text == "" || userNameTextFild.text == "" {
            displayAlertError(title: "Ouch", message: "You must enter a email and password and username.")
            // Vérification que les conditions sont acceptées, si elles ne sont pas acceptées, une alerte apparait à l'utilisateur.
            // Verification that the conditions are accepted, if they are not accepted, an alert appears to the user.
        } else if switchTermsOfPrivacy.isOn == false {
            displayAlertError(title: "Ouch", message: "You must agree to the terms to register.")
        } else {
            // Méthode Firebase pour créer un utilisateur.
            // Firebase method to create a user.
            Auth.auth().createUser(withEmail: email, password: password, completion:  { [self] (user, error) in
                if let error = error {
                    let nsErreur = error as NSError
                    // Si erreur == 17007, alors l'email de l'utilisateur est déjà utilisé. Une alerte apparait à l'utilisateur.
                    // If error == 17007, then the user's email is already in use. An alert appears to the user.
                    if nsErreur.code == 17007 {
                        self.displayAlertError(title: "Ouch", message: "Email you entered is already in use.")
                    }
                    // Si erreur == 17008, alors l'e-mail n'est pas valide. Une alerte apparait à l'utilisateur.
                    // If error == 17008, then the email is not valid. An alert appears to the user.
                    if nsErreur.code == 17008 {
                        self.displayAlertError(title: "Ouch", message: "Email is not valid")
                    }
                    // Si erreur == 17026, alors le mot de passe est considéré comme trop faible. Une alerte apparait à l'utilisateur.
                    // If error == 17026, then the password is considered too weak. An alert appears to the user.
                    if nsErreur.code == 17026 {
                        self.displayAlertError(title: "Ouch", message: "Email is not valid")
                    } else {
                        // Autres erreurs
                        // Others errors
                        self.displayAlertError(title: "Ouch", message: "An error has occurred, please try again")
                    }
                }
                // Si userNameTextField.text est différent de nil alors on met à jour USER.
                // If userNameTextField.text is different from nil then we update USER.
                if self.userNameTextFild.text != nil  {
                    
                    self.updateNameAndProfilImage(username: self.userNameTextFild.text!)
                }
                // Si userID = user.uid, alors on vérifie que l'utilisateur est bien inscris via la méthode checkUser.
                // If userID = user.uid, then we check if the user is registered via the checkUser method.
                if let userId = Auth.auth().currentUser?.uid {
                    self.checkUser(id: userId)
                }
            })
  
        }
    }
    // Si user est différent de nil, alors l'utilisateur est envoyé vers le HomeViewControlleur.
    // If user is different from nil, then the user is sent to the HomeViewController.
    func checkUser(id: String) {
        BDD().checkUser(id: id) { (user) -> (Void) in
            if user != nil {
                self.performSegue(withIdentifier: Segues.toLogin, sender: nil)
            } else {
                print("NO")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.originalImage] as? UIImage {
                self?.profilImageView?.image = image
                self?.profilImageView?.contentMode = .scaleAspectFill
            }
        }
    }
    
    func sendToStorage(username: String) {
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
        Stockage().addImage(reference: Reference().stockage.child("profil").child(Auth.auth().currentUser!.uid), data: data) { (success, urlString) -> (Void) in
            guard let resultat = success, resultat == true, urlString != nil  else { return }
            BDD().updateUser(dictionary: ["imageUrl": urlString! as AnyObject, "username": username as AnyObject], completion: { (user) -> (Void) in
                if user != nil {
                    USER = user!
                }
            })
        }
    }
    
}

