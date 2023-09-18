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
    var shoppingListCounter: Int {
        shoppingList.count
    }
    
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
    
    func removeAllFood() {
        for i in shoppingList {
            if i.isShoppingList {
                try! localRealm.write({
                    localRealm.delete(i)
                })
            }
        }
    }
    
    func food(at index: IndexPath) -> FoodRealm {
        shoppingList[index.row]
    }
}

extension ShoppingListPresenter: ShoppingListInteractorOutputProtocol {
    func shoppingListDidRecieve(_ food: [FoodRealm]) {
        self.shoppingList = food
        view.reloadData()
    }
}
