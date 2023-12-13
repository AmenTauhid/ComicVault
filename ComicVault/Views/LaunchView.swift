//
//  LaunchView.swift
//  ComicVault
//
//  Group 10
//
//  Created by Omar Al-Dulaimi, Ayman Tauhid on 2023-12-08.
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import SwiftUI

struct LaunchView: View {
    
    @State private var rootView : RootView = .login
    
    var body: some View {
        NavigationStack{
            switch self.rootView{
            case .login:
                LoginView(rootView: self.$rootView)
            case .main:
                HomeView(rootView: self.$rootView)
            case .signup:
                SignUpView(rootView: self.$rootView)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
