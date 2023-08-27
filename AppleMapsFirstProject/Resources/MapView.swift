//
//  MapView.swift
//  AppleMapsFirstProject
//
//  Created by Bala Shiva Shankar on 26/08/23.
//

import Foundation
import SwiftUI
import MapKit

// MARK: - LocationManager
struct MapView: UIViewRepresentable {
    // MARK: - Properties
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var region: MKCoordinateRegion
    @Binding var isRiding: Bool
    @Binding var tripCoordinates: [CLLocationCoordinate2D]
    @ObservedObject var tripData = TripData.shared
    
    // MARK: - makeUIView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = self.userTrackingMode
        mapView.setRegion(self.region, animated: true)
        mapView.showsCompass = false
        return mapView
    }
    
    // MARK: - updateUIView
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsCompass = false
        view.userTrackingMode = self.userTrackingMode
        if self.isRiding{
            var polyline = MKPolyline(coordinates: tripCoordinates, count: tripCoordinates.count)
            view.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
            view.removeOverlay(context.coordinator.prevPolyline)
            context.coordinator.prevPolyline = polyline
        }
        if !self.isRiding && tripCoordinates.count == 0 {
            view.removeOverlays(view.overlays)
            let annotations = view.annotations.filter {
                $0 !== view.userLocation
            }
            view.removeAnnotations(annotations)
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    var prevPolyline = MKPolyline()
    @ObservedObject var tripData = TripData.shared
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.init(tripData.tripState == .live ? Color.red:Color.purple)
            renderer.lineWidth = tripData.tripState == .live ? 5:3
            if tripData.tripState == .paused {
                renderer.lineDashPhase = 2
                renderer.lineDashPattern = [NSNumber(value: 5),NSNumber(value:8)]
            }
            return renderer
        }
        return MKOverlayRenderer()
    }
}



