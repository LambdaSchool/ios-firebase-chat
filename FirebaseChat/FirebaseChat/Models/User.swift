//
//  User.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation

struct User: Codable {
    let displayName: String
    let id: String
    
    init?(data: [String : Any]) {
        guard let displayName = data["displayName"] as? String,
        let id = data["id"] as? String
        else { return nil }
        
        self.displayName = displayName
        self.id = id
    }
}
