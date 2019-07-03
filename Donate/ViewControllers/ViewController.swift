//
//  ViewController.swift
//  Donate
//
//  Created by Guillermo Moraleda on 02.07.19.
//  Copyright © 2019 Guillermo Moraleda. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var reservationContainers = [INSpeakableString]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        reservationContainers = ReservationsManager.sharedInstance.reservationContainers()
    }
    
    private func showReservation(_ reservation: INReservation) {
        let storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
            as? DetailViewController {
            detailViewController.reservation = reservation
            show(detailViewController, sender: self)
        }
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let reservation = ReservationsManager.sharedInstance.reservation(withItemReference: reservationContainers[indexPath.row]) {
            showReservation(reservation)
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationContainers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { fatalError() }
        cell.textLabel?.text = reservationContainers[indexPath.row].spokenPhrase
        return cell
    }
}
