//
//  ShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListBusinessLogic {
    func showFoodList(request: ShoppingList.ShoppingListModel.Request)
    func showAddToMyFood(request: ShoppingList.AddToMyFood.Request)
    func getEditingFood(request: ShoppingList.EditingFood.Request)
    func deleteFood(request: ShoppingList.DeleteFood.Request)
}

protocol ShoppingListDataStore {
    var foodList: [FoodRealm] { get }
    var editingFood: FoodRealm { get }
}

class ShoppingListInteractor: ShoppingListBusinessLogic, ShoppingListDataStore {
    
    var presenter: ShoppingListPresentationLogic?
    var worker: ShoppingListWorker?
    var foodList: [FoodRealm] = []
    var editingFood = FoodRealm()
    
    func showFoodList(request: ShoppingList.ShoppingListModel.Request) {
        worker = ShoppingListWorker()
        guard let worker = worker else { return }
        foodList = worker.getShoppintList().reversed()
        let responce = ShoppingList.ShoppingListModel.Response(food: foodList)
        presenter?.presentData(response: responce)
    }
    
    func showAddToMyFood(request: ShoppingList.AddToMyFood.Request) {
        worker = ShoppingListWorker()
        guard let worker = worker else { return }
        foodList = worker.getShoppintList().reversed()
        let foodFromShoppingList = foodList[request.indexPath.row]
        let responce = ShoppingList.AddToMyFood.Responce(food: worker.prepareToMyFoodList(from: foodFromShoppingList, and: foodList))
    }
    
    func getEditingFood(request: ShoppingList.EditingFood.Request) {
        editingFood = foodList[request.indexPath.row]
    }
    
//    func showChangeFood(request: ShoppingList.ChangeFood.Request) {
//        worker = ShoppingListWorker()
//        guard let worker = worker else { return }
//        foodList = worker.getShoppintList().reversed()
//        let foodFromShoppingList = foodList[request.indexPath.row]
//        let responce = ShoppingList.ChangeFood.Responce(food: worker.prepareToMyFoodList(from: foodFromShoppingList, and: foodList))
//        presenter?.presentChangeFood(response: responce)
//    }
    
    func deleteFood(request: ShoppingList.DeleteFood.Request) {
        foodList = DataManager.shared.fetchMyShoppingList().reversed()
        DataManager.shared.delete(food: foodList[request.indexPath.row])
        let responce = ShoppingList.DeleteFood.Responce()
        presenter?.presentDeleteFood(response: responce)
    }
}
