//
//  RemarkViewControlleur.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 10/02/2022.
//

import UIKit

class RemarkViewControlleur: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var trip: Trip!
    private var remarks = [Remark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = ""
        downloadRemark()
        closeKeyboard()
    }
    
    @IBAction func sendRemark(_ sender: Any) {
        if textView.text == "" {
            displayAlertError(title: "Ouch", message: "it is impossible to send an empty remark")
        } else {
            let dictionary = [
                "text": textView.text as AnyObject,
                "user": USER.id as AnyObject]
            textView.text = ""
            BDD().sendRemark(ref: trip.ref, dictionary: dictionary as [String: AnyObject])
        }
    }
    
    
    func downloadRemark() {
        BDD().downloadRemark(ref: trip.ref) { (remark) -> (Void) in
            if remark != nil {
                if let index = self.remarks.firstIndex(where: { $0.id == remark!.id }) {
                    self.remarks[index] = remark!
                } else {
                    self.remarks.append(remark!)
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension RemarkViewControlleur: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        remarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RemarkTableViewCell.identifier, for: indexPath) as? RemarkTableViewCell else { return UITableViewCell() }
        cell.configure(remark: remarks[indexPath.row])
        return cell
    }
}
