//
//  ProfileControlleur.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 06/02/2022.
//

import UIKit
import SwiftUI
import Firebase

class MyTripControlleur: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trips = [Trip]()
    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 50, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        self.navigationItem.titleView = imageView
        dowloadMyFullTrips()
        closeKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dowloadMyFullTrips()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? RemarkViewControlleur else { return }
        destination.trip = trip
    }
    
    
    func dowloadMyFullTrips() {
        BDD().dowloadTrip(IdUser: USER.id) { (trip) -> (Void) in
            if trip != nil {
                self.checkTripPresent(trip: trip!)
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

extension MyTripControlleur: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
        cell.configure(trip: trips[indexPath.row])
        return cell
    }
}

extension MyTripControlleur: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        self.trip = trip
        performSegue(withIdentifier: Segues.tripToRemark, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            BDD().deleteTrip(tripId: trips[indexPath.row].id)
            trips.remove(atOffsets: [indexPath.row])
            tableView.reloadData()
        }
    }
}
