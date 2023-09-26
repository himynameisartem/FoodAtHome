//
//  MyFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import UIKit
import RealmSwift

class MyFoodPresenter {
    
    let localRealm = FoodManager.shared.getRealm()
    
    weak var view: MyFoodViewProtocol!
    var interactor: MyFoodInteractorProtocol!
    var router: MyFoodRouterProtocol!
    
    var showPopupMenu = PopupMenu()
    var addAndChangeFoodView = AddAndChangeFoodView()
    
    var myFood: [FoodRealm] = []
    var myFoodCount: Int? {
        myFood.count
    }
    
    required init(view: MyFoodViewProtocol) {
        self.view = view
    }
}

extension MyFoodPresenter: MyFoodPresenterProtocol {

    func viewDidLoad() {            
        interactor.fetchMyFood()
    }
    
    func food(atIndex indexPath: IndexPath) -> FoodRealm? {
        if myFood.indices.contains(indexPath.row) {
            return myFood[indexPath.row]
        } else {
            return nil
        }
    }
    
    func showPopupMenu(from sourceCell: UICollectionViewCell?, at indexPath: IndexPath?, from viewController: UIViewController) {
        showPopupMenu.showPopupMenu(from: sourceCell, at: indexPath, from: viewController)
    }
    
    func hidePopupMenu(from viewController: UIViewController, and tapGesture: UITapGestureRecognizer) {
        showPopupMenu.hidePopupMenu(from: viewController, and: tapGesture)
    }
    
    func configurePopupMenu(food: FoodRealm) {
        showPopupMenu.configure(food: food)
    }
    
    func showCategoryFood(at indexPath: IndexPath) {
        router.openCategoryFoodViewController(at: indexPath, food: myFood)
    }
    
    func showFoodListViewController() {
        router.openFoodListViewController()
    }
    
    func showChangeFoodMenu(for viewController: UIViewController) {
        addAndChangeFoodView.showOptionsMenu(for: viewController, choiseType: .foodList)
    }
    
    func configureChangeFoodMenu(food: FoodRealm) {
        addAndChangeFoodView.configure(food: food)
    }
    
    func deleteFood(food: FoodRealm) {
        try! localRealm.write({
            localRealm.delete(food)
        })
    }
    
    func changeFood(_ food: FoodRealm, viewController: UIViewController) {
        FoodManager.shared.addFood(food, myFood: myFood, check: .addition, viewController: viewController, closedFunction: nil)
    }
    
    func removeAllFood() {
        for i in myFood {
            if !i.isShoppingList {
                try! localRealm.write({
                    localRealm.delete(i)
                })
            }
        }
    }
    
    func removeExpiredProducts(food: [FoodRealm]) {
        for i in food {
            if DateManager.shared.expirationDateCheck(experationDate: i.expirationDate) {
                try! localRealm.write({
                    localRealm.delete(i)
                })
            }
        }
    }
    
}

extension MyFoodPresenter: MyFoodInteractorOutputProtocol {
    func foodDidRecieve(_ food: [FoodRealm]) {
        self.myFood = food
        view.reloadData()
    }
}
