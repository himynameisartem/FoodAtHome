//
//  AddFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodBusinessLogic {
    func showFood(request: AddFoodModel.ShowFood.Request)
    func handleCloseRequest()
}

protocol AddFoodDataStore {
    var food: FoodRealm { get set }
}

class AddFoodInteractor: AddFoodBusinessLogic, AddFoodDataStore {
    
    var presenter: AddFoodPresentationLogic?
    var food = FoodRealm()
    
    func showFood(request: AddFoodModel.ShowFood.Request) {
        let responce = AddFoodModel.ShowFood.Response(food: food)
        presenter?.presentData(response: responce)
    }
    
    func handleCloseRequest() {
        presenter?.presentCloseAnimation()
    }
    
}
