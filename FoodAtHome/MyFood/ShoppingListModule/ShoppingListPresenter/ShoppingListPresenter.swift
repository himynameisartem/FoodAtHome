//
//  ShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation
import RealmSwift

class ShoppingListPresenter {
    
    let localRealm = FoodManager.shared.getRealm()
    
    var shoppingList: [FoodRealm] = []
    
    weak var view: ShoppingListViewProtocol!
    var interactor: ShoppingListInteractorProtocol!
    var router: ShoppingListRouterProtocol!
    
    init(view: ShoppingListViewProtocol!) {
        self.view = view
    }
}

extension ShoppingListPresenter: ShoppingListPresenterProtocol {
    func viewDidLoad() {
        interactor.fetchShoppingList()
    }
    
    func showFoodListViewController() {
        router.openFoodListViewController()
    }
}

extension ShoppingListPresenter: ShoppingListInteractorOutputProtocol {
    func shoppingListDidRecieve(_ food: [FoodRealm]) {
        self.shoppingList = food
    }
}
