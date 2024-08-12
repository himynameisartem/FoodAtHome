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
        
        categories = categoriesList
        let responce = MyFood.ShowCategories.Responce(categories: categories)
        presenter?.presentCategories(responce: responce)
    }
    
    func showMyFood(request: MyFood.ShowMyFood.Request) {
        
        myFood = DataManager.shared.fetchMyFood()
        let responce = MyFood.ShowMyFood.Response(food: myFood)
        presenter?.presentMyFood(response: responce)
    }
}
