//
//  FoodListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.07.2023.
//

import UIKit
import RealmSwift

class FoodListPresenter {
    
    let localRealm = try! Realm()
    
    weak var view: FoodListViewProtocol!
    var interactor: FoodListInteractorProtocol!
    var router: FoodListRouterProtocol!
    var addAndChangeFoodView = AddAndChangeFoodView()
    
    var myFood: [FoodRealm] = []
        
    init(view: FoodListViewProtocol!) {
        self.view = view
    }
}

extension FoodListPresenter: FoodListPresenterProtocol {
    
    func viewDidLoad() {
        interactor.fetchMyFood()
    }
    
    func tappedSearch() {
        view.showSearchBar()
    }
    
    func updateSearchResults(for searchText: String) {
        interactor.filterContentForSearchText(searchText)
    }
    
    func selectedCategories(at indexPath: IndexPath) -> [FoodRealm] {
        FoodListManager.shared.choiseCategories(for: indexPath.row)
    }
    
    func showAddFoodView(_ food: FoodRealm) {
        router.openAddFoodView(food)
    }
    
    func backToRoot() {
        router.backToRootViewController()
    }
    
    func addAndChangeFood(_ food: FoodRealm, viewController: UIViewController, closedView: @escaping () -> Void) {
        
        if viewController.navigationController?.viewControllers.first(where: { $0 is MyFoodViewController }) is MyFoodViewController {
            FoodManager.shared.addFood(food, myFood: myFood, check: .check, viewController: viewController, closedFunction: closedView)
        } else if viewController.navigationController?.viewControllers.first(where: { $0 is ShoppingListViewController }) is ShoppingListViewController {
            FoodManager.shared.addFoodToShoppingList(food)
        }
    }
}


extension FoodListPresenter: FoodListInteractorOutputProtocol {
    
    func foodDidRecieve(_ food: [FoodRealm]) {
        self.myFood = food
        view.reloadData()
    }
    

    func didFilterFood(_ filteredFoodList: [FoodRealm]) {
        view.dysplayFilteredFood(filteredFoodList)
        view.reloadData()
    }
}
