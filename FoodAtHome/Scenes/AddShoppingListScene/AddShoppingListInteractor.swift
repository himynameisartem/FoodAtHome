//
//  AddShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListBusinessLogic {
    func makeRequest(request: AddShoppingList.Model.Request)
}

protocol AddShoppingListDataStore {
    var food: FoodRealm { get set }
}

class AddShoppingListInteractor: AddShoppingListBusinessLogic, AddShoppingListDataStore {
    
    var presenter: AddShoppingListPresentationLogic?
    var worker: AddShoppingListWorker?
    var food = FoodRealm()
    
    func makeRequest(request: AddShoppingList.Model.Request) {
        
    }
}
