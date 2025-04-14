//
//  ShoppingListInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListBusinessLogic {
    func showFoodList(request: ShoppingListModel.ShowFood.Request)
    func moveToMyFood(request: ShoppingListModel.AddToMyFood.Request)
    func getEditingFood(request: ShoppingListModel.EditingFood.Request)
    func deleteFood(request: ShoppingListModel.DeleteFood.Request)
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
    
    func showFoodList(request: ShoppingListModel.ShowFood.Request) {
        foodList = DataManager.shared.fetchMyShoppingList()
        let responce = ShoppingListModel.ShowFood.Response(food: foodList)
        presenter?.presentData(response: responce)
    }
    
    func moveToMyFood(request: ShoppingListModel.AddToMyFood.Request) {
        editingFood = foodList[request.indexPath.row]
        DataManager.shared.changeAndEdit(editingFood)
//        let response = ShoppingListModel.AddToMyFood.Responce()
//        presenter?.presentMoveToMyFood(response: response)
    }
    
    func getEditingFood(request: ShoppingListModel.EditingFood.Request) {
        editingFood = foodList[request.indexPath.row]
    }
    
    func deleteFood(request: ShoppingListModel.DeleteFood.Request) {
        foodList = DataManager.shared.fetchMyShoppingList()
        DataManager.shared.delete(food: foodList[request.indexPath.row])
        let responce = ShoppingListModel.DeleteFood.Responce()
        presenter?.presentDeleteFood(response: responce)
    }
}
