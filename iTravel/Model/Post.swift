//
//  Post.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 07/02/2022.
//
import UIKit
import FirebaseDatabase

class Remark {
    
    private var _ref: DatabaseReference!
    private var _id: String!
    private var _user: User!
    private var _text: String!
    private var _date: Double!
    
    
    var ref: DatabaseReference { return _ref }
    var id: String { return _id }
    var user: User { return _user }
    var text: String { return _text }
    var date: Double { return _date }
    
    
    init(ref: DatabaseReference, id: String, user: User, dictionary: [String: AnyObject]) {
        self._ref = ref
        self._id = id
        self._user = user
        self._text = dictionary["text"] as? String ?? ""
        self._date = dictionary["date"] as? Double ?? 0
    }
    
}
