//
//  HiveUser.swift
//  ShelterHiveApp
//
//  Created by Alondra Correa on 11/22/23.
//

import Foundation

struct HiveUser: Identifiable, Codable {
    var id: String // user id
    let fullName: String
    let email: String
    
    let reviews: [Review]
    let opportunities: [VolunteerOpportunity]
}

struct Review: Codable {
    let locationName: String
    let reviewText: String
}

struct VolunteerOpportunity: Codable {
    let title: String
    let date: String
    let duty: String
    let locationName: String
}

