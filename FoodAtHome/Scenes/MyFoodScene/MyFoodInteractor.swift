//
//  MyFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import RealmSwift

protocol MyFoodBusinessLogic {
    func fetchCategories(request: MyFoodModel.FetchCategories.Request)
    func fetchMyFood(request: MyFoodModel.FetchFoodList.Request)
    func fetchSharedFoodList(request: MyFoodModel.FetchSharedFood.Request)
    func fetchFoodDetails(request: MyFoodModel.FetchFoodDetails.Request)
    func prepareEditingFood(request: MyFoodModel.PrepareEditing.Request)
    func deleteFood(request: MyFoodModel.DeleteFood.Request)
    func removeAllMyFood(request: MyFoodModel.RemoveAllMyFood.Request)
    func confirmRemoveAllMyFood(request: MyFoodModel.ConfirmRemoveAllMyFood.Request)
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
    private let worker: MyFoodWorkerProtocol
    
    init (worker: MyFoodWorkerProtocol) {
        self.worker = worker
    }
    
    func fetchCategories(request: MyFoodModel.FetchCategories.Request) {
        categories = FoodType.allCases.map {$0.rawValue}
        let response = MyFoodModel.FetchCategories.Response(categories: categories)
        presenter?.presentCategories(response: response)
    }
    
    func fetchMyFood(request: MyFoodModel.FetchFoodList.Request) {
        myFood = worker.fetchMyFood()
        let response = MyFoodModel.FetchFoodList.Response(food: myFood)
        presenter?.presentMyFood(response: response)
    }
    
    func fetchFoodDetails(request: MyFoodModel.FetchFoodDetails.Request) {
        let response = MyFoodModel.FetchFoodDetails.Response(foodDetails: myFood[request.indexPath.row])
        presenter?.presentFoodDetails(response: response)
    }
    
    func prepareEditingFood(request: MyFoodModel.PrepareEditing.Request) {
        editingFood = myFood[request.indexPath.row]
        let response = MyFoodModel.PrepareEditing.Response()
        presenter?.presentEditingFood(response: response)
    }
    
    func deleteFood(request: MyFoodModel.DeleteFood.Request) {
        worker.deleteFood(at: request.indexPath)
        let response = MyFoodModel.DeleteFood.Response()
        presenter?.presentFoodItemDeletion(response: response)
    }
    
    func removeAllMyFood(request: MyFoodModel.RemoveAllMyFood.Request) {
        let response = MyFoodModel.RemoveAllMyFood.Response(shouldConfirm: true)
        presenter?.presentAllMyFoodRemoving(response: response)
    }
    
    func confirmRemoveAllMyFood(request: MyFoodModel.ConfirmRemoveAllMyFood.Request) {
        worker.removeAllFood()
        let response = MyFoodModel.ConfirmRemoveAllMyFood.Response(isConfirm: true)
        presenter?.presentConfirmRemoveAllMyFood(response: response)
    }
    
    func fetchSharedFoodList(request: MyFoodModel.FetchSharedFood.Request) {
        myFood = worker.fetchMyFood()
        let response = MyFoodModel.FetchSharedFood.Response(sharedFood: myFood)
        presenter?.presentSharedFood(response: response)
    }
}
