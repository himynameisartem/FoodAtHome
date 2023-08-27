//
//  CategoryFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2023.
//

import Foundation

class CategoryFoodPresenter {
    
    weak var view: CategoryFoodViewProtocol!
    var interactor: CategoryFoodInteractorProtocol!
    
    var foodList: [FoodRealm] = []
    var foodCount: Int {
        return foodList.count
    }
    
    required init(view: CategoryFoodViewProtocol!) {
        self.view = view
    }
}

extension CategoryFoodPresenter: CategoryFoodPresenterProtocol {
    func viewDidLoad() {
        interactor.provideCategoryFood()
    }
    
    func getFood(at indexPath: IndexPath) -> FoodRealm? {
        self.foodList[indexPath.row]
    }
}

extension CategoryFoodPresenter: CategoryFoodInteractorOutputProtocol {
    func recieveFood(_ food: [FoodRealm], categoryName: String) {
        view.setImage(categoryName)
        self.foodList = food
    }
}
