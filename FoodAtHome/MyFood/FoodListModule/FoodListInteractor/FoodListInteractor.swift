//
//  FoodListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

class FoodListInteractor {
    weak var presenter: FoodListInteractorOutputProtocol!
    
    init(presenter: FoodListInteractorOutputProtocol!) {
        self.presenter = presenter
    }
}


extension FoodListInteractor: FoodListInteractorProtocol {
    func filterContentForSearchText(_ searchText: String) {
        let filteredFoodList = allFood.filter { (food: FoodRealm) in
            return food.name.lowercased().contains(searchText.lowercased())
        }
        presenter.didFilterFood(filteredFoodList)
    }
    
    func fetchMyFood() {
        presenter.foodDidRecieve(FoodManager.shared.fetchMyFood())
    }
    
    func fetchShoopingList() {
        presenter.shoppingListDidRecieve(FoodManager.shared.fetchMyShoppingList())
    }
}
