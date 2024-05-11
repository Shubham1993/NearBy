//
//  Meta.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation

struct Meta : Codable {
    
    let total : Int
    let took : Int
    let page : Int
    let perPage : Int
    let geolocation : Geolocation?

    enum CodingKeys: String, CodingKey {

        case total, took, page, geolocation
        case perPage = "per_page"
    }

}
