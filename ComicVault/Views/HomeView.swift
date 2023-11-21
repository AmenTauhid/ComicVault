//
//  HomeView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        Text("Comic Vault")
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: NotificationsView()) {
                            Image(systemName: "bell")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))

                VStack {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .padding()

                        VStack(alignment: .leading) {
                            Text("John Smith")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("Total Comics: 100")
                                .font(.subheadline)
                                .foregroundColor(.white)

                            Text("Total Value: $500")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()) {
                            Text("|")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Image(systemName: "gear")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .frame(height: 100)
                }
                .padding(.horizontal)

                Spacer()
                Rectangle()
                    .foregroundColor(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
                    .frame(height: 200)
                    .cornerRadius(20)
                    .padding(.top, 10)
                    .padding(.horizontal)

                HStack {
                    NavigationLink(destination: OthersCollectionsView()) {
                        Text("Explore Collections")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.bottom, 10)
                    }

                    NavigationLink(destination: PublishCollectionsView()) {
                        Text("Publish Collections")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal)

                HStack {
                    NavigationLink(destination: ChatsView()) {
                        Text("Chats")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal)

                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
                        .clipShape(RoundedCornerShape(topLeft: 20, topRight: 20))
                    
                    HStack {
                        NavigationLink(destination: DatabaseView()) {
                            VStack {
                                Image(systemName: "square.grid.2x2")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                Text("View")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        
                        Spacer()
                        
                        NavigationLink(destination: AddComicView()) {
                            VStack {
                                ZStack {
                                    Circle()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
                                }
                                Text("Add")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: PriceListView()) {
                            VStack {
                                Image(systemName: "chart.bar.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                Text("Prices")
                                    .foregroundColor(.white)
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
                .background(Color(red: 0.0, green: 51.0 / 255.0, blue: 102.0 / 255.0))
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(Color.white)
        }
    }
}

struct RoundedCornerShape: Shape {
    var topLeft: CGFloat
    var topRight: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft), radius: topLeft, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight), radius: topRight, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        return path
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

