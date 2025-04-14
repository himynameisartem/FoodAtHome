//
//  MyFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit
import RealmSwift

protocol MyFoodBusinessLogic {
    func fetchCategories(request: MyFoodModel.FetchCategories.Request)
    func fetchMyFood(request: MyFoodModel.FetchFoodList.Request)
    func fetchSharedFoodList(request: MyFoodModel.FetchSharedFood.Request)
    func fetchFoodDetails(request: MyFoodModel.FetchFoodDetails.Request, at index: Int)
    func prepareEditingFood(request: MyFoodModel.PrepareEditing.Request)
    func deleteFood(request: MyFoodModel.DeleteFood.Request)
    func RemoveAllMyFood(request: MyFoodModel.RemoveAllMyFood.Request)
}

protocol MyFoodDataStore {
    var myFood: [FoodRealm] { get }
    var editingFood: FoodRealm { get }
    var categories: [String] { get }
}

class MyFoodInteractor: MyFoodBusinessLogic, MyFoodDataStore {
    
    var myFood: [FoodRealm] = []
    var categories: [String] = []
    var editingFood = FoodRealm()
    var presenter: MyFoodPresentationLogic?
    var worker: MyFoodWorker?
    
    func fetchCategories(request: MyFoodModel.FetchCategories.Request) {
        categories = FoodType.allCases.map {$0.rawValue}
        let responce = MyFoodModel.FetchCategories.Responce(categories: categories)
        presenter?.presentCategories(responce: responce)
    }
    
    func fetchMyFood(request: MyFoodModel.FetchFoodList.Request) {
        myFood = DataManager.shared.fetchMyFood()
        let responce = MyFoodModel.FetchFoodList.Response(food: myFood)
        presenter?.presentMyFood(response: responce)
    }
    
    func fetchFoodDetails(request: MyFoodModel.FetchFoodDetails.Request, at index: Int) {
        let responce = MyFoodModel.FetchFoodDetails.Responce(foodDetails: myFood[index])
        presenter?.presentFoodDetails(responce: responce)
    }
    
    func prepareEditingFood(request: MyFoodModel.PrepareEditing.Request) {
        editingFood = myFood[request.indexPath.row]
    }
    
    func deleteFood(request: MyFoodModel.DeleteFood.Request) {
        myFood = DataManager.shared.fetchMyFood()
        DataManager.shared.delete(food: myFood[request.indexPath.row])
        let responce = MyFoodModel.DeleteFood.Responce()
        presenter?.presentFoodItemDeletion(response: responce)
    }
    
    func RemoveAllMyFood(request: MyFoodModel.RemoveAllMyFood.Request) {
        let alertController = UIAlertController(title: "Delete All Products?".localized(), message: "This action will delete all your products, are you sure you want to continue?".localized(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive) { _ in
            DataManager.shared.reamoveAllMyFood()
            let response = MyFoodModel.RemoveAllMyFood.Responce(alertController: nil)
            self.presenter?.presentAllMyFoodRemoving(response: response)
        })
        alertController.addAction(UIAlertAction(title: "No".localized(), style: .cancel))
        let response = MyFoodModel.RemoveAllMyFood.Responce(alertController: alertController)
        presenter?.presentAllMyFoodRemoving(response: response)
    }
    
    func fetchSharedFoodList(request: MyFoodModel.FetchSharedFood.Request) {
        myFood = DataManager.shared.fetchMyFood()
        let responce = MyFoodModel.FetchSharedFood.Responce(sharedFood: myFood)
        presenter?.presentSharedFood(response: responce)
    }
}
