//
//  AddComicView.swift
//  ComicVault
//
//  Created by Elias Alissandratos & Ayman Tauhid on 2023-11-20.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import SwiftUI
import Vision

struct AddComicView: View {
    @State private var name: String = ""
    @State private var issueNumber: String = ""
    @State private var releaseYear: String = ""
    @ObservedObject private var firestoreManager = FirestoreManager()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showCameraSheet = false
    @State private var capturedImage: UIImage?
    @State private var barcodeResults: [String] = []
    @ObservedObject private var mlHelper = MLHelper()

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
                        submitComic()
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
                    
                    Button("Scan Comic") {
                        self.showCameraSheet = true
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 200)
                    .background(Color.yellow) // Light Red
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .sheet(isPresented: $showCameraSheet) {
                        ImagePicker(image: self.$capturedImage, sourceType: .camera)
                    }
                    .onChange(of: capturedImage) { _ in
                        if let validImage = capturedImage {
                            mlHelper.updateClassification(for: validImage)
                        }
                    }
                    
                    // Observing the changes from MLHelper
                    .onChange(of: mlHelper.comicTitle) { newTitle in
                        self.name = newTitle
                    }
                    .onChange(of: mlHelper.issueNumber) { newIssueNumber in
                        self.issueNumber = newIssueNumber
                    }
                }
                .padding(.top, 36)
            }
            .onAppear {
                self.mlHelper.createRequest()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Image Picker Struct
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        let sourceType: UIImagePickerController.SourceType
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = sourceType
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.image = image
                }
                picker.dismiss(animated: true)
            }
        }
    }
    
    private func submitComic() {
        firestoreManager.addComicWithPrice(name: name, issueNumber: issueNumber, releaseYear: releaseYear) { result in
            switch result {
            case .success():
                alertMessage = "Comic added successfully with price"
                showAlert = true
                clearInputFields()
            case .failure(let error):
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }

    private func clearInputFields() {
        name = ""
        issueNumber = ""
        releaseYear = ""
    }
    
    private func recognizeText(from image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                completion([])
                return
            }
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            completion(recognizedStrings)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        try? requestHandler.perform([request])
    }
}

struct AddComicView_Previews: PreviewProvider {
    static var previews: some View {
        AddComicView()
    }
}
