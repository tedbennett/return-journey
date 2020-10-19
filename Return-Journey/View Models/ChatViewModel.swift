//
//  ChatViewModel.swift
//  Return-Journey
//
//  Created by Ted Bennett on 15/10/2020.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class ChatViewModel: ObservableObject {
    var chatId: String
    @Published var messages = [Message]()
    
    init(chatId: String) {
        self.chatId = chatId
    }
    
    // MARK: - Firestore
    
    private var db = Firestore.firestore()
    
    func subscribeToMessages() {
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "sentAt")
            .addSnapshotListener { (querySnapshot, err) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                    return try? queryDocumentSnapshot.data(as: Message.self)
                }
            }
    }
    
    func addMessage(with body: String) {
        let message = Message(text: body.trimmingCharacters(in: .whitespacesAndNewlines), received: false, sentAt: Date())
        do {
            let _ = try db.collection("users")
                .document(Auth.auth().currentUser!.uid)
                .collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(from: message)
        } catch {
            print(error)
        }
    }
}
