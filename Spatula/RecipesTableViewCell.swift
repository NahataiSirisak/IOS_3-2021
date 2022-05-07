//
//  RecipesTableViewCell.swift
//  Spatula
//
//  Created by Thunchanok Iacharoen on 13/3/2565 BE.
//

import UIKit
import AlamofireImage

class RecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func set(Recipes: Recipes) {
            
            if let url = URL(string: Recipes.recipeImageUrl) {
                self.recipeImageView.af.setImage(withURL: url, cacheKey: Recipes.recipeImageUrl, completion: nil)
            }
            
            self.recipeLabel.text = Recipes.recipeName
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

}
