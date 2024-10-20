//
//  ShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ShoppingListBusinessLogic {
    func showFoodList(request: ShoppingList.ShoppingListModel.Request)
}

protocol ShoppingListDataStore {
    var foodList: [FoodRealm] { get }
}

class ShoppingListInteractor: ShoppingListBusinessLogic, ShoppingListDataStore {
    
    var presenter: ShoppingListPresentationLogic?
    var worker: ShoppingListWorker?
    var foodList: [FoodRealm] = []
    
    func showFoodList(request: ShoppingList.ShoppingListModel.Request) {
        worker = ShoppingListWorker()
        guard let worker = worker else { return }
        foodList = worker.getShoppintList()
        let responce = ShoppingList.ShoppingListModel.Response(food: foodList)
        presenter?.presentData(response: responce)
        
    }
}
