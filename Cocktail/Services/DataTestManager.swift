//
//  DataTestManager.swift
//  Cocktail
//
//  Created by Сергей Поляков on 12.01.2023.
//

import Foundation

class DataTestManager {
    
    static let share = DataTestManager()
    
    private func getIngredients() -> [Ingredient] {
        [
            Ingredient(name: "Tequila", measure: "50"),
            Ingredient(name: "Triple sec", measure: "1 1/2"),
            Ingredient(name: "Lime juice", measure: "1 oz"),
            Ingredient(name: "Salt", measure: "1")
        ]
    }
    
    private init() {}
}
