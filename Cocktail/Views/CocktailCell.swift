//
//  CocktailCell.swift
//  Cocktail
//
//  Created by Сергей Поляков on 13.01.2023.
//

import UIKit

class CocktailCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cocktailImageView: UIImageView! {
        didSet {
            cocktailImageView.layer.cornerRadius = 10
            cocktailImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var cocktailNameLabel: UILabel! {
        didSet {
            cocktailNameLabel.textColor = .gray
        }
    }
    
    // MARK: - Public methods
    func configure(with drink: JsonDrinkByIngredient?) {
        cocktailNameLabel.text = drink?.strDrink
        fetchImage(from: drink?.strDrinkThumb ?? "")
    }
    
    // MARK: - Private methods
    private func fetchImage(from url: String) {
        NetworkManager.shared.fetchImage(from: url) { [weak self] result in
            switch result {
            case .success(let imageDate):
                self?.cocktailImageView.image = UIImage(data: imageDate)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
