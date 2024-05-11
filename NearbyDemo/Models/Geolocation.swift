//
//  Geolocation.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation

struct Geolocation : Codable {
    
    let lat : Double
    let lon : Double
    let city : String?
    let state : String?
    let country : String?
    let postalCode : String?
    let displayName : String?
    let metroCode : String?
    let range : String?

    enum CodingKeys: String, CodingKey {
        case lat, lon, city, state, country, range
        case postalCode = "postal_code"
        case displayName = "display_name"
        case metroCode = "metro_code"
    }

}
