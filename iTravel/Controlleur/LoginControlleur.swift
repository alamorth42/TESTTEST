//
//  LoginControlleur.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 02/02/2022.
//

import UIKit
import FirebaseAuth

class LoginControlleur: UIViewController {
    
    // Property
    @IBOutlet weak var emailTextFild: UITextField!
    @IBOutlet weak var passwordTexFild: UITextField!
    
    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        closeKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userId = Auth.auth().currentUser?.uid {
            checkUser(id: userId)
        }
    }
    
    // IBActions
    
    // IBAction pour aller à la vue d'inscription.
    // IBAction to go to registration view.
    @IBAction func signUpButtonAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.toRegistration, sender: nil)
    }
    
    // IBAction pour lancer la connexion de l'utilisateur.
    // IBAction to initiate user login.
    @IBAction func signInButtonAction(_ sender: Any) {
        userLogin()
    }
    
    // MARK: - Fonction permettant de se connecter.
    // MARK: - Function to connect.
    private func userLogin() {
        guard let email = emailTextFild.text else { return }
        guard let password = passwordTexFild.text else { return }
        // Vérification que les textFields ne sont pas vides. Si un/les textField(s) sont vide(s), une alerte apparait à l'utilisateur.
        // Verification that the textFields are not empty. If one or more textField(s) are empty, an alert appears to the user.
        if emailTextFild.text == "" || passwordTexFild.text == "" {
            displayAlertError(title: "Ouch", message: "You must enter a username and password.")
        } else {
            // Méthode Firebase pour authentifier l'utilisateur.
            // Firebase method to authenticate the user.
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    let nsErreur = error as NSError
                    // Si erreur == 17011, alors l'utilisateur n'a pas de compte. Une alerte apparait à l'utilisateur.
                    // If error == 17011, then the user does not have an account. An alert appears to the user.
                    if nsErreur.code == 17011 {
                        self.displayAlertError(title: "Ouch", message: "No account was found, please register")
                    }
                    // Si erreur == 17008, alors l'e-mail n'est pas valide. Une alerte apparait à l'utilisateur.
                    // If error == 17008, then the email is not valid. An alert appears to the user.
                    if nsErreur.code == 17008 {
                        self.displayAlertError(title: "Ouch", message: "Email is not valid")
                    }
                    // Si erreur == 17009, alors l'utilisateur a tenté de se connecter avec un mauvais mot de passe.
                    // If error == 17009,then the user attempted sign in with a wrong password.
                    if nsErreur.code == 17009 {
                        self.displayAlertError(title: "Ouch", message: "Wrong password")
                    } else {
                        self.displayAlertError(title: "ERREUR", message: "ERREUR")
                    }
                }
                // Si userID = user.uid, alors l'utilisateur est bien inscrit.
                if let userId = user?.user.uid {
                    self.checkUser(id: userId)
                }
            })
        }
    }
    
    func checkUser(id: String) {
        BDD().checkUser(id: id) { (user) -> (Void) in
            if user != nil {
                USER = user!
                self.performSegue(withIdentifier: Segues.toHome, sender: nil)
            } else {
                print("non")
            }
        }
    }
}
