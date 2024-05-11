//
//  Venues.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation

struct Venues : Codable {
    
    let state : String?
    let nameV2 : String?
    let postalCode : String?
    let name : String?
    let links : [String]?
    let timezone : String?
    let url : String?
    let score : Int?
    let location : Location?
    let address : String?
    let country : String?
    let hasUpcomingEvents : Bool?
    let numUpcomingEvents : Int?
    let city : String?
    let slug : String?
    let extendedAddress : String?
    let stats : Stats?
    let id : Int?
    let popularity : Int?
    let accessMethod : String?
    let metroCode : Int?
    let capacity : Int?
    let displayLocation : String?

    enum CodingKeys: String, CodingKey {

        case state, name, links, timezone, url, score, location, address, country, city, slug, stats, id, popularity, capacity
        case nameV2 = "name_v2"
        case postalCode = "postal_code"
        case hasUpcomingEvents = "has_upcoming_events"
        case numUpcomingEvents = "num_upcoming_events"
        case extendedAddress = "extended_address"
        case accessMethod = "access_method"
        case metroCode = "metro_code"
        case displayLocation = "display_location"
    }
}

struct Stats : Codable {
    
    let eventCount : Int

    enum CodingKeys: String, CodingKey {

        case eventCount = "event_count"
    }

}
