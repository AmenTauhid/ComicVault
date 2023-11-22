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
                            VStack{
                                
                                Image(systemName: "safari")
                                    .font(.title)
                                Text("Explore")
                                    .font(.headline)
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 236/255, green: 107/255, blue: 102/255)) //Light Red
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.bottom, 10)
                        }

                        NavigationLink(destination: PublishCollectionsView()) {
                            VStack{
                                Image(systemName: "paperplane")
                                    .font(.title)
                                Text("Publish")
                                    .font(.headline)
                                
                            }
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
                            HStack{
                                ZStack{
                                    Text("Chats")
                                        .font(.headline)
                                }
                                Image(systemName: "message")
                                    .font(.title)
                            }
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 247/255, green: 227/255, blue: 121/255)) //Yellow
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.bottom, 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    if hasChats {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 20, height: 20)
                            .offset(x: 175, y: -90)
                    }

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
                                        .fontWeight(.bold)
                                }
                            }
                            .padding()

                            Spacer()

                            NavigationLink(destination: AddComicView()) {
                                VStack {
                                    ZStack {
                                        Image(systemName: "plus.circle")
                                            .fontWeight(.bold)
                                            .font(.title)
                                            .foregroundColor(.black)
                                            .padding()
                                            .background(Color(red: 236/255, green: 107/255, blue: 102/255)) //Light Red
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                    }
                                    Text("Add")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                            }

                            Spacer()

                            NavigationLink(destination: PriceListView()) {
                                VStack {
                                    Image(systemName: "chart.bar")
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color(red: 130/255, green: 180/255, blue: 206/255)) //Mid Blue/Grey
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                    Text("Prices")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
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
                        
                        ScrollView{
                            LazyVStack{
                                VStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                        .padding()

                                    HStack {
                                        Text("John Smith")
                                            .font(.system(size: 26, design: .serif))
                                            .padding()
                                            .fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 247/255, green: 227/255, blue: 121/255)) //Yellow
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding([.leading, .trailing, .top])

                                    VStack {
                                        Text("Total Comics: 100")
                                        Text("Total Value: $500")
                                    }
                                    .foregroundColor(.gray)
                                    .padding([.leading, .trailing, .bottom])

                                    Spacer()
                                    
                                    NavigationLink(destination: SettingsView()) {
                                        HStack{
                                            Image(systemName: "gear")
                                                .font(.title)
                                                
                                            Text("Settings")
                                                .fontWeight(.bold)
                                        }
                                    }
                                    
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color(red: 236/255, green: 107/255, blue: 102/255)) //Light Red
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding()
                                }
                                .background(Color(red: 231/255, green: 243/255, blue: 254/255)) //Light White/Blue
                                .cornerRadius(20)
                                .padding()
                            }
                        }
                        .listStyle(SidebarListStyle())
                        .frame(width: 330)
                        .transition(.move(edge: .trailing))
                        
                        Spacer()
                        
                        VStack{
                            Text("Authors:")
                                .fontWeight(.bold)
                                .padding([.leading, .trailing, .top])
                            Text("Ayman Tauhid, Elias Alissandratos and Omar Al-Dulaimi")
                                .padding([.leading, .trailing, .bottom])
                        }
                        .background(Color(red: 130/255, green: 180/255, blue: 206/255)) //Mid Blue/Grey
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding([.leading, .trailing, .top])
                        .frame(width: 330)
                    }
                    .background(Color(red: 70/255, green: 96/255, blue: 115/255)) //Dark Grey/Blue
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


