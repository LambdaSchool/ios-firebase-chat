//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

class ChatRoomController {
    var chatRooms: [ChatRoom] = []
    var dbRef: DatabaseReference = Database.database().reference()
    
    func createChatRoom(with title: String) {
        let chatRoomData: [String: Any] = ["title": title, "messages": ["",""], "uid": UUID().uuidString]
        dbRef.child("chats").childByAutoId().setValue(chatRoomData, withCompletionBlock: { error, ref in
            if error == nil {
                print("Sucess")
            } else {
                print("Error")
            }
        })
    }
    
    func getChatRooms(completion: @escaping () -> Void ) {
        dbRef.child("chats").queryOrdered(byChild: "title").observe(.value) { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            self.chatRooms.removeAll()
            
            for snap in snapshots {
                let chatRoomDictionary = snap.value as! [String: Any]
                
                let uid = snap.key
                let title = chatRoomDictionary["title"] as! String
//                let messages = chatRoomDictionary["messages"] as! [Message]
                
                let chatRoom = ChatRoom(uid: uid, title: title, messages: [Message(senderID: "", text: "Welcome to your chat room!", timestamp: Date(), author: "ChatBot")])
                self.chatRooms.append(chatRoom)
            }
            
            completion()
        }
    }
    
    func createMessage() {
        let message = Message(senderID: "", text: "", timestamp: Date(), author: "")
        dbRef.child("chats").child("messages").childByAutoId().setValue(message)
    }
    
}
