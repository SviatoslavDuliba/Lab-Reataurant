//
//  MenuItem.swift
//  OrderApp
//
//  Created by Duliba Sviatoslav on 17.05.2022.
//

import Foundation

let baseURL = URL(string: "http://localhost:8080/")!

struct MenuItem: Codable {
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category: String
    var imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
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
              
              //    let initialMenuURL = baseURL.appendingPathComponent("menu")
              //    var components = URLComponents(url: initialMenuURL,
              //       resolvingAgainstBaseURL: true)!
              //    components.queryItems = [URLQueryItem(name: "category",
              //       value: categoryName)]
              //    let menuURL = components.url!
              //    let (data, response) = try await URLSession.shared.data(from:
              //       menuURL)
          }
    let decoder = JSONDecoder()
    let menuResponse = try decoder.decode(MenuResponse.self, from: data)
    
    return menuResponse.items
    enum MenuControllerError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
        
    }
    
    typealias MinutesToPrepare = Int
    
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        let menuIdsDict = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw MenuControllerError.orderRequestFailed
              }
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)
        return orderResponse.prepTime
    }
}
