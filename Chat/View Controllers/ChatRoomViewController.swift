//
//  ChatRoomViewController.swift
//  Chat
//
//  Created by Kat Milton on 8/20/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class ChatRoomViewController: MessagesViewController {

    var firebaseController: FirebaseController?
    var chatRoom: ChatRoom?
    var messages: [Message] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        loadMessages()
    }
    
    func loadMessages(){
        guard isViewLoaded else {return}
        
        Database.database().reference().child("myMessages").observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["text"] as! String
                let uid = dict["senderId"] as! String
                let username = dict["displayName"] as! String
                
                let messages = Message(chatroom: nil, text: captionText, displayName: username, senderID: uid, messageId: snapshot.key)
                self.messages.append(messages)
                self.messagesCollectionView.reloadData()
        
            }
        }
    }
    
}



extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        if let currentSender = firebaseController?.currentUser {
            return currentSender
        } else {
            fatalError("No current user available")
        }
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        let message = messages[indexPath.item]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

extension ChatRoomViewController: MessagesLayoutDelegate {
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let sender = message.sender.displayName
        let senderString = NSAttributedString(string: sender, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        return senderString
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 24
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let date = message.sentDate
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        
        let dateString = df.string(from: date)
        let attributedDate = NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        return attributedDate
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 24
    }
}

extension ChatRoomViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        if isFromCurrentSender(message: message) {
            return UIColor.init(red: 17.0/255.0, green: 157.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        } else {
            return UIColor.init(red: 205.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(corner, .curved)
    }
}

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        // Grab the text and create a message in the thread we are in.
        guard let chatRoom = chatRoom,
            let sender = currentSender() as? Sender else { return }
        
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                _ = firebaseController?.uploadMessagesToServer(chatRoom: chatRoom, displayName: sender.displayName, id: (chatRoom.id)!, text: str, onSuccess: {
                    print("Message submitted")
                })
            }
            
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
        
//        firebaseController?.createMessage(in: chatRoom, withText: text, sender: sender, completion: {
//
//            DispatchQueue.main.async {
//                self.messagesCollectionView.reloadData()
//                self.messageInputBar.inputTextView.text = ""
//            }
//        })
    
    
}
