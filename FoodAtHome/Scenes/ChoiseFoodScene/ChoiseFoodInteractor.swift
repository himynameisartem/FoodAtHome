//
//  ChoiseFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChoiseFoodBusinessLogic {
    func showCategories(request: ChoiseFood.ShowCategoriesFood.Request)
    func showFoodList(request: ChoiseFood.ShowFood.Request)
}

protocol ChoiseFoodDataStore {
    var categoriesName: [String] { get }
    var food: [FoodRealm] { get }
}

class ChoiseFoodInteractor: ChoiseFoodBusinessLogic, ChoiseFoodDataStore {
    
    var presenter: ChoiseFoodPresentationLogic?
    var worker: ChoiseFoodWorker?
    
    var categoriesName = FoodType.allCases.map {$0.rawValue.localized()}
    var food: [FoodRealm] = []
    
    func showCategories(request: ChoiseFood.ShowCategoriesFood.Request) {
        let responce = ChoiseFood.ShowCategoriesFood.Response(categoriesName: categoriesName)
        presenter?.presentCategories(responce: responce)
    }
    
    func showFoodList(request: ChoiseFood.ShowFood.Request) {
        worker = ChoiseFoodWorker()
        if request.category != nil {
            guard let food = worker?.showFood(from: request.category) else { return }
            let responce = ChoiseFood.ShowFood.Response(food: food)
            presenter?.presentFood(response: responce)
        } else if request.name != nil {
            guard let serachText = request.name else { return }
            let filteredFoodList = FoodManager.shared.allFood.filter { (food: FoodRealm) in
                return food.name.localized().lowercased().contains(serachText.lowercased())
            }
            let array = Array(filteredFoodList)
            let responce = ChoiseFood.ShowFood.Response(food: array)
            presenter?.presentFood(response: responce)
        }
    }
}
