//
//  CategoryDetailsInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsBusinessLogic {
    func makeRequest(request: CategoryDetails.ShowDetails.Request)
}

protocol CategoryDetailsDataStore {
    var food: [FoodRealm] { get }
}

class CategoryDetailsInteractor: CategoryDetailsBusinessLogic, CategoryDetailsDataStore {
    
    var presenter: CategoryDetailsPresentationLogic?    
    var food: [FoodRealm] = []
    
    func makeRequest(request: CategoryDetails.ShowDetails.Request) {
        let responce = CategoryDetails.ShowDetails.Response(food: food)
        presenter?.presentData(response: responce)
    }
    
}
