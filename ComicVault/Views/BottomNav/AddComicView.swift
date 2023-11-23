//
//  AddComicView.swift
//  ComicVault
//
//  Created by Elias Alissandratos on 2023-11-20.
//

import SwiftUI

struct AddComicView: View {
    @State private var name: String = ""
    @State private var issueNumber: String = ""
    @State private var releaseYear: String = ""
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 70/255, green: 96/255, blue: 115/255) // Dark Grey/Blue

            VStack {
                Text("Add Comic")
                    .font(.system(size: 36, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue

                VStack {
                    TextField("Comic Name", text: $name)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)
                    TextField("Issue Number", text: $issueNumber)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)
                    TextField("Release Year", text: $releaseYear)
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 350)
                        .background(Color(red: 231/255, green: 243/255, blue: 254/255)) // Light White/Blue
                        .cornerRadius(50)
                        .shadow(radius: 5)

                    Button("Submit") {
                        let comic = Comic(name: name, issueNumber: issueNumber, releaseYear: releaseYear)
                        firestoreManager.addComic(comic) { result in
                            switch result {
                            case .success():
                                alertMessage = "Comic added successfully"
                                showAlert = true
                                name = ""
                                issueNumber = ""
                                releaseYear = ""
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200)
                    .background(Color(red: 236/255, green: 107/255, blue: 102/255)) // Light Red
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    ZStack{
                        Divider()
                            .background(Color.black)
                        Text("OR")
                            .background(Color(red: 70/255, green: 96/255, blue: 115/255)) // Dark Grey/Blue
                            .frame(width: 150)
                            .padding()
                            .font(.title2)
                    }
                    
                    
                    Button("Scan Comic"){
                        
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200)
                    .background(Color(red: 247/255, green: 227/255, blue: 121/255)) //Yellow
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.top, 36)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct AddComicView_Previews: PreviewProvider {
    static var previews: some View {
        AddComicView()
    }
}

