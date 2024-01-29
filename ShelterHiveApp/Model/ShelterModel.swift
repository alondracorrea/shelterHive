//
//  ShelterModel.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 12/13/23.
//

import Foundation

struct ShelterModel: Codable {
    let businesses: [Business]
    let total: Int
    
    var firstFiveBusinesses: [Business] {
            return Array(businesses.prefix(5))
        }
}

struct Business: Codable {
    let display_phone: String?
    let distance: Double
    let id: String
    let location: Location
    let name: String
    let phone: String?
    let price: String?
    let rating: Double
    let reviewCount: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case display_phone, distance, id, location, name, phone, price, rating
        case reviewCount = "review_count" // Map "review_count" to "reviewCount"
        case url
    }
}

struct Location: Codable {
    let address1: String
    let address2: String?
    let address3: String?
    let city: String
    let display_address: [String]?
    let state: String
    let zip_code: String
}
