//
//  MenuController.swift
//  OrderApp
//
//  Created by Duliba Sviatoslav on 18.05.2022.
//

import Foundation

class MenuController {
    let baseURL = URL(string: "http://localhost:8080/")!
    
    enum MenuControllerError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
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
    
    //typealias MinutesToPrepare = Int
    //
    //func submitOrder(forMenuIDs menuIDs: [Int]) async throws ->
    //   MinutesToPrepare {
    //    let orderURL = baseURL.appendingPathComponent("order")
    //    var request = URLRequest(url: orderURL)
    //    request.httpMethod = "POST"
    //    request.setValue("application/json", forHTTPHeaderField:
    //       "Content-Type")
    //
    //    let menuIdsDict = ["menuIds": menuIDs]
    //    let jsonEncoder = JSONEncoder()
    //    let jsonData = try? jsonEncoder.encode(menuIdsDict)
    //    request.httpBody = jsonData
    //
    //    let (data, response) = try await URLSession.shared.data(for:
    //       request)
    //}
    
}
