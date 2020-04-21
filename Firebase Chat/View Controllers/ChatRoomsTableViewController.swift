//
//  ChatRoomsTableViewController.swift
//  Firebase Chat
//
//  Created by Wyatt Harrell on 4/21/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import MessageKit

class ChatRoomsTableViewController: UITableViewController {

    let chatRoomsController = ChatRoomsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : String], let currentUser = Sender(dictionary: currentUserDictionary) {
            self.chatRoomsController.currentUser = currentUser
        } else {
            let alert = UIAlertController(title: "Create A Username", message: nil, preferredStyle: .alert)
            
            var usernameTextField: UITextField!
            alert.addTextField { (textField) in
                usernameTextField = textField
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
                let displayName = usernameTextField.text ?? "No name"
                let id = UUID().uuidString
                
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
                self.chatRoomsController.currentUser = sender
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRoomsController.chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = chatRoomsController.chatRooms[indexPath.row].title

        return cell
    }

    
    

    #warning("SETUP SEGUE")
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
