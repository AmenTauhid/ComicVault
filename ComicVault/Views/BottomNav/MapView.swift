//
//  PriceListView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
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
