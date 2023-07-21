//
//  ChatViewController.swift
//  WhatsUp
//
//  Created by mohamdan on 19/07/2023.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages = [Message]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        messageTextField.delegate = self
        tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "senderCell")
        tableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "receiverCell")
        readMessage()
        navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
       
        let message = Message(sender: Auth.auth().currentUser?.email, body: messageTextField.text!)
        saveMessage(message)
        messages.append(message)
        tableView.reloadData()
        messageTextField.text = nil
    }

}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell", for: indexPath) as! SenderTableViewCell
            cell.label.text = messages[indexPath.row].body
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "receiverCell", for: indexPath) as! ReceiverTableViewCell
            cell.label.text = messages[indexPath.row].body
            return cell
        }
        
    }
    
    func saveMessage (_ message : Message){
        var ref: DocumentReference? = nil
        ref = db.collection("cities").addDocument(data: [
            "body": message.body!,
            "sender": message.sender!,
            "time": Date().timeIntervalSince1970
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func readMessage(){
        db.collection("messages").order(by: "time").addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
            
            self.messages.removeAll()
            
            for doc in documents {
                let msgBody = doc.data()["body"] as! String
                let msgSender = doc.data()["sender"] as! String
                let msgs = Message(sender: msgSender, body: msgBody)
                self.messages.append(msgs)
                self.tableView.reloadData()
            }
            
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            if indexPath.row > 5 {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            }
    }
}

extension ChatViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let message = Message(sender: Auth.auth().currentUser?.email, body: messageTextField.text!)
        saveMessage(message)
        messages.append(message)
        tableView.reloadData()
        messageTextField.text = nil
        return true
    }
}
