//
//  ChatroomViewController.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatroomViewController: MessagesViewController {
	let messageController = MessageController()

	var chatroom: Chatroom? {
		didSet {
			messageController.selectedChatroom = chatroom
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		messageController.monitorChatroomMessage { [weak self] _ in
			DispatchQueue.main.async {
				self?.messagesCollectionView.reloadData()
			}
		}

		messageInputBar.delegate = self
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
	}
}

extension ChatroomViewController: MessagesDataSource {
	func currentSender() -> SenderType {
		return messageController.currentUser ?? User(id: UUID(), displayName: "I AM LORDE YAYAYA")
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messageController.currentMessageThread[indexPath.item]
	}

	func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
		return messageController.currentMessageThread.count
	}

	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return 1
	}
}

extension ChatroomViewController: MessagesLayoutDelegate {

}

extension ChatroomViewController: MessagesDisplayDelegate {
	func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		if message.sender.senderId == messageController.currentUser?.senderId {
			return .blue
		} else {
			return .purple
		}
	}

	func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return .white
	}

}

extension ChatroomViewController: InputBarAccessoryViewDelegate {
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		messageController.createNewMessage(withText: text) { error in
			if let error = error {
				NSLog("Error creating message: \(error)")
			}
			inputBar.inputTextView.text = ""
		}
	}
}
