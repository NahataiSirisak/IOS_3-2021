//
//  LoginViewController.swift
//  Spatula
//
//  Created by Thunchanok Iacharoen on 11/3/2565 BE.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.isSecureTextEntry = true
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        if let email: String = emailTextField.text, !email.isEmpty, let password: String = passwordTextField.text, !password.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    let alert = UIAlertController(title: "Authentication failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if let result = result {
                        print("\(String(describing: result.user.email))")
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController {
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController {
            self.present(vc, animated: true)
        }
    }
}
