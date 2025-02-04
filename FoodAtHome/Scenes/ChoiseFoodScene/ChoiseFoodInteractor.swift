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
//    func showAddFoodMenu(request: ChoiseFood.AddFood.Request)
}

protocol ChoiseFoodDataStore {
    var categoriesName: [String] { get }
    var food: [FoodItem] { get }
    var addFood: FoodRealm { get }
}

class ChoiseFoodInteractor: ChoiseFoodBusinessLogic, ChoiseFoodDataStore {
    
    var presenter: ChoiseFoodPresentationLogic?
    var worker: ChoiseFoodWorker?
    
    var categoriesName = FoodType.allCases.map {$0.rawValue.localized()}
    var food: [FoodItem] = []
    var addFood = FoodRealm()
    
    func showCategories(request: ChoiseFood.ShowCategoriesFood.Request) {
        let responce = ChoiseFood.ShowCategoriesFood.Response(categoriesName: categoriesName)
        presenter?.presentCategories(responce: responce)
    }
    
    func showFoodList(request: ChoiseFood.ShowFood.Request) {
        if request.category != nil  {
            guard let category = request.category?.rawValue else { return }
            DataManager.shared.fetchFoodData { food in
                self.food = food.filter {$0.type == category}
            }
            let responce = ChoiseFood.ShowFood.Response(food: food)
            presenter?.presentFood(response: responce)
        }  else if request.name != nil {
            guard let searchText = request.name else { return }
                let filteredFoodList = food.filter { (food: FoodItem) in
                if !searchText.isEmpty {
                    return food.name.localized().lowercased().contains(searchText.lowercased())
                } else {
                    return false
                }
            }
            let responce = ChoiseFood.ShowFood.Response(food: filteredFoodList)
            presenter?.presentFood(response: responce)
        }
    }
    
//    func showAddFoodMenu(request: ChoiseFood.AddFood.Request) {
//        worker = ChoiseFoodWorker()
//        guard let food = worker?.getFood(from: request.food) else { return }
//        let responce = ChoiseFood.AddFood.Response(food: food)
//        presenter?.presentAddFoodMenu(response: responce)
//    }
}
