//
//  MenuController.swift
//  OrderApp
//
//  Created by Duliba Sviatoslav on 18.05.2022.
//

import Foundation

class MenuController {
    static let shared = MenuController()
    let baseURL = URL(string: "http://localhost:8080/")!
    
    enum MenuControllerError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
    }
    
    func fetchMenuItems(forCategory categoryName: String) async throws ->
        [MenuItem] {

            let baseMenuURL = baseURL.appendingPathComponent("menu")
            var components = URLComponents(url: baseMenuURL,
                                           resolvingAgainstBaseURL: true)!
            components.queryItems = [URLQueryItem(name: "category",
                                                  value: categoryName)]
            let menuURL = components.url!

            let (data, response) = try await URLSession.shared.data(from: menuURL)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                      throw MenuControllerError.menuItemsNotFound
                  }
            let decoder = JSONDecoder()
            let menuResponse = try decoder.decode(MenuResponse.self, from: data)

            return menuResponse.items
        }

    
    func fetchCategories() async throws -> [String] {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        let (data, response) = try await URLSession.shared.data(from:
                                                                    categoriesURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw MenuControllerError.categoriesNotFound
              }
        let decoder = JSONDecoder()
        let categoriesResponse = try decoder.decode(CategoriesResponse.self,
                                                    from: data)
        
        return categoriesResponse.categories
    }
}
