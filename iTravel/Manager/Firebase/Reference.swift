//
//  Reference.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 04/02/2022.
//
import Foundation
import FirebaseDatabase
import FirebaseStorage

class Reference {
    
    // Database
    private let database = Database.database().reference()
    let stockage = Storage.storage().reference()

    var rootUsers: DatabaseReference { return database.child("users") }
    var rootTrips: DatabaseReference { return database.child("trips") }
    var rootRemarks: DatabaseReference { return rootTrips.child("remark") }
    var myTrips: DatabaseReference { return rootTrips.child(USER.id) }
    var fullDatabase: DatabaseReference { return database }
    
    
    
    func userDatabase(id: String) -> DatabaseReference {
        rootUsers.child(id)
    }
    
    func tripDatabase(id: String) -> DatabaseReference {
        rootTrips.child(id)
    }
    
    func testData() -> DatabaseReference {
        database
    }
    
    func tripsUser(id: String) -> DatabaseReference {
        rootTrips.child(id)
    }
    
    func trip(key: String, value: String) -> DatabaseReference {
        tripsUser(id: value).child(key)
    }
    
    func remarkForRef(ref: DatabaseReference) -> DatabaseReference {
        ref.child("remarks")
    }
    
    func removeTrip(tripId: String) -> DatabaseReference {
        myTrips.child(tripId)
    }
    
    // Stockage
    var rootTripsImages: StorageReference { return stockage.child("trip")}
    var rootProfilImages: StorageReference { return stockage.child("profil")}
    var myProfilImage: StorageReference { return rootProfilImages.child(USER.id)}
    var myTripImage: StorageReference { return rootTripsImages.child(USER.id) }
    
}
