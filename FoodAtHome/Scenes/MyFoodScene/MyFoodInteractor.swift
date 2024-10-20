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
    func showChangeFoodMenu(request: MyFood.ChangeFood.Request)
    func deleteFood(request: MyFood.DeleteFood.Request)
    func removeAllFood(request: MyFood.RemoveAllFood.Request)
    func showSharedSoodList(request: MyFood.SharedFood.Request)
}

protocol MyFoodDataStore {
    var myFood: [FoodRealm] { get }
    var categories: [String] { get }
}

class MyFoodInteractor: MyFoodBusinessLogic, MyFoodDataStore {
    
    var myFood: [FoodRealm] = []
    var categories: [String] = []
    var presenter: MyFoodPresentationLogic?
    var worker: MyFoodWorker?
    
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
    
    func showChangeFoodMenu(request: MyFood.ChangeFood.Request) {
        worker = MyFoodWorker()
        myFood = DataManager.shared.fetchMyFood().reversed()
        let food = worker?.getChange(food: myFood, at: request.indexPath)
        guard let food = food else { return }
        let responce = MyFood.ChangeFood.Responce(food: food)
        presenter?.presentChangeFoodMenu(response: responce)
    }
    
    func deleteFood(request: MyFood.DeleteFood.Request) {
        myFood = DataManager.shared.fetchMyFood().reversed()
        DataManager.shared.delete(food: myFood[request.indexPath.row])
        let responce = MyFood.DeleteFood.Responce()
        presenter?.presentDeleteFood(response: responce)
    }
    
    func removeAllFood(request: MyFood.RemoveAllFood.Request) {
        DataManager.shared.removeAll()
        let responce = MyFood.RemoveAllFood.Responce()
        self.presenter?.presentRemoveAllFood(response: responce)
    }
    
    func showSharedSoodList(request: MyFood.SharedFood.Request) {
        myFood = DataManager.shared.fetchMyFood()
        let responce = MyFood.SharedFood.Responce(sharedFood: myFood.reversed())
        presenter?.presentSharedList(response: responce)
    }
}
