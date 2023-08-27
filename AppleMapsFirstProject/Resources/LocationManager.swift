//
//  LocationManager.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import MapKit
import SwiftUI
import LocoKit

// MARK: - LocationManager
class LocationManager: NSObject, ObservableObject {
    // MARK: - Properties
    static let shared = LocationManager()
    let locomotionManager = LocomotionManager.highlander
    // region variable is used to define a region on a map with a specified center and distances in meters for the latitudinal and longitudinal spans.
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(0, 0), latitudinalMeters: 10000, longitudinalMeters: 10000)
    // Represents a geographical coordinate along with accuracy and timestamp information.
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    // MARK: - checkAndStartLocomotionRecording
    // to start Motion recording we should add backgroundmodes on signing and capabilities
    
    func checkAndStartLocomotionRecording(){
        if self.locomotionManager.haveLocationPermission {
        self.locomotionManager.startRecording()
        self.locomotionManager.useLowPowerSleepModeWhileStationary = true
        let observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.locomotionSampleUpdated,
            object: nil, queue: nil) { _ in
                self.processLocation(loc: self.locomotionManager.filteredLocation)
            }
    }
        else {
//            This block of code is for running background tasks
            self.locomotionManager.requestLocationPermission(background: true)
            self.locomotionManager.startCoreMotion()
        }
}
    // below function is to get cordinates,distance of the trip
    func processLocation(loc: CLLocation?) {
        guard let location = loc else { return }
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        if (TripData.shared.tripState == .live || TripData.shared.tripState == .paused) && (LocationManager.shared.location?.coordinate.latitude != 0 && LocationManager.shared.location?.coordinate.longitude != 0) {
            guard let currentLocation = LocationManager.shared.location else {return}
            self.region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            
            if (TripData.shared.coordinatesArray.count == 0 || TripData.shared.pausedCoordinatesArray.count == 0){
                if (TripData.shared.coordinatesArray.count == 0){
                    let timeStamp = currentLocation.timestamp.millisecondsSince1970
                    TripData.shared.startedAt = "\(timeStamp)"
                    TripData.shared.liveTripList.append(TripModel(timestamp: "\(Double(timeStamp))",duration: 0))
                }
                else{
                    let timeStamp = currentLocation.timestamp.millisecondsSince1970
                    TripData.shared.startedAt = "\(timeStamp)"
                    TripData.shared.pausedLiveTripList.append(TripModel(timestamp: "\(Double(timeStamp))",duration: 0))
                }
            }
            // To get the Live Coordinates and distance travelled
            if (TripData.shared.coordinatesArray.count > 0 || TripData.shared.pausedCoordinatesArray.count > 0) {
                if(TripData.shared.coordinatesArray.count > 1 && TripData.shared.tripState == .live){
                    let srcLocation = CLLocation(latitude: TripData.shared.coordinatesArray[TripData.shared.coordinatesArray.count-1].latitude, longitude: TripData.shared.coordinatesArray[TripData.shared.coordinatesArray.count-1].longitude)
                    let destTime = currentLocation.timestamp.millisecondsSince1970
                    let srcTimeduration = TripData.shared.liveTripList[TripData.shared.liveTripList.count - 1].timestamp
                    let duration = Double(destTime) - (Double(srcTimeduration) ?? 0.0)
                    let distance = currentLocation.distance(from: srcLocation)
                    TripData.shared.liveTripList.append(TripModel(timestamp: "\(Double(destTime))",duration: Double(duration/1000)))
                    TripData.shared.distance += distance
                }
                // To get the paused Coordinates and distance travelled
                if(TripData.shared.pausedCoordinatesArray.count > 1 && TripData.shared.tripState == .paused){
                    let srcLocation = CLLocation(latitude: TripData.shared.pausedCoordinatesArray[TripData.shared.pausedCoordinatesArray.count-1].latitude, longitude: TripData.shared.pausedCoordinatesArray[TripData.shared.pausedCoordinatesArray.count-1].longitude)
                    let destTime = currentLocation.timestamp.millisecondsSince1970
                    if !TripData.shared.pausedLiveTripList[TripData.shared.pausedLiveTripList.count - 1].timestamp.isEmpty {
                        let srcTimeduration = TripData.shared.pausedLiveTripList[TripData.shared.pausedLiveTripList.count - 1].timestamp
                        let duration = Double(destTime) - (Double(srcTimeduration) ?? 0.0)
                        let distance = currentLocation.distance(from: srcLocation)
                        TripData.shared.pausedLiveTripList.append(TripModel(timestamp: "\(Double(destTime))",duration: Double(duration/1000)))
                    }
                }
            }
            // Appending coordinates
            if TripData.shared.tripState == .live{
                TripData.shared.coordinatesArray.append(location.coordinate)
                TripData.shared.pausedCoordinatesArray.removeAll()
                TripData.shared.pausedLiveTripList.removeAll()
            }else if TripData.shared.tripState == .paused{
                TripData.shared.pausedCoordinatesArray.append(location.coordinate)
                TripData.shared.coordinatesArray.removeAll()
                TripData.shared.liveTripList.removeAll()
                
            }
            
        }
        
    }
}

