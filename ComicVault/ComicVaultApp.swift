//
//  ComicVaultApp.swift
//  ComicVault
//
//  Group 10
//
//  Created by Ayman Tauhid on 2023-11-21.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct ComicVaultApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let locationHelper = LocationHelper()
    
    var body: some Scene {
        WindowGroup {
            LaunchView().environmentObject(locationHelper)
        }
    }
}

