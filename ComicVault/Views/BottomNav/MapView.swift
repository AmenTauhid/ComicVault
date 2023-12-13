//
//  PriceListView.swift
//  ComicVault
//
//  Group 10
//
//  Created by Ayman Tauhid on 2023-11-20.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var locationHelper : LocationHelper
    
    var body: some View {
        VStack{
            if (self.locationHelper.currentLocation != nil){
                
                //show the map with location
                LocationViewModel().environmentObject(self.locationHelper)
                
            }else{
                Text("Current location not available")
            }
        }

    }//body
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
