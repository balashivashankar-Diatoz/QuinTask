//
//  RideTimer.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import SwiftUI
import Foundation
import CoreLocation
import MapKit

// RideTimer will start countdown on click of start button
class RideTimer: ObservableObject {
    static let shared = RideTimer()
    // MARK: - Properties
    var interval = 1.0
    var timer: Timer?
    @Published var counter: CGFloat = 3
    // MARK: - start
    func start() {
        TripData.shared.startRideTimer = true
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
            self.counter -= 1
            if self.counter <= 0 {
                self.timer?.invalidate()
                self.timer = nil
            }
            if self.counter == 0 || self.counter == 0.0 {
                TripData.shared.startRideTimer = false
                TripData.shared.tripState = .live
                self.counter = 3
            }
        })
    }
    // MARK: - stop
    func stop() {
        self.timer?.invalidate()
    }
}
