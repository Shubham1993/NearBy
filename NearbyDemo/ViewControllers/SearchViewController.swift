//
//  ViewController.swift
//  NearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slider: UISlider!
    
    var viewModel: SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //temp work to run
        viewModel = SearchViewModelImp(nearbyUseCase: NearbyUseCaseImpl(apiManager: NetworkManager()))
        self.viewModel.observer.bind {[weak self] event in
            self?.listenEvent(event)
        }
        self.viewModel.fetchBatch(page: 1)
        
        
    }

    private func listenEvent(_ event: SearchEvent){
        switch event {
        case .noEvent:
            break
        case .reload:
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        case .error(let error):
            print(error)
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        viewModel.updateRadius(currentValue)
    }
}


extension SearchViewController: UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell{
            cell.configure(model: viewModel.item(at: indexPath))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        let loader = UIActivityIndicatorView(style: .large)
        view.addSubview(loader)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
}


extension SearchViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
//        viewModel.fetchBatch(page: 2)
//    }
}


extension SearchViewController: UISearchBarDelegate{
    
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y

        if yOffset + scrollViewHeight >= contentHeight {
            viewModel.fetchBatch(page: viewModel.currentPage + 1)
        }
    }
}
