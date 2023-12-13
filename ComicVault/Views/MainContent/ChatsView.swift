//
//  HomeView.swift
//  ComicVault
//
//  Group 10
//
//  Created by Omar Al-Dulaimi & Ayman Tauhid on 2023-11-20.
//
//  Omar's StudentID: 991653328
//  Ayman's StudentID: 991659098
//  Elias's StudentID: 991635816
//

import SwiftUI
import Firebase
import Combine
import FirebaseDatabase

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var userChats: [String] = []

    private var cancellables: Set<AnyCancellable> = []

    func sendMessage(text: String, toUserEmail: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }

        guard let currentUserEmail = currentUser.email else {
            print("User email not available.")
            return
        }

        let currentUserEmailSafe = currentUserEmail.replacingOccurrences(of: ".", with: ",")
        let toUserEmailSafe = toUserEmail.replacingOccurrences(of: ".", with: ",")

        let chatPath = "chats/\(currentUserEmailSafe)_\(toUserEmailSafe)"
        let messageData: [String: Any] = [
            "sender": currentUserEmail,
            "text": text,
            "timestamp": Date().timeIntervalSince1970 * 1000 // Store timestamp as milliseconds
        ]

        let chatRef = Database.database().reference().child(chatPath).childByAutoId()
        chatRef.setValue(messageData)
    }

    func observeMessages(withUserEmail userEmail: String) {
        let chatPath = "chats/\(userEmail)"
        Database.database().reference().child(chatPath).observe(.childAdded) { snapshot in
            if let messageData = snapshot.value as? [String: Any],
                let sender = messageData["sender"] as? String,
                let text = messageData["text"] as? String,
                let timestamp = messageData["timestamp"] as? TimeInterval {

                let message = Message(sender: sender, text: text, timestamp: timestamp)
                self.messages.append(message)
            }
        }
    }

    func observeUserChats() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }

        guard let currentUserEmail = currentUser.email else {
            print("User email not available.")
            return
        }

        let currentUserEmailSafe = currentUserEmail.replacingOccurrences(of: ".", with: ",")
        let chatsPath = "chats/\(currentUserEmailSafe)"

        Database.database().reference().child(chatsPath).observe(.value) { snapshot in
            if let chats = snapshot.value as? [String] {
                self.userChats = chats
            }
        }
    }

    func createNewChat(withEmail email: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }

        guard let currentUserEmail = currentUser.email else {
            print("User email not available.")
            return
        }

        let currentUserEmailSafe = currentUserEmail.replacingOccurrences(of: ".", with: ",")
        let toUserEmailSafe = email.replacingOccurrences(of: ".", with: ",")

        let chatPath = "chats/\(currentUserEmailSafe)"
        let chatRef = Database.database().reference().child(chatPath)

        if !userChats.contains(email) {
            chatRef.childByAutoId().setValue(email)
        }
    }
}

struct Message: Identifiable {
    var id: String { UUID().uuidString }
    var sender: String
    var text: String
    var timestamp: TimeInterval
}

struct ChatsView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @State private var newMessage = ""
    @State private var toUserEmail = ""
    @State private var showNewChatSheet = false

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.userChats, id: \.self) { chat in
                    NavigationLink(destination: ChatDetailView(viewModel: viewModel, userEmail: chat)) {
                        Text(chat)
                    }
                }
                .onAppear {
                    viewModel.observeUserChats()
                }

                Button(action: {
                    showNewChatSheet.toggle()
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding()
                .sheet(isPresented: $showNewChatSheet) {
                    NewChatView(viewModel: viewModel)
                }
            }
            .navigationBarTitle("Chats")
        }
    }
}

struct NewChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var newChatEmail = ""

    var body: some View {
        VStack {
            TextField("Recipient's Email", text: $newChatEmail)
                .padding()

            Button("Add") {
                viewModel.createNewChat(withEmail: newChatEmail)
                newChatEmail = ""
            }
            .padding()
        }
        .navigationBarTitle("New Chat")
    }
}

struct ChatDetailView: View {
    @ObservedObject var viewModel: ChatViewModel
    var userEmail: String

    @State private var newMessage = ""

    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                Text("\(message.sender): \(message.text)")
            }
            .onAppear {
                viewModel.observeMessages(withUserEmail: userEmail)
            }

            HStack {
                TextField("Type your message", text: $newMessage)
                    .padding()

                Button("Send") {
                    viewModel.sendMessage(text: newMessage, toUserEmail: userEmail)
                    newMessage = ""
                }
                .padding()
            }
        }
        .navigationBarTitle(userEmail)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}

