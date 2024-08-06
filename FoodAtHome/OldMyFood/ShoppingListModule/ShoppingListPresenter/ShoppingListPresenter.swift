//
//  ShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation
import RealmSwift

class ShoppingListPresenter {
    
    let localRealm = FoodManager.shared.getRealm()
    
    var shoppingList: [FoodRealm] = []
    var foodList: [FoodRealm] = []
    var allFood: [FoodRealm] = []
    var shoppingListCounter: Int {
        shoppingList.count
    }

    var addAndChangeFoodView = AddAndChangeFoodView()
    
    weak var view: ShoppingListViewProtocol!
    var interactor: ShoppingListInteractorProtocol!
    var router: ShoppingListRouterProtocol!
    
    init(view: ShoppingListViewProtocol!) {
        self.view = view
    }
}

extension ShoppingListPresenter: ShoppingListPresenterProtocol {
    
    
    func viewDidLoad() {
        interactor.fetchShoppingList()
        interactor.fetchFoodList()
        interactor.fetchAllFood()
    }
    
    func showFoodListViewController() {
        router.openFoodListViewController()
    }
    
    func removeAllFood() {
        for i in shoppingList {
            if i.isShoppingList {
                try! localRealm.write({
                    localRealm.delete(i)
                })
            }
        }
    }
    
    func food(at index: IndexPath) -> FoodRealm {
        shoppingList[index.row]
    }
    
    func deleteProducts(food: FoodRealm) {
        try! localRealm.write({
            localRealm.delete(food)
        })
    }
    
    func checkExistFood(food: FoodRealm) -> Bool {
        for i in foodList {
            if i.name == food.name {
                return true
            }
        }
        return false
    }
    
    func addExperationDate(food: FoodRealm, viewController: UIViewController) {
        addAndChangeFoodView.showOptionsMenu(for: viewController, choiseType: .foodList)
    }
    
    func moveFood(food: FoodRealm, viewController: UIViewController) {
        try! self.localRealm.write({
            food.isShoppingList.toggle()
        })
    }
    
    func showChangeMenu(viewController: UIViewController) {
        addAndChangeFoodView.showOptionsMenu(for: viewController, choiseType: .shoppingList)
    }
    
    func configureChangeMenu(food: FoodRealm) {
        addAndChangeFoodView.configure(food: food)
    }
    
    func changeFood(food: FoodRealm, viewController: UIViewController) {
        FoodManager.shared.addFood(food, myFood: shoppingList, check: .addition, viewController: viewController, closedFunction: nil)
    }
    
    func addFoodForFoodList(food: FoodRealm, viewController: UIViewController) {
        FoodManager.shared.addFood(food, myFood: allFood, check: .addition, viewController: viewController, closedFunction: nil)
    }
    
    func deleteFoodAfterAdding(food: FoodRealm) {
        for i in shoppingList {
            if i.name == food.name && i.isShoppingList {
                try! localRealm.write({
                    localRealm.delete(i)
                })
            }
        }
    }
}

extension ShoppingListPresenter: ShoppingListInteractorOutputProtocol {
    func shoppingListDidRecieve(_ food: [FoodRealm]) {
        self.shoppingList = food
        view.reloadData()
    }
    
    func foodListDidRecieve(_ food: [FoodRealm]) {
        self.foodList = food
        view.reloadData()
    }
    
    func allFoodDidRecieve(_ food: [FoodRealm]) {
        self.allFood = food
        view.reloadData()
    }
}
