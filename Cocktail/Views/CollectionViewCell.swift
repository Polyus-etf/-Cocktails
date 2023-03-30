//
//  CollectionViewCell.swift
//  Cocktail
//
//  Created by Сергей Поляков on 13.01.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cocktailImageView: UIImageView! {
        didSet {
            cocktailImageView.layer.cornerRadius = 15
            cocktailImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    // MARK: - Public methods
    func configure(with drink: JsonDrinkByIngredient?) {
        cocktailNameLabel.text = drink?.strDrink
        cocktailNameLabel.textColor = .gray
        DispatchQueue.global().async {
            guard let stringUrl = drink?.strDrinkThumb else { return }
            guard let imageUrl = URL(string: stringUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                self.cocktailImageView.image = UIImage(data: imageData)
            }
        }
    }
}
