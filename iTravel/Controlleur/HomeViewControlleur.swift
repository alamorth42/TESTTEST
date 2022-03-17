//
//  HomeViewControlleur.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 06/02/2022.
//
import UIKit
import Firebase
import FirebaseAuth

class HomeViewControlleur: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var trips = [Trip]()
    private var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationItem.titleView = imageView
        dowloadFullTrips()
        closeKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    dowloadFullTrips()
    tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? RemarkViewControlleur else { return }
        destination.trip = trip
    }
    
    func dowloadFullTrips() {
        var users = [User]()
        BDD().downloadFullUsers { (user) in
            if let user = user {
                if let index = users.firstIndex(where: {$0.id == user.id}) {
                    users[index] = user
                } else {
                    users.append(user)
                }
                for user in users {
                    BDD().dowloadTrip(IdUser: user.id) { (trip) -> (Void) in
                        if trip != nil {
                            self.checkTripPresent(trip: trip!)
                        }
                    }
                }
            }
        }
    }
    
    func trierEtReload() {
        self.trips = self.trips.sorted(by: {$0.date > $1.date})
        tableView.reloadData()
    }
    
    func checkTripPresent(trip: Trip) {
        if let index = self.trips.firstIndex(where: {$0.id == trip.id}) {
            self.trips[index] = trip
        } else {
            self.trips.append(trip)
        }
        self.trierEtReload()
    }
}


extension HomeViewControlleur: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DestinationTripTableViewCell.identifier, for: indexPath) as! DestinationTripTableViewCell
        cell.configure(trip: trips[indexPath.row])
        return cell
    }
}

extension HomeViewControlleur: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trip = trips[indexPath.row]
        performSegue(withIdentifier: Segues.toRemark, sender: nil)
    }
}
