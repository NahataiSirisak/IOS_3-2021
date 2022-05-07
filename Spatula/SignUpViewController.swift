//
//  SignUpViewController.swift
//  Spatula
//
//  Created by Thunchanok Iacharoen on 13/3/2565 BE.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createAccount(_ sender: Any) {
        let db = Firestore.firestore()
        guard let username = usernameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let image = imageView.image, !username.isEmpty, !email.isEmpty, !password.isEmpty else {

            let alert = UIAlertController(title: "Invalid Input", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in

            if let error = error {
                let alert = UIAlertController(title: "Unable to create a user", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let result = result {
                    ImageUploader.uploadImage(image: image) { url in
                        // Saving data into database
                        db.collection("users").document(result.user.uid).setData([
                            "profileImageUrl": url,
                            "username": username,
                            "email": email,
                            "password": password.lowercased(),
                            "uid": result.user.uid]) { _ in
                                print("Successfully upload user data")
                            }
                    }
                }
            }
        })
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
