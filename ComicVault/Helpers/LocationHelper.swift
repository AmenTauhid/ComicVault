//
//  LocationHelper.swift
//  ComicVault
//
//  Created by Elias Alissandratos  on 2023-12-12.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import Foundation
import CoreLocation

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus{
        case .authorizedAlways:
            //            allow access to functionalities which uses location in foreground and background
            print(#function, "location access is granted always")
            //to trigger didUpdateLocation() callback to start receiving location changes
            manager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            //            allow access to functionalities which uses location in foreground
            print(#function, "location access is granted when in use")
            //to trigger didUpdateLocation() callback to start receiving location changes
            manager.startUpdatingLocation()
            
        case .notDetermined, .denied:
            //            request the location permission if needed or restrict the functionalities which are dependent on location
            print(#function, "user not responded to location request or denied")
            
            //request appropriate permission
            manager.requestWhenInUseAuthorization()
            
            //stop receiving location changes if any is running
            manager.stopUpdatingLocation()
            
        case .restricted:
            //            request full access to location if needed or continue with restricted access
            print(#function, "location access is restricted")
            
            //request appropriate permission
            manager.requestWhenInUseAuthorization()
            manager.requestAlwaysAuthorization()
            
            //stop receiving location changes if any is running
            manager.stopUpdatingLocation()
            
        @unknown default:
            //            terminate the app if can't proceed without location related functionality or request the permission
            print(#function, "location access is not available")
            
            //stop receiving location changes if any is running
            manager.stopUpdatingLocation()
        }
    }
    
    
    //to receive changes in the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locations.isEmpty){
            print(#function, "App is unable to retrieve location")
        }else{
            //app has access to location
            
            //access the most recent location
            if (locations.last != nil){
                print(#function, "locations.last : \(locations.last)")
                self.currentLocation = locations.last
            }else{
                //access oldest location or previously known location
                self.currentLocation = locations.first
            }
        }
        
        print(#function, "location change updated")
        print(#function, "current location : \(self.currentLocation)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Location access failed due to error : \(error)")
    }

}
