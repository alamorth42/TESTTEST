//
//  DestinationPostTableViewCell.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 06/02/2022.
//
import UIKit
import FirebaseAuth
import SDWebImage

class DestinationTripTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var destinationImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var numberLike: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var descriptionTrip: UILabel!
    
    
    // MARK: - Property
    static let identifier = "DestinationPostCell"
    var trip: Trip!
    

    @IBAction func likeActionButton(_ sender: Any) {
        var myLikes = trip.likes
        if let likeUser = myLikes.firstIndex(of: USER.id) {
            likeButton.setImage(UIImage(named: "like.png"), for: .normal)
            myLikes.remove(at: likeUser)
        } else {
            likeButton.setImage(UIImage(named: "liker.png"), for: .normal)
            myLikes.append(USER.id)
        }
        BDD().updateTrip(tripId: trip.id, userId: trip.user.id, dictionary: ["likes": myLikes as AnyObject])
        BDD().dowloadTrip(IdUser: trip.user.id) { trip in
            self.trip = trip
            
        }
    }
    
    func configure(trip: Trip) {
        self.trip = trip
        usernameLabel.text = trip.user.username
        destinationLabel.text = trip.destination
        numberLike.text = String(trip.likes.count)
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
