//
//  DetailViewController.swift
//  Donate
//
//  Created by Guillermo Moraleda on 02.07.19.
//  Copyright © 2019 Guillermo Moraleda. All rights reserved.
//

import UIKit
import Intents
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pickupMapView: MKMapView!
    
    var reservation: INReservation?
}

// MARK: - Lifecycle
extension DetailViewController {
    
    override func viewDidLoad() {
        guard let reservation = reservation as? INRentalCarReservation else { return }
        referenceLabel.text = reservation.reservationNumber
        makeLabel.text = reservation.rentalCar?.make
        modelLabel.text = reservation.rentalCar?.model
        statusLabel.text = reservation.reservationStatus.description
        
        pickupMapView.delegate = self
        pickupMapView.showsScale = true
        
        let placemark = MKPlacemark(placemark: reservation.pickupLocation!)
        pickupMapView.addAnnotation(placemark)
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) )
        pickupMapView.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        donateReservation()
    }
}

// MARK: - MKMapViewDelegate
extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let alertController = UIAlertController(title: "Cluno HQ", message: "Calculate route", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Open Maps", style: .default))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            mapView.deselectAnnotation(mapView.selectedAnnotations.first!, animated: true)
        }))
        present(alertController, animated: true)
    }
}

// MARK: - Private Functions
private extension DetailViewController {
    
    func donateReservation() {
        guard let reservation = reservation as? INRentalCarReservation, let reservationItemReference = reservation.itemReference else {
            return
        }
    }
}

// MARK: - INReservation
extension INReservationStatus {
    
    var description: String {
        switch self {
        case .canceled:
            return "Cancelled"
        case .pending:
            return "Pending"
        case .hold:
            return "Hold"
        case .confirmed:
            return "Confirmed"
        default:
            return "Unknown"

        }
    }
}

