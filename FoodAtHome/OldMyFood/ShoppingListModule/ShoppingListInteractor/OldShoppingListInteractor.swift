//
//  ShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation

class OldShoppingListInteractor {
    
    weak var presenter: OldShoppingListInteractorOutputProtocol!
    
    required init(presenter: OldShoppingListInteractorOutputProtocol) {
        self.presenter = presenter
    }
}

extension OldShoppingListInteractor: OldShoppingListInteractorProtocol {
    func fetchShoppingList() {
//        presenter.shoppingListDidRecieve(FoodManager.shared.fetchMyShoppingList())
    }
    
    func fetchFoodList() {
//        presenter.foodListDidRecieve(FoodManager.shared.fetchMyFoodList())
    }
    
    func fetchAllFood() {
//        presenter.allFoodDidRecieve(FoodManager.shared.fetchAllFood())
    }
}
