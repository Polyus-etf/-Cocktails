//
//  DetailedViewController.swift
//  Cocktail
//
//  Created by Сергей Поляков on 11.01.2023.
//

import UIKit

class DetailedViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private let width = (UIScreen.main.bounds.width - 16 - 16 - 10 - 10) / 3
    private var drink: JsonDrink?
    private var ingredient: [Ingredient] = []
    
    // MARK: - Public propertie
    public var idDrink: String?
    
    // MARK: - Override"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        descriptionLabel.textColor = .darkGray
        fetchDrink(from: "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(idDrink ?? "11007")")
        
    }
    
    //MARK: - Private func
    private func fetchDrink(from url: String) {
        NetworkManager.shared.fetchDrinks(from: url) { result in
            switch result{
            case .success(let drink):
                self.drink = drink.drinks.first
                self.fetchImage(from: drink.drinks.first?.strDrinkThumb ?? "")
                self.descriptionLabel.text = drink.drinks.first?.strInstructions
                self.ingredient = self.setIngridient(from: drink.drinks.first!)
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchImage(from url: String) {
        let data = ImageManager.shared.fetchImage(from: url)
        imageView.image = UIImage(data: data!)
    }
    
    
    
    private func setIngridient(from drink: JsonDrink) -> [Ingredient] {
        var ingredient: [Ingredient] = []
        
        if let name = drink.strIngredient1 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure1 ?? ""))
            }
        }
        if let name = drink.strIngredient2 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure2 ?? ""))
            }
        }
        if let name = drink.strIngredient3 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure3 ?? ""))
            }
        }
        if let name = drink.strIngredient4 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure4 ?? ""))
            }
        }
        if let name = drink.strIngredient5 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure5 ?? ""))
            }
        }
        if let name = drink.strIngredient6 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure6 ?? ""))
            }
        }
        if let name = drink.strIngredient7 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure7 ?? ""))
            }
        }
        if let name = drink.strIngredient8 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure8 ?? ""))
            }
        }
        if let name = drink.strIngredient9 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure9 ?? ""))
            }
        }
        if let name = drink.strIngredient10 {
            if name != "" {
                ingredient.append(Ingredient(name: name, measure: drink.strMeasure10 ?? ""))
            }
        }
        
        return ingredient
    }
}

// MARK: - Collection view delegate
extension DetailedViewController: UICollectionViewDelegate {
    
}

// MARK: - Collection view data source
extension DetailedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ingredient.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? IngredientCell else { return UICollectionViewCell() }
        
        cell.configure(with: ingredient[indexPath.row])
        
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 5, height: 8)
        cell.layer.shadowRadius = 9.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        
        return cell
    }
}

// MARK: - Collection view delegate flow layout
extension DetailedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: width, height: collectionView.bounds.height - 50)
    }
}
