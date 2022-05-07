//
//  ViewController.swift
//  Spatula
//
//  Created by Thunchanok Iacharoen on 10/3/2565 BE.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var smallBlob: UIImageView!
    @IBOutlet weak var bigBlob: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 1, animations: {
            self.smallBlob.frame.origin.y -= 150
            self.bigBlob.frame.origin.y += 150
        }){_ in
            UIView.animate(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
                self.smallBlob.frame.origin.y += 150
                self.bigBlob.frame.origin.y -= 150
            })
        }
        
//        if Auth.auth().currentUser != nil {
//          // User is signed in.
//          // ...
//        } else {
//          // No user is signed in.
//          // ...
//        }
        
    }

    @IBAction func getStartButtonClicked(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
}

