//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    let auth = Auth.auth()
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text , let password = passwordTextfield.text{
            auth.signIn(withEmail: email, password: password) { authResult, error in
              // Vérifiez si l'opération de connexion a réussi ou a échoué
              if let error = error {
                // Une erreur s'est produite, affichez un message d'erreur à l'utilisateur
                print("Erreur de connexion: \(error.localizedDescription)")
              } else {
                // L'opération de connexion a réussi, vous pouvez maintenant utiliser l'objet authResult pour accéder aux informations sur l'utilisateur connecté
                print("L'utilisateur a été connecté avec succès!")
                self.performSegue(withIdentifier: K.loginSegue, sender: self)
              }
            }
        }
    }
    
}
