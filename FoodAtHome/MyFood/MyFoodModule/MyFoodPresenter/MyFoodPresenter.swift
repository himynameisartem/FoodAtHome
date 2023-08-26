//
//  MyFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import UIKit
import RealmSwift

class MyFoodPresenter {
    
    let localRealm = try! Realm()
    
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
        addAndChangeFoodView.sohowAddAndChangeFoodView(for: viewController)
    }
    
    func configureChangeFoodMenu(food: FoodRealm) {
        addAndChangeFoodView.configure(food: food)
    }
    
    func changeFood(_ food: FoodRealm, viewController: UIViewController) {
        FoodManager.shared.addFood(food, myFood: myFood, viewController: viewController)
    }
    
    func removeAllFood() {
        try! localRealm.write({
            localRealm.deleteAll()
        })
    }
}

extension MyFoodPresenter: MyFoodInteractorOutputProtocol {
    func foodDidRecieve(_ food: [FoodRealm]) {
        self.myFood = food
        view.reloadData()
    }
}
