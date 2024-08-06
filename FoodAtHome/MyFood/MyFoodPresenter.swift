//
//  MyFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

protocol MyFoodPresentationLogic {
    func presentCategories(responce: MyFood.ShowCategories.Responce)
    func presentMyFood(response: MyFood.ShowMyFood.Response)
}

class MyFoodPresenter: MyFoodPresentationLogic {
    
    weak var viewController: MyFoodDisplayLogic?
    var worker: MyFoodWorker?
    
    func presentCategories(responce: MyFood.ShowCategories.Responce) {
        worker = MyFoodWorker()
        guard let displayedCategories = worker?.getDisplayedCategories(from: responce.categories) else { return }
        let viewModel = MyFood.ShowCategories.ViewModel(displayedCategories: displayedCategories)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func presentMyFood(response: MyFood.ShowMyFood.Response) {
        worker = MyFoodWorker()
        guard let displayedMyFood = worker?.getDisplayedMyFood(from: response.food) else { return }
        let viewModel = MyFood.ShowMyFood.ViewModel(displayedMyFood: displayedMyFood)
        viewController?.displayMyFood(viewModel: viewModel)
    }
}
