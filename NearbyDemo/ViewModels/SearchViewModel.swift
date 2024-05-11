//
//  SearchViewModel.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation

enum SearchEvent{
    case noEvent
    case reload
    case error(Error)
}

protocol SearchViewModel{
    
    var currentPage: Int { get set }
    var numberOfSection: Int { get }
    var numberOfCells: Int { get }
    var observer: Observable<SearchEvent> { get set }
    func item(at index: IndexPath) -> Venues
    func fetchBatch(page: Int)
    func updateRadius(_ value: Int)
}

class SearchViewModelImp: SearchViewModel {
    
    private var nearbyUseCase: NearbyUseCase
    private var venuAPIDataPage: PageManager? = nil
    private var distance = 12
    private var unfilteredItems: [Venues] = []
    private var items: [Venues] = []
    var currentPage: Int = 1

    var numberOfSection: Int {
        return 1
    }
    
    var numberOfCells: Int{
        return items.count
    }
    
    var observer: Observable<SearchEvent> = Observable<SearchEvent>(.noEvent)
    
    func item(at index: IndexPath) -> Venues{
        items[index.item]
    }
    
    func updateRadius(_ value: Int) {
        self.distance = value
        self.unfilteredItems = []
        fetchBatch(page: 1)
    }
    
    init(nearbyUseCase: NearbyUseCase, venuAPIDataPage: PageManager? = nil) {
        self.nearbyUseCase = nearbyUseCase
        self.venuAPIDataPage = venuAPIDataPage
        self.unfilteredItems = venuAPIDataPage?.apiData?.venues ?? []
        self.items = unfilteredItems
    }
    
    private func updateItems(data: VenuesData){
        unfilteredItems.append(contentsOf: data.venues)
        self.items = filteredData()
        self.currentPage = data.meta.page
        venuAPIDataPage = PageManager(apiData: data, isFetching: false)
        observer.value = .reload
    }
    
    private func filteredData()->[Venues]{
        //we can apply filter logic here
        return unfilteredItems.filter{ _ in true }
    }
    
    func fetchBatch(page: Int) {
        guard !(venuAPIDataPage?.isFetching ?? false) else{
            return
        }
        
        venuAPIDataPage?.isFetching = true
        
        var param = venuAPIDataPage?.nextPageRequest(filterText: "", page: page, radius: self.distance) ?? PageManager.firstPageRequest
        nearbyUseCase.fetchLocations(api: .search(param: param)) {[weak self] result in
            switch result {
            case .success(let data):
                self?.updateItems(data: data)
            case .failure(let failure):
                self?.venuAPIDataPage?.isFetching = false
                print(failure)
            }
        }
    }
}

