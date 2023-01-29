//
//  CocktailsViewController.swift
//  Cocktail
//
//  Created by Сергей Поляков on 13.01.2023.
//

import UIKit

class CocktailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ingredientPickerView: UIPickerView!
    
    
    //MARK: - Private properties
    private var jsonDrinksByIngredient: JsonDrinksByIngredient?
    private var ingredients: JsonIngredients?
    private let reuseIdentifier = "cocktail"
    private var spinnerView = UIActivityIndicatorView()
    
    //MARK: - Public properties
    
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        ingredientPickerView.delegate = self
        ingredientPickerView.dataSource = self
        
        fetchIngredient(from: "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")
        fetchDrinks(from: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=Light%20rum")
    }
    
    //MARK: - Private func
    private func fetchDrinks(from url: String) {
        NetworkManager.shared.fetchDrinksByIngredient(from: url) { result in
            switch result{
            case .success(let drinks):
                self.jsonDrinksByIngredient = drinks
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchIngredient(from url: String) {
        NetworkManager.shared.fetchIngredients(from: url) { result in
            switch result{
            case .success(let ingredients):
                self.ingredients = ingredients
                self.ingredientPickerView.reloadAllComponents()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        guard let detailedVC = segue.destination as? DetailedViewController else { return }
        detailedVC.idDrink = jsonDrinksByIngredient?.drinks[indexPath.item].idDrink
    }
}



 
 

// MARK: - UICollectionViewDataSource

extension CocktailsViewController: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonDrinksByIngredient?.drinks.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell()}
        
        cell.configure(with: jsonDrinksByIngredient?.drinks[indexPath.item])
        
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

// MARK: - UICollectionViewDelegate

//extension CocktailsViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
//}



// MARK: - Collection view delegate flow layout
extension CocktailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: collectionView.bounds.height - 50)
    }
}


// MARK: - UIPickerViewDelegate
extension CocktailsViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        ingredients?.drinks[row].strIngredient1 ?? "load data..."
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let ingredientWithSpace = ingredients?.drinks[row].strIngredient1 ?? "margarita"
        let ingredientWithoutSpace = ingredientWithSpace.replacingOccurrences(of: " ", with: "%20")
        let url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=\(ingredientWithoutSpace)"
        fetchDrinks(from: url)
    }
    
    
    
}

// MARK: - UIPickerViewDataSource
extension CocktailsViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ingredients?.drinks.count ?? 1
    }
}

