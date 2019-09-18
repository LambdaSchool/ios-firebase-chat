//
//  Group.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import Firebase

struct Group {
	let id: UUID
	let title: String
	let timestamp: Date
	let messages: [Message]?
	
	init(id: UUID = UUID(), title: String, timestamp: Date = Date(), messages: [Message]? = nil) {
		self.id = id
		self.title = title
		self.timestamp = timestamp
		self.messages = messages
	}
	
	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: AnyObject],
			let title = value["title"] as? String,
			let timesString = value["timestamp"] as? String,
			let timestamp = timesString.transformToIsoDate else {
				return nil
		}
		
		self.id = UUID(uuidString: snapshot.key) ?? UUID()
		self.title = title
		self.timestamp = timestamp
		self.messages = nil
	}
	
	func toDictionary() -> Any {
		return [
			"title": title,
			"timestamp": timestamp.transformIsoToString
		]
	}
}
