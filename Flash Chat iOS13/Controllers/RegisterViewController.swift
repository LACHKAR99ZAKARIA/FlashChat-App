//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    let auth = Auth.auth()
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text , let password = passwordTextfield.text{
            auth.createUser(withEmail: email, password: password) { authResult, error in
              // Vérifiez si l'opération de création d'utilisateur a réussi ou a échoué
              if let error = error {
                // Une erreur s'est produite, affichez un message d'erreur à l'utilisateur
                print("Erreur de création d'utilisateur: \(error.localizedDescription)")
              } else {
                print("L'utilisateur a été créé avec succès!")
                  self.performSegue(withIdentifier: K.registerSegue, sender: self)
              }
            }
        }
    }
    
}
