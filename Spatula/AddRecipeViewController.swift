//
//  AddRecipeViewController.swift
//  Spatula
//
//  Created by Thunchanok Iacharoen on 13/3/2565 BE.
//

import UIKit
import FirebaseAuth
import Firebase

class AddRecipeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    @IBOutlet weak var shapeBG: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var ingredientTextField: UITextView!
    @IBOutlet weak var instructionTextField: UITextView!
    
    var selectedCategory: String = ""
    var categoryList = ["Breakfast & Brunch", "Soup", "Salad", "Appetizer", "Main", "Side", "Dessert", "Small Bites/Snacks", "Drinks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
    }

    @IBAction func addRecipeImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        shapeBG.isHidden = true
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let db = Firestore.firestore()
        guard let name = nameTextField.text, let category = categoriesTextField.text, let description = descriptionTextField.text, let ingredient = ingredientTextField.text, let instruction = instructionTextField.text, let image = imageView.image, !name.isEmpty, !category.isEmpty, !description.isEmpty, !ingredient.isEmpty, !instruction.isEmpty else {
            
            let alert = UIAlertController(title: "Invalid Input", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
//        let user = Auth.auth().currentUser
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                ImageUploader.uploadImage(image: image) { url in
                    db.collection("recipes").document().setData([
                        "recipeImageUrl": url,
                        "name": name,
                        "category": category,
                        "description": description,
                        "ingredient": ingredient,
                        "instruction": instruction,
                        "uid": user.uid]) { _ in
                            print("Successfully upload recipe data")
                        }
                }
            }
        }
    }
}

extension AddRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension AddRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categoryList[row]
        categoriesTextField.text = selectedCategory
    }
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           categoriesTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       categoriesTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
}
