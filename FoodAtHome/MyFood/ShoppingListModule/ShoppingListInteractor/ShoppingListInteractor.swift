//
//  ShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation

class ShoppingListInteractor {
    
    weak var presenter: ShoppingListInteractorOutputProtocol!
    
    required init(presenter: ShoppingListInteractorOutputProtocol) {
        self.presenter = presenter
    }
}

extension ShoppingListInteractor: ShoppingListInteractorProtocol {
    func fetchShoppingList() {
        presenter.shoppingListDidRecieve(FoodManager.shared.fetchMyShoppingList())
    }
}
