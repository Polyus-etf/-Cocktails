//
//  NetworkManager.swift
//  Cocktail
//
//  Created by Сергей Поляков on 11.01.2023.
//

import Foundation

enum UrlLink: String {
    case ingredientList = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
    case ingredientImage = "https://www.thecocktaildb.com/images/ingredients/gin-Medium.png"
    case drinksHeader = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImage(from url: String?, completion: @escaping(Result<Data, NetworkError>) -> Void ) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchIngredients(from url: String, completion: @escaping(Result<JsonIngredients, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "no description")
                return
            }
            
            do {
                let ingredientList = try JSONDecoder().decode(JsonIngredients.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(ingredientList))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    func fetchDrinksByIngredient(from url: String, completion: @escaping(Result<JsonDrinksByIngredient, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "no description")
                return
            }
            
            do {
                let jsonDrinks = try JSONDecoder().decode(JsonDrinksByIngredient.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonDrinks))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    
    func fetchDrinks(from url: String, completion: @escaping(Result<JsonDrinks, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "no description")
                return
            }
            
            do {
                let drink = try JSONDecoder().decode(JsonDrinks.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(drink))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}


class ImageManager {
    static var shared = ImageManager()

    private init() {}
    
    func fetchImage(from url: String?) -> Data? {
        guard let stringURL = url else { return nil }
        guard let imageURL = URL(string: stringURL) else { return nil }
        return try? Data(contentsOf: imageURL)
    }
}
