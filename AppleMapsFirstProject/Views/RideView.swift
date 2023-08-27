//
//  RideView.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import SwiftUI
import MapKit
import LocoKit

struct RideView: View {
    // MARK: - Properties
    @State var startAndEndLocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(), CLLocationCoordinate2D()]
    @State var region = MKCoordinateRegion(center: LocationManager.shared.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    @ObservedObject var tripData = TripData.shared
    @ObservedObject var locationManager = LocationManager.shared
    // MARK: - body
    var body: some View {
        NavigationView {
            // MARK: - Main ZStack
            ZStack{
                NavigationLink(destination: RidesListScreen().navigationBarTitle("").navigationBarHidden(true),isActive: $tripData.isTripEnded) {}
                // MARK: - MapView
                // MapView is to render map on the main screen
                MapView(userTrackingMode: self.$tripData.userTrackingMode, region: self.$region,isRiding: self.$tripData.isRiding, tripCoordinates:TripData.shared.tripState == .live ? self.$tripData.coordinatesArray:self.$tripData.pausedCoordinatesArray)
                VStack{
                    Spacer()
                    if tripData.tripState == .none{
                        HStack{
                            // MARK: - Start Ride
                            Button(action: tripData.multiBtnAction){
                                Text("Start Ride")
                            }
                            .modifier(CustomButtonModifier(backroundColor: Color.black))
                            // MARK: - Rides List
                            Button(action: tripData.rideListAction){
                                Text("Rides List")
                            }
                            .modifier(CustomButtonModifier(backroundColor: Color.black))
                        }
                        .padding([.leading,.trailing],30)
                    }
                    else{
                        // MARK: - BottomCardView
                        BottomCardView()
                    }
                    Spacer().frame(height:60)
                }
                
            }
            .ignoresSafeArea()
            .onAppear(){
                locationManager.checkAndStartLocomotionRecording()
            }
        }
    }
}

struct RideView_Previews: PreviewProvider {
    static var previews: some View {
        RideView()
    }
}
