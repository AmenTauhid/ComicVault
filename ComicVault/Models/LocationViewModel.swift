//
//  LocationViewModel.swift
//  ComicVault
//
//  Created by Elias Alissandratos & Omar Al-Dulaimi on 2023-12-12.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import Foundation
import MapKit
import SwiftUI

struct LocationViewModel: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @EnvironmentObject var locationHelper: LocationHelper
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        configureMapView(mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let sourceCoordinates: CLLocationCoordinate2D
        
        if let currentLocation = self.locationHelper.currentLocation {
            sourceCoordinates = currentLocation.coordinate
        } else {
            sourceCoordinates = CLLocationCoordinate2D(latitude: 43.8940, longitude: -79.3746) // Default coordinates
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: sourceCoordinates, span: span)
        
        uiView.setRegion(region, animated: true)
        
        searchForComicBookStores(near: sourceCoordinates, in: uiView)
    }

    private func configureMapView(_ mapView: MKMapView) {
        mapView.showsUserLocation = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
    }

    private func searchForComicBookStores(near location: CLLocationCoordinate2D, in mapView: MKMapView) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "comic book store"
        request.region = mapView.region

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            mapView.removeAnnotations(mapView.annotations) // Remove existing annotations
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
}
