//
//  ShoppingListPresenterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import UIKit

protocol ShoppingListPresenterProtocol: AnyObject {
    var shoppingList: [FoodRealm] { get }
    var foodList: [FoodRealm] { get }
    var allFood: [FoodRealm] { get }
    var shoppingListCounter: Int { get }
    func viewDidLoad()
    func showFoodListViewController()
    func removeAllFood()
    func food(at index: IndexPath) -> FoodRealm
    func deleteProducts(food: FoodRealm)
    func moveFood(food: FoodRealm, viewController: UIViewController)
    func addExperationDate(food: FoodRealm, viewController: UIViewController)
    func showChangeMenu(viewController: UIViewController)
    func configureChangeMenu(food: FoodRealm)
    func changeFood(food: FoodRealm, viewController: UIViewController)
    func addFoodForFoodList(food: FoodRealm, viewController: UIViewController)
    func checkExistFood(food: FoodRealm) -> Bool
    func deleteFoodAfterAdding(food: FoodRealm)
}
