//
//  ShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListBusinessLogic {
    func fetchFoodList(request: ShoppingListModel.FetchShoppingList.Request)
    func fetchSharedShoppingList(request: ShoppingListModel.FetchSharedShoppingList.Request)
    func addToMyFood(request: ShoppingListModel.AddToMyFood.Request)
    func checkDuplicate(request: ShoppingListModel.CheckDuplicate.Request)
    func prepareEditingFood(request: ShoppingListModel.PrepareEditing.Request)
    func deleteFood(request: ShoppingListModel.DeleteFood.Request)
    func removeAllShoppingList(request: ShoppingListModel.RemoveAllShoppingList.Request)
    func confirmRemoveAllShoppingList(request: ShoppingListModel.ConfirmRemoveAllShoppingList.Request)
    func confirmEditingFood(request: ShoppingListModel.ConfirmEditingFood.Request)
    func confirmAddToMyFood(request: ShoppingListModel.ConfirmAddToMyFood.Request)
    func confirmChangeMyFood(request: ShoppingListModel.ConfirmChangeMyFood.Request)
}

protocol ShoppingListDataStore {
    var foodList: [FoodRealm] { get }
    var editingFood: FoodRealm { get }
}

class ShoppingListInteractor: ShoppingListBusinessLogic, ShoppingListDataStore {
    
    private let worker: ShoppingListWorkerProtocol
    var presenter: ShoppingListPresentationLogic?
    
    var foodList: [FoodRealm] = []
    var editingFood = FoodRealm()
    
    init (worker: ShoppingListWorkerProtocol) {
        self.worker = worker
    }
    
    func fetchFoodList(request: ShoppingListModel.FetchShoppingList.Request) {
        foodList = worker.fetchMyShoppingList()
        let responce = ShoppingListModel.FetchShoppingList.Response(food: foodList)
        presenter?.presentData(response: responce)
    }
    
    func addToMyFood(request: ShoppingListModel.AddToMyFood.Request) {
        let response = ShoppingListModel.AddToMyFood.Response(shouldConfirm: true,
                                                              indexPath: request.indexPath,
                                                              completion: request.completion)
        presenter?.presentAddToMyFood(response: response)
    }
    
    func checkDuplicate(request: ShoppingListModel.CheckDuplicate.Request) {
        editingFood = foodList[request.indexPath.row]
        if worker.checkDuplicate(food: editingFood) {
            let response = ShoppingListModel.CheckDuplicate.Response(shouldConfirm: true, indexPath: request.indexPath, completion: request.completion)
            presenter?.presentCheckDuplicate(response: response)
        } else {
            let response = ShoppingListModel.CheckDuplicate.Response(shouldConfirm: false, indexPath: request.indexPath, completion: request.completion)
            presenter?.presentCheckDuplicate(response: response)
        }
    }
    
    func confirmAddToMyFood(request: ShoppingListModel.ConfirmAddToMyFood.Request) {
        worker.addToMyFoodList(foodList[request.indexPath.row])
        let response = ShoppingListModel.ConfirmAddToMyFood.Response(isConfirm: true)
        presenter?.presentConfirmAddToMyFood(response: response)
    }
    
    func confirmChangeMyFood(request: ShoppingListModel.ConfirmChangeMyFood.Request) {
        worker.changeMyFoodList(foodList[request.indexPath.row])
        let response = ShoppingListModel.ConfirmChangeMyFood.Response(isConfirm: true)
        presenter?.presentConfirmChangeMyFood(response: response)
    }
    
    func confirmEditingFood(request: ShoppingListModel.ConfirmEditingFood.Request) {
        editingFood = foodList[request.indexPath.row]
        let response = ShoppingListModel.ConfirmEditingFood.Response(isConfirm: true)
        presenter?.presentConfirmEditingFood(response: response)
    }
    
    func prepareEditingFood(request: ShoppingListModel.PrepareEditing.Request) {
        editingFood = foodList[request.indexPath.row]
        let response = ShoppingListModel.PrepareEditing.Response()
        presenter?.presentEditingFood(response: response)
    }
    
    func deleteFood(request: ShoppingListModel.DeleteFood.Request) {
        worker.deleteItem(at: request.indexPath)
        let responce = ShoppingListModel.DeleteFood.Response()
        presenter?.presentFoodItemDeletion(response: responce)
    }
    
    func removeAllShoppingList(request: ShoppingListModel.RemoveAllShoppingList.Request) {
        let response = ShoppingListModel.RemoveAllShoppingList.Response(shouldConfirm: true)
        presenter?.presentAllShoppingListRemoved(response: response)
    }
    
    func fetchSharedShoppingList(request: ShoppingListModel.FetchSharedShoppingList.Request) {
        let response = ShoppingListModel.FetchSharedShoppingList.Response(sharedFood: worker.fetchMyShoppingList())
        presenter?.presentSharedShoppingList(response: response)
    }
    
    func confirmRemoveAllShoppingList(request: ShoppingListModel.ConfirmRemoveAllShoppingList.Request) {
        worker.removeAllShoppingList()
        let response = ShoppingListModel.ConfirmRemoveAllShoppingList.Response(isConfirm: true)
        presenter?.presentConfirmRemoveAllSharedList(response: response)
    }
}
