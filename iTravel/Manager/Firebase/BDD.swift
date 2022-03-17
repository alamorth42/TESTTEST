//
//  BDD.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 04/02/2022.
//
import Foundation
import FirebaseDatabase
import FirebaseAuth

class BDD {
    
    // Fonction permettant de voir si l'utilisateur existe.
    // Function to see if the user exists.
    func checkUser(id: String, completion: UserCompletion?) {
        
        Reference().userDatabase(id: id).observe(.value) { (snapshot) in
            if snapshot.exists(), let _ = snapshot.value as? [String: AnyObject] {
                
                completion?(User(snapchot: snapshot))
            } else {
                completion?(nil)
            }
        }
    }
    
    func downloadFullUsers(completion: UserCompletion?) {
        Reference().rootUsers.observe(.childAdded) { (snapshot) in
            completion?(User(snapchot: snapshot))
        }
    }
    
    // Fonction permettant d'actualiser l'utilisateur.
    //Function to refresh the user.
    func updateUser(dictionary: [String: AnyObject], completion: UserCompletion?) {
        guard let userId = Auth.auth().currentUser?.uid else { completion?(nil); return }
        Reference().userDatabase(id: userId).updateChildValues(dictionary) { (error, reference) in
            if error == nil {
                self.checkUser(id: userId, completion: { (user) -> (Void) in
                    completion?(user)
                })
            }
        }
    }
    
    func newTrip(dictionary: [String: AnyObject]) {
        Reference().myTrips.childByAutoId().updateChildValues(dictionary)
    }
    
    func newTripp(key: String) {
        Reference().myTrips.value(forKey: key)
    }
    
    func dowloadTrip(IdUser: String, complettion: TripCompletion?) {
        checkUser(id: IdUser) { (user) in
            if user != nil {
                Reference().tripsUser(id: IdUser).observe(.childAdded) { (snapshot) in
                    let tripId = snapshot.key
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let newTrip = Trip(ref: snapshot.ref, id: tripId, user: user!, remark: [], dictionary: dictionary)
                        complettion?(newTrip)
                    } else {
                        complettion?(nil)
                    }
                }
            }
        }
    }
    
    func deleteTrip(tripId: String) {
        Reference().removeTrip(tripId: tripId).removeValue()
    }
    
    func updateTrip(tripId: String, userId: String, dictionary: [String: AnyObject]) {
        Reference().trip(key: tripId, value: userId).updateChildValues(dictionary)
    }
    
    func updateTripp(tripId: String, userId: String, userTripUserId: String) {
        Reference().trip(key: tripId, value: userId).value(forKey: userTripUserId)
    }
    
    func sendRemark(ref: DatabaseReference, dictionary: [String: AnyObject]) {
        Reference().remarkForRef(ref: ref).childByAutoId().updateChildValues(dictionary)
    }
    
    func downloadRemark(ref: DatabaseReference, completion: RemarkCompletion?) {
        Reference().remarkForRef(ref: ref).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let userId = dictionary["user"] as? String {
                    self.checkUser(id: userId, completion: { (user) -> (Void) in
                        if user != nil {
                            let newRemark = Remark(ref: snapshot.ref, id: snapshot.key, user: user!, dictionary: dictionary)
                            completion?(newRemark)
                        } else {
                            completion?(nil)
                        }
                    })
                }
            } else {
                completion?(nil)
            }
        }
    }
}
