//
//  CategoryDetailsInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsBusinessLogic {
    func showCategory(request: CategoryDetails.ShowCategory.Request)
    func showCells(request: CategoryDetails.ShowFood.Request)
}

protocol CategoryDetailsDataStore {
    var food: [FoodRealm] { get set }
    var category: String { get set }
}

class CategoryDetailsInteractor: CategoryDetailsBusinessLogic, CategoryDetailsDataStore {
    
    var category = String()
    var presenter: CategoryDetailsPresentationLogic?
    var food: [FoodRealm] = []
    
    func showCategory(request: CategoryDetails.ShowCategory.Request) {
        let responce = CategoryDetails.ShowCategory.Responce(category: category)
        presenter?.presentCategory(responce: responce)
    }
    
    func showCells(request: CategoryDetails.ShowFood.Request) {
        let responce = CategoryDetails.ShowFood.Response(food: food)
        presenter?.presentCells(response: responce)
    }
    
}
