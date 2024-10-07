//
//  MyFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit
import RealmSwift

protocol MyFoodBusinessLogic {
    func showCategories(request: MyFood.ShowCategories.Request)
    func showMyFood(request: MyFood.ShowMyFood.Request)
    func showDetailsFood(request: MyFood.showDetailFood.Request, at index: Int)
}

protocol MyFoodDataStore {
    var myFood: [FoodRealm] { get }
    var categories: [String] { get }
}

class MyFoodInteractor: MyFoodBusinessLogic, MyFoodDataStore {
    
    var myFood: [FoodRealm] = []
    var categories: [String] = []
    var presenter: MyFoodPresentationLogic?
    
    func showCategories(request: MyFood.ShowCategories.Request) {
        categories = FoodType.allCases.map {$0.rawValue}
        let responce = MyFood.ShowCategories.Responce(categories: categories)
        presenter?.presentCategories(responce: responce)
    }
    
    func showMyFood(request: MyFood.ShowMyFood.Request) {
        myFood = DataManager.shared.fetchMyFood().reversed()
        let responce = MyFood.ShowMyFood.Response(food: myFood)
        presenter?.presentMyFood(response: responce)
    }
    
    func showDetailsFood(request: MyFood.showDetailFood.Request, at index: Int) {
        let responce = MyFood.showDetailFood.Responce(foodDetails: myFood[index])
        presenter?.presentDetailsFood(responce: responce)
    }
}
