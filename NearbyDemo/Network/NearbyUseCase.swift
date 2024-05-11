//
//  NearbyUseCase.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation

protocol NearbyUseCase{
    
    var apiManager: NetworkRepoType { get }
    
    func fetchLocations(api: API, callback: @escaping ((Result<VenuesData, APIError>) -> Void))
    
}


final class NearbyUseCaseImpl: NearbyUseCase {
    
    let apiManager: NetworkRepoType
    
    init(apiManager: NetworkRepoType) {
        self.apiManager = apiManager
    }
    
    func fetchLocations(api: API, callback: @escaping ((Result<VenuesData, APIError>) -> Void)) {
        apiManager.getAPIResponse(api: api, callback: callback)
    }
}
