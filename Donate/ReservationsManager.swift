//
//  ReservationsManager.swift
//  Donate
//
//  Created by Guillermo Moraleda on 02.07.19.
//  Copyright © 2019 Guillermo Moraleda. All rights reserved.
//

import Foundation
import Intents
import Contacts

class ReservationsManager {
    
    static let sharedInstance: ReservationsManager = {
        let instance = ReservationsManager()
        instance.createCarBookings()
        return instance
    }()
    
    fileprivate var reservationContainersDictionary: [INSpeakableString: [INReservation]] = [:]
    
    func reservationContainers() -> [INSpeakableString] {
        return Array(reservationContainersDictionary.keys)
    }
    
    func reservation(withItemReference itemReference: INSpeakableString) -> INReservation? {
        for reservationContainer in reservationContainersDictionary.keys {
            let reservations = reservationContainersDictionary[reservationContainer]
            if let reservation = reservations?.first(where: { $0.itemReference == itemReference }) {
                return reservation
            }
        }
        return nil
    }
    
    fileprivate func createCarBookings() {
        // This marks the start of laying out the datetimes relative to each other. Your app should not need to do this.
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Berlin")!
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let inFourDaysDateComponents = calendar.components(inTimeZone: calendar.timeZone, byAdding: DateComponents(day: 4), to: todayDateComponents, wrappingComponents: false)!
        
        /**
         * The reservation is for a Sample Make Sample Model
         *
         * - Note: The rental company name might be different from the location name. For instance, the company name might be
         *         "Sample Rental Corp",  but a specific location might be named "Sample Rental Sample Location".
         */
        let rentalCar = INRentalCar(rentalCompanyName: "Cluno",
                                    type: "Economy Class Car",
                                    make: "Opel",
                                    model: "Corsa",
                                    rentalCarDescription: "An economy class Opel Corsa or similar with 4 doors")
        
        /**
         * The pickup date is four days from today at 10 am and drop-off is the same day at 9 pm.
         *
         * - Note: Be sure to set the correct time zone for the pick-up and drop-off locations even if they're
         *         in the same time zone as the user.
         */
        
        var pickupTime = inFourDaysDateComponents
        pickupTime.hour = 10
        pickupTime.minute = 00
        
        
        var dropOffTime = inFourDaysDateComponents
        dropOffTime.hour = 21
        dropOffTime.minute = 00
        
        /**
         * The car should be picked up and dropped off at Sample Rental Sample Location
         *
         * - Note: If you don't know the coordinate of a location, please use 0,0 to indicate this.
         *
         */
        let pickupLocation = CLPlacemark(location: CLLocation(latitude: 48.1323306, longitude: 11.6219036),
                                         name: "Cluno HQ",
                                         postalAddress: nil)
        
        /**
         * Create the INRentalCarReservation object
         *
         * - Note: Be sure to specify an identifier that is unique within your app for every INReservation object you intend to donate.
         *         Your app may be launched with an INGetReservationDetailsIntent containing this INSpeakableString in the
         *         reservationItemReferences array.
         * - Note: Even if your pickup and dropoff locations are the same, be sure to specify both.
         */
        
        let bookingTime = Date(timeIntervalSince1970: 1_559_554_860)
        
        let pendingReservationNumber = "PENDING-001"
        let pendingReservationReference = INSpeakableString(vocabularyIdentifier: "9f111gz3", spokenPhrase: "Pending car booking \(pendingReservationNumber)", pronunciationHint: nil)
        let pendingReservation = INRentalCarReservation(itemReference: pendingReservationReference,
                                                       reservationNumber: pendingReservationNumber,
                                                       bookingTime: bookingTime,
                                                       reservationStatus: .pending,
                                                       reservationHolderName: "G. Moraleda",
                                                       actions: nil,
                                                       rentalCar: rentalCar,
                                                       rentalDuration: INDateComponentsRange(start: pickupTime, end: dropOffTime),
                                                       pickupLocation: pickupLocation,
                                                       dropOffLocation: pickupLocation)
        
        let confirmedReservationNumber = "CONFIRMED-002"
        let confirmedReservationReference = INSpeakableString(vocabularyIdentifier: "9f111gz3", spokenPhrase: "Confirmed car booking \(confirmedReservationNumber)", pronunciationHint: nil)
        let confirmedReservation = INRentalCarReservation(itemReference: confirmedReservationReference,
                                                        reservationNumber: confirmedReservationNumber,
                                                        bookingTime: bookingTime,
                                                        reservationStatus: .pending,
                                                        reservationHolderName: "G. Moraleda",
                                                        actions: nil,
                                                        rentalCar: rentalCar,
                                                        rentalDuration: INDateComponentsRange(start: pickupTime, end: dropOffTime),
                                                        pickupLocation: pickupLocation,
                                                        dropOffLocation: pickupLocation)
        
        let cancelledReservationNumber = "CANCELLED-003"
        let cancelledReservationReference = INSpeakableString(vocabularyIdentifier: "9f111gz3", spokenPhrase: "Cancelled car booking \(cancelledReservationNumber)", pronunciationHint: nil)
        let cancelledReservation = INRentalCarReservation(itemReference: cancelledReservationReference,
                                                          reservationNumber: cancelledReservationNumber,
                                                          bookingTime: bookingTime,
                                                          reservationStatus: .pending,
                                                          reservationHolderName: "G. Moraleda",
                                                          actions: nil,
                                                          rentalCar: rentalCar,
                                                          rentalDuration: INDateComponentsRange(start: pickupTime, end: dropOffTime),
                                                          pickupLocation: pickupLocation,
                                                          dropOffLocation: pickupLocation)
        
        reservationContainersDictionary[pendingReservationReference] = [pendingReservation]
        reservationContainersDictionary[confirmedReservationReference] = [confirmedReservation]
        reservationContainersDictionary[cancelledReservationReference] = [cancelledReservation]
    }
    
}
