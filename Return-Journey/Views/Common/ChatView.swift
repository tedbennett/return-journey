//
//  ChatView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 14/10/2020.
//

import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var text = ""
    
    init(chatId: String) {
        self.viewModel = ChatViewModel(chatId: chatId)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical) {
                    VStack {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                                .padding(.trailing, 20)
                                .padding(.leading, 20)
                                .frame(width: geometry.size.width, alignment: message.received ?  .leading : .trailing)
                            
                        }
                    }
                }
                HStack {
                    TextField("Message", text: $text).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        viewModel.addMessage(with: text)
                    }, label: {
                        Text("Send")
                    })
                }.padding(10)
            }
        }
    }
}


struct MessageView: View {
    var message: Message
    var body: some View {
        ZStack {
            Text(message.text)
                .frame(minWidth: .zero, maxWidth: 250)
                .fixedSize(horizontal: true, vertical: false)
                .padding(10)
                .padding(.horizontal, 5)
                .lineLimit(nil)
                .background(message.received ? Color.gray : Color.purple)
                .foregroundColor(.white)
                .cornerRadius(20)
        }
    }
}

extension Message {
    var received: Bool {
        return sender != Auth.auth().currentUser!.uid
    }
}
