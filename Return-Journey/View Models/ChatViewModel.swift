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
    @Published var messages = [Message]()
    
    // MARK: - Firestore
    
    private var db = Firestore.firestore()
    
    func subscribeToMessages(for chatId: String) {
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
}
