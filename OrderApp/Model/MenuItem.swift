//
//  MenuItem.swift
//  OrderApp
//
//  Created by Duliba Sviatoslav on 17.05.2022.
//

import Foundation

//let baseURL = URL(string: "http://localhost:8080/")!

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
