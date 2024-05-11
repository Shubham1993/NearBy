//
//  PageManager.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation

struct PageManager {
    
    var apiData: VenuesData? = nil
    var isFetching: Bool = false
    
    // i have hardcoded lat,lon as i dont have much time
    
    static var firstPageRequest : [String: String] = [
        "per_page" : "10",
        "page" : "1",
        "client_id" : "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5",
        "lat": "12.971599",
        "lon": "77.594566",
        "range": "12mi",
        "q": ""
    ]
    
    func nextPageRequest(filterText: String, page: Int, radius: Int) -> [String: String] {
        return [
            "per_page" : "10",
            "page" : "\(page)",
            "client_id" : "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5",
            "lat": "\(LocationManager.instance.getCurrentLocation()?.coordinate.latitude ?? 12.971599)",
            "lon": "\(LocationManager.instance.getCurrentLocation()?.coordinate.longitude ?? 77.594566)",
            "range": "\(radius)mi",
            "q": filterText
        ]
    }
    
}
