//
//  Trip.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 07/02/2022.
//

import UIKit
import FirebaseDatabase

class Trip {
    
    private var _ref: DatabaseReference!
    private var _id: String!
    private var _user: User!
    private var _imageURL: String!
    private var _destination: String!
    private var _date: Double!
    private var _likes: [String]!
    private var _remark: [Remark]!
    private var _description: String!
    
    var ref: DatabaseReference { return _ref }
    var id: String { return _id }
    var user: User { return _user }
    var imageUrl: String { return _imageURL }
    var destination: String { return _destination }
    var date: Double { return _date }
    var likes: [String] { return _likes }
    var remark: [Remark] { return _remark }
    var description: String { return _description }
    
    
    init(ref: DatabaseReference, id: String, user: User, remark: [Remark], dictionary: [String: AnyObject]) {
        self._ref = ref
        self._id = id
        self._user = user
        self._imageURL = dictionary["imageUrl"] as? String ?? ""
        self._destination = dictionary["destination"] as? String ?? ""
        self._date = dictionary["date"] as? Double ?? 0
        self._likes = dictionary["likes"] as? NSArray as? [String] ?? []
        self._remark = remark
        self._description = dictionary["description"] as? String ?? ""
    }
    
    func remarks() {
        BDD().downloadRemark(ref: self._ref) { (remark) -> (Void) in
            if remark != nil {
                self._remark.append(remark!)
            }
        }
    }
}
