//
//  NewTripControlleur.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 06/02/2022.
//
import UIKit

class NewTripControlleur: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonPhoto: MainButton!
    @IBOutlet weak var buttonPublish: MainButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonPublish.isHidden = true
        closeKeyboard()
        
    }
    
    @IBAction func importPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func next(_ sender: Any) {
        if destination.text == "" {
            displayAlertError(title: "Ouch", message: "Indicate a destination")
            return
        }
        sendToStorage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.originalImage] as? UIImage {
                self?.imageView.image = image
                self?.imageView?.contentMode = .scaleAspectFill
                self?.buttonPublish?.isHidden = false
            }
        }
    }
    
    func sendToStorage() {
        image = self.imageView.image
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        Stockage().addImage(reference: Reference().myTripImage.child(USER.id), data: data) { (success, string) in
            if let reussite = success, reussite == true, string != nil {
                let dictionary: [String: AnyObject] = [
                    "imageUrl": string! as AnyObject,
                    "id": USER.id as AnyObject,
                    "destination" : self.destination.text as AnyObject,
                    "date": Date().timeIntervalSince1970 as AnyObject,
                    "description": self.descriptionTextField.text as AnyObject,
                ]
                BDD().newTrip(dictionary: dictionary)
                self.displayAlertError(title: "Great", message: "Thank you for sharing your most beautiful photo. ♥️")
            }
            self.reset()
        }
    }
    
    func reset() {
        destination.text = ""
        imageView.image = UIImage(named: "defaultPicture")
        descriptionTextField.text = ""
        buttonPublish.isHidden = true
    }
}
