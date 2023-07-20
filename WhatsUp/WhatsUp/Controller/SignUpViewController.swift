//
//  SignUpViewController.swift
//  WhatsUp
//
//  Created by mohamdan on 19/07/2023.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error == nil {
                print("user succesd")
            }else {
                print(error.debugDescription)
                self.errorLabel.text = error!.localizedDescription
            }
        }
        
    }
}
