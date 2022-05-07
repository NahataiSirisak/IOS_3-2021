//
//  HomePageViewController.swift
//  Spatula
//
//  Created by Thunchanok Iacharoen on 12/3/2565 BE.
//

import UIKit
import FirebaseAuth
import Firebase

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipeTableView: UITableView!
    var recipesItem: [Recipes] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerCell()
        self.recipeTableView.dataSource = self
        self.recipeTableView.delegate = self
    }

    @IBAction func addRecipeButtonClicked(_ sender: UIButton) {
        sender.pulsate()
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddRecipe") as? AddRecipeViewController {
            self.present(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            let db = Firestore.firestore()
            db.collection("recipes").getDocuments(completion: { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    
                    if let querySnapshot = querySnapshot {
                        self.recipesItem = querySnapshot.documents.map({ item in
                            return Recipes(recipeImageUrl: item["recipeImageUrl"] as? String ?? "",
                                           recipeName: item["recipeName"] as? String ?? "",
                                           recipeCategory: item["recipeCategory"] as? String ?? "",
                                           recipeDescription: item["recipeDescription"] as? String ?? "",
                                           recipeIngredient: item["recipeIngredient"] as? String ?? "",
                                           recipeInstruction: item["recipeInstruction"] as? String ?? "",
                                           uid: item["uid"] as? String ?? "")
                        })
                    }
                    self.recipeTableView.reloadData()
                }
            })
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipescell") as? RecipesTableViewCell {
                    cell.set(Recipes: self.recipesItem[indexPath.row])
                    return cell
                }
                return UITableViewCell()
    }
    
    func registerCell() {
            self.recipeTableView.register(UINib(nibName: "RecipesTableViewCell", bundle: .main), forCellReuseIdentifier: "RecipesTableViewCell")
    }
}

