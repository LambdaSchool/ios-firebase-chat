//
//  ChatRoomController.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

class ChatRoomController {

    func createChatRoom(name: String) {
        let ref = Database.database().reference()
        let chatRoom = ChatRoom(name: name)
        ref.child("chatRooms").child(chatRoom.id).setValue(chatRoom.dictionaryRep)
        chatRooms.append(chatRoom)
    }

    func createMessage(chatRoom: ChatRoom ,text: String, user: Sender) {
        let ref = Database.database().reference()
        let message = Message(text: text, senderName: user.displayName, senderID: user.id)
        ref.child("chatRooms").child(chatRoom.id).child("messages").child(message.identifier).setValue(message.dictionaryRep)
        chatRoom.messages.append(message)
    }

    func fetchChatRooms() {
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let chatRoomDictionaries = snapshot.value as? [String: [String: Any]] else { return }

            var chatRooms: [ChatRoom] = []

            for(_, value) in chatRoomDictionaries {
                print(value)
                guard let chatRoom = ChatRoom(dictionary: value) else { return}
                chatRooms.append(chatRoom)

            }
            self.chatRooms = chatRooms
            print(self.chatRooms.count)
        }

    }
    var chatRooms: [ChatRoom] = []

    var currentUser: Sender?


}

