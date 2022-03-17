//
//  User.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 04/02/2022.
//

import UIKit
import FirebaseDatabase

class User {
    
    private var _ref: DatabaseReference!
    private var _id: String!
    private var _username: String!
    private var _email: String!
    private var _imageUrl: String!
    private var _abonnes: [String]!
    private var _abonnements: [String]!
    
    var ref: DatabaseReference { return _ref }
    var id: String { return _id }
    var username: String { return _username }
    var email: String { return _email }
    var imageUrl: String { return _imageUrl }
    var abonnes: [String] { return _abonnes }
    var abonnements: [String] {return _abonnements}
    
    init(snapchot: DataSnapshot) {
        guard let dictionarySnapshotValue = snapchot.value as? [String: AnyObject] else { return }
        self._ref = snapchot.ref
        self._id = snapchot.key
        self._username = dictionarySnapshotValue["username"] as? String ?? ""
        self._email = dictionarySnapshotValue["email"] as? String ?? ""
        self._imageUrl = dictionarySnapshotValue["imageUrl"] as? String ?? ""
        self._abonnes = dictionarySnapshotValue["abonnes"] as? [String] ?? []
        self._abonnements = dictionarySnapshotValue["abonnements"] as? [String] ?? []
    }
}
