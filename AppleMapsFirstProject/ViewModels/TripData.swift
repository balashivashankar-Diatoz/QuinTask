//
//  TripData.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import SwiftUI
import CoreLocation
import MapKit
import CoreData

// MARK: - TripState
// To Define the Ride States we use TripState enum
enum TripState {
    case none, live, paused
}
// MARK: - TripData
// TripData contains all the details related to the trip
class TripData: ObservableObject {
    static let shared = TripData()
    
    // MARK: - Properties
    @Published var isRiding = false
    @Published var userTrackingMode: MKUserTrackingMode = .follow
    @Published var startRideTimer = false
    @ObservedObject var rideCounter = RideTimer.shared
    @Published var startedAt = ""
    @Published var coordinatesArray: [CLLocationCoordinate2D] = []
    @Published var liveTripList: [TripModel] = []
    @Published var pausedCoordinatesArray: [CLLocationCoordinate2D] = []
    @Published var pausedLiveTripList: [TripModel] = []
    @Published var distance: Double = 0.0
    @Published var timeElasped = 0
    @Published var isTripEnded = false
    var timer: Timer? = nil
    var tripState: TripState = .none {
        didSet {
            self.setTrip()
        }
    }
    
    @Published var multiBtnAction: () -> () = {}
    @Published var endBtnAction: () -> () = {}
    @Published var rideListAction: () -> () = {}
    private func setTrip(){
        switch self.tripState {
        case .none:
            self.multiBtnAction = {
                LocationManager.shared.checkAndStartLocomotionRecording()
                withAnimation {
                    self.rideCounter.start()
                }
            }
            self.isRiding = false
            self.userTrackingMode = .follow
            self.timeElasped = 0
            self.rideListAction = {
                withAnimation {
                    self.isTripEnded = true
                }
            }
        case .live:
            self.isRiding = true
            self.multiBtnAction = {
                withAnimation {
                    self.tripState = .paused
                }
            }
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
                self.timeElasped += 1
            })
        case .paused:
            self.isRiding = true
            self.multiBtnAction = {
                withAnimation {
                    self.tripState = .live
                }
            }
            self.endBtnAction = {
                withAnimation {
                    self.isTripEnded = true
                    self.tripState = .none
                    self.distance = 0
                    self.coordinatesArray.removeAll()
                    self.liveTripList.removeAll()
                    self.pausedCoordinatesArray.removeAll()
                    self.pausedLiveTripList.removeAll()
                    
                }
            }
            self.timer?.invalidate()
        }
    }
}
