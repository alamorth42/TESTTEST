//
//  MyTripTableViewCell.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 11/02/2022.
//

import UIKit

class MyTripTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var numberLike: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var descriptionTrip: UILabel!
    
    
    // MARK: - Property
    static let identifier = "MyTripViewCell"
    var trip: Trip!
    

    @IBAction func likeActionButtonMyTrip(_ sender: UIButton) {
        var myLikes = self.trip.likes
        if likeButton.imageView!.image == UIImage(named: "like.png") {
            likeButton.setImage(UIImage(named: "liker.png"), for: .normal)
            myLikes.append(USER.id)
        } else {
            if let index = myLikes.firstIndex(of: USER.id) {
                myLikes.remove(at: index)
                likeButton.setImage(UIImage(named: "like.png"), for: .normal)
                numberLike.text = String(self.trip.likes.count)
            }
        }
        BDD().updateTrip(tripId: self.trip.id, userId: self.trip.user.id, dictionary: ["likes": myLikes as AnyObject])
    }
    
    func configure(trip: Trip) {
        
        self.trip = trip
        usernameLabel.text = trip.user.username
        destinationLabel.text = trip.destination
        numberLike.text = String(self.trip.likes.count)
        descriptionTrip.text = "\(trip.user.username): \(trip.description)"
        profilImageView.dowloadImage(imageUrl: trip.user.imageUrl)
        destinationImageView.dowloadImage(imageUrl: trip.imageUrl)
        if self.trip.likes.contains(USER.id) {
            likeButton.setImage(UIImage(named: "liker.png"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like.png"), for: .normal)
        }
    }
}
