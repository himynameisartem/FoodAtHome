//
//  ShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation
import RealmSwift

class ShoppingListPresenter {
    
    let localRealm = try! Realm()
    
    weak var view: ShoppingListViewProtocol!
    var interactor: ShoppingListInteractorProtocol!
    var router: ShoppingListRouterProtocol!
    
    init(view: ShoppingListViewProtocol!) {
        self.view = view
    }
}

extension ShoppingListPresenter: ShoppingListPresenterProtocol {
    func viewDidLoad() {
        
    }
    
    func showFoodListViewController() {
        router.openFoodListViewController()
    }
}

extension ShoppingListPresenter: ShoppingListInteractorOutputProtocol {
    
}
