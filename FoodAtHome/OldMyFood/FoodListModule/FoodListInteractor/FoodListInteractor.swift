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
        let filteredFoodList = FoodManager.shared.allFood.filter { (food: FoodRealm) in
            return food.name.localized().lowercased().contains(searchText.lowercased())
        }
        let array = Array(filteredFoodList)
        presenter.didFilterFood(array)
    }
    
    func fetchMyFood() {
        presenter.foodDidRecieve(FoodManager.shared.fetchMyFoodList())
    }
    
    func fetchShoopingList() {
        presenter.shoppingListDidRecieve(FoodManager.shared.fetchMyShoppingList())
    }
}
