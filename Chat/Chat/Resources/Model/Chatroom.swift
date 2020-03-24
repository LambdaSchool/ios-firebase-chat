//
//  Chatroom.swift
//  Chat
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation

struct Chatroom: Codable {
    
    let name: String
    let roomPurpose: String 
    let id: String = UUID().uuidString
    
}
