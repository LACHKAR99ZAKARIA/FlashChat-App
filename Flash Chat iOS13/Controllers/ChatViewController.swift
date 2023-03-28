//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//


import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var messages : [Message] = [
        Message(sender: "z@z.com", body: "hey"),
        Message(sender: "y@z.com", body: "Hello"),
        Message(sender: "l@z.com", body: "hi"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        title = K.appName
        
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMsg()
    }
    
    func loadMsg(){
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                var messages : [Message] = []
                    // Une erreur s'est produite, affichez un message d'erreur à l'utilisateur
                    print("Erreur lors de la récupération des documents: \(error.localizedDescription)")
                } else {
                    // Les documents ont été modifiés
                    self.messages = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        // Traitez les données du document ici
                        print("Données du document: \(data)")
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let message = Message(sender: messageSender, body: messageBody)
                            self.messages.append(message)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    @IBAction func logOutClick(_ sender: UIBarButtonItem) {
        do {
          try auth.signOut()
          print("L'utilisateur a été déconnecté avec succès!")
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Erreur de déconnexion: \(signOutError.localizedDescription)")
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text , let messageSender = auth.currentUser?.email{
            print(messageBody)
            print(messageSender)
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField : messageBody,
                K.FStore.dateField : Date().timeIntervalSince1970
            ]) { error in
                if let error = error {
                  // Une erreur s'est produite, affichez un message d'erreur à l'utilisateur
                  print("Erreur lors de l'envoi des données à Firebase: \(error.localizedDescription)")
                } else {
                  // Les données ont été envoyées avec succès à Firebase
                  print("Les données ont été envoyées avec succès à Firebase!")
                }
              }
        }
    }
}


extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create a table view cell to return
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        //give the cell data
        cell.label.text = messages[indexPath.row].body
        
        //return the cell
        return cell
    }
    
    
}

/*extension ChatViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I'm selected")
    }
}*/
