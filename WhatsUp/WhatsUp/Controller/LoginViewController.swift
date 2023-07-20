//
//  LoginViewController.swift
//  WhatsUp
//
//  Created by mohamdan on 19/07/2023.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    // MARK: - Navigation
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if error == nil {
                self?.performSegue(withIdentifier: "loginToChat", sender: self)
                print("user succesd")
            }else {
                print(error.debugDescription)
                self!.errorLabel.text = error!.localizedDescription
            }
        }
        
    }
}
