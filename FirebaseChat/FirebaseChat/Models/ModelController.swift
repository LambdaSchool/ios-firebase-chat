//
//  ModelController.swift
//  FirebaseChat
//
//  Created by Shawn James on 5/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ModelController {
    
    // MARK: - Properties
    private let databaseReference = Database.database().reference()
    
    // MARK: - Methods
//    Create a chat room in Firebase
    func addNewConversation(named name: String) {
        databaseReference.childByAutoId().setValue(["conversation" : name])
    }
    
//    Fetch chat rooms from Firebase
    func fetchConversationsFromFirebase() {
        
    }
    
//    Create a message in a chat room in Firebase
    func addNewMessage() {
        
    }
    
//    Fetch messages in a chat room from Firebase
    func fetchMessagesFromFirebase() {
        
    }
    
}
