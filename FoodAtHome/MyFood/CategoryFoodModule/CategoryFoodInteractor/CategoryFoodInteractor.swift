//
//  CategoryFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2023.
//

import Foundation

class CategoryFoodInteractor {
    
    weak var presenter: CategoryFoodInteractorOutputProtocol!
    private var food: [FoodRealm] = []
    private var categoryName: String
    
    required init(presenter: CategoryFoodInteractorOutputProtocol!, food: [FoodRealm], categoryName: String) {
        self.presenter = presenter
        self.food = food
        self.categoryName = categoryName
    }
}

extension CategoryFoodInteractor: CategoryFoodInteractorProtocol {
    func provideCategoryFood() {
        presenter.recieveFood(food, categoryName: categoryName )
    }
}
