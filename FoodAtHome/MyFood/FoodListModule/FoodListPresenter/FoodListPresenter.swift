//
//  FoodListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.07.2023.
//

import Foundation

class FoodListPresenter {
    
    weak var view: FoodListViewProtocol!
    var interactor: FoodListInteractorProtocol!
    var router: FoodListRouterProtocol!
    
    init(view: FoodListViewProtocol!) {
        self.view = view
    }
}

extension FoodListPresenter: FoodListPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func tappedSearch() {
        view.showSearchBar()
    }
    
    func updateSearchResults(for searchText: String) {
        interactor.filterContentForSearchText(searchText)
    }
    
    func selectedCategories(at indexPath: IndexPath) -> [FoodRealm] {
        FoodListManager.shared.choiseCategories(for: indexPath.row)
    }
}

extension FoodListPresenter: FoodListInteractorOutputProtocol {
    
    func didFetchFood(_ foodList: [FoodRealm]) {
        
    }

    func didFilterFood(_ filteredFoodList: [FoodRealm]) {
        view.dysplayFilteredFood(filteredFoodList)
        view.reloadData()
    }
}
