//
//  HomeView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingDrawer = false
    
    //Notification Dots
    @State private var hasNotifications = false
    @State private var hasChats = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack {
                        Text("ComicVault")
                            .font(.system(size: 36, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        HStack {
                            Button(action: {
                                withAnimation {
                                    isShowingDrawer.toggle()
                                }
                            }) {
                                Image(systemName: "text.justify")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(red: 130/255, green: 180/255, blue: 206/255)) //Mid Blue/Grey
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .padding()
                            
                            Spacer()
                            
                            NavigationLink(destination: NotificationsView()) {
                                ZStack {
                                    Image(systemName: "bell")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color(red: 130/255, green: 180/255, blue: 206/255)) //Mid Blue/Grey
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                    
                                    if hasNotifications {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 20, height: 20)
                                            .offset(x: 20, y: -20)
                                    }
                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(Color(red: 231/255, green: 243/255, blue: 254/255)) //Light White/Blue

                    Rectangle()
                        .foregroundColor(Color(red: 231/255, green: 243/255, blue: 254/255)) //Light White/Blue
                        .frame(height: 315)
                        .frame(maxWidth: 275)
                        .cornerRadius(20)
                        .padding()
                    

                    HStack {
                        NavigationLink(destination: OthersCollectionsView()) {
                            Text("Explore Collections ")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 236/255, green: 107/255, blue: 102/255)) //Light Red
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.bottom, 10)
                        }

                        NavigationLink(destination: PublishCollectionsView()) {
                            Text("Publish Collections")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                
                                .background(Color(red: 130/255, green: 180/255, blue: 206/255)) //Mid Blue/Grey
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)

                    HStack {
                        NavigationLink(destination: ChatsView()) {
                            ZStack{
                                Text("Chats")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 247/255, green: 227/255, blue: 121/255)) //Yellow
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding(.bottom, 10)
                                
                                if hasChats {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 20, height: 20)
                                        .offset(x: 175, y: -30)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                    ZStack {
                        Rectangle()
                                .foregroundColor(Color(red: 231/255, green: 243/255, blue: 254/255)) //Light White/Blue
                                .cornerRadius(20) // Rounded corners
                                .overlay(
                                    Rectangle()
                                        .foregroundColor(Color.clear)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0), Color.white.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // Clip the shadow to the rounded rectangle shape
                                )

                        HStack {
                            NavigationLink(destination: DatabaseView()) {
                                VStack {
                                    Image(systemName: "square.grid.2x2")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color(red: 130/255, green: 180/255, blue: 206/255)) //Mid Blue/Grey
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                    Text("View")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding()

                            Spacer()

                            NavigationLink(destination: AddComicView()) {
                                VStack {
                                    ZStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color(red: 236/255, green: 107/255, blue: 102/255)) //Light Red
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                    }
                                    Text("Add")
                                        .foregroundColor(.black)
                                }
                            }

                            Spacer()

                            NavigationLink(destination: PriceListView()) {
                                VStack {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color(red: 130/255, green: 180/255, blue: 206/255)) //Mid Blue/Grey
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                    Text("Prices")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 15)
                    }
                    .frame(height: 70)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .background(Color(red: 231/255, green: 243/255, blue: 254/255)) //Light White/Blue
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .background(Color(red: 70/255, green: 96/255, blue: 115/255)) //Dark Grey/Blue
                
                
                // Side Drawer //////////////////////////////////////////////////////////////
                if isShowingDrawer {
                    Color.black.opacity(0.5)
                        .onTapGesture {
                            withAnimation {
                                self.isShowingDrawer.toggle()
                            }
                        }
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Spacer()
                        List {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .shadow(radius: 5)

                            Text("John Smith")
                                .font(.title)
                            

                            VStack {
                                Text("Total Comics: 100")
                                Text("Total Value: $500")
                            }
                            .foregroundColor(.gray)

                            Spacer()
                            
                            NavigationLink(destination: SettingsView()) {
                                HStack{
                                    Image(systemName: "gear")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                    Text("Settings")
                                        .padding()
                                }

                            }

                        }
                        .listStyle(SidebarListStyle())
                        .frame(width: 300)
                        .transition(.move(edge: .trailing))
                        
                        Spacer()
                    }
                    .background(Color.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                } // Side Drawer //////////////////////////////////////////////////////////////
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


