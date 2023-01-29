//
//  IngredientCell.swift
//  Cocktail
//
//  Created by Сергей Поляков on 12.01.2023.
//

import UIKit

class IngredientCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var ingredientImageView: UIImageView! {
        didSet {
            ingredientImageView.clipsToBounds = true
            ingredientImageView.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var ingredientMeasureLabel: UILabel!
    
    
    // MARK: - Public methods
    func configure(with ingridient: Ingredient?) {
        
        ingredientNameLabel.textColor = .gray
        ingredientNameLabel.text = ingridient?.name ?? "Margarita"
        
        ingredientMeasureLabel.textColor = .lightGray
        ingredientMeasureLabel.text = ingridient?.measure ?? ""
        
        DispatchQueue.global().async {
            guard let stringUrl = ingridient?.imageUrl else { return }
            guard let imageUrl = URL(string: stringUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else {
                print("ERRRRRRRRRRR")
                return }
            DispatchQueue.main.async {
                self.ingredientImageView.image = UIImage(data: imageData)
            }
        }
    }

    

}
