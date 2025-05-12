//
//  ChoiseFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

protocol ChoiseFoodPresentationLogic {
    func presentCategories(response: ChoiseFoodModel.FetchCategories.Response)
    func presentFood(response: ChoiseFoodModel.FetchFood.Response)
    func presentItem(response: ChoiseFoodModel.FetchItem.Response)
}

class ChoiseFoodPresenter: ChoiseFoodPresentationLogic {
    
    weak var viewController: ChoiseFoodDisplayLogic?
    
    func presentCategories(response: ChoiseFoodModel.FetchCategories.Response) {
        let viewModel = ChoiseFoodModel.FetchCategories.ViewModel(categoriesName: response.categoriesName)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func presentFood(response: ChoiseFoodModel.FetchFood.Response) {
        let displayedFood = response.food.map { food in
            ChoiseFoodModel.FetchFood.ViewModel.DispalyedFood(name: food.name,
                                                        imageName: food.name,
                                                        calories: food.calories)
        }.sorted {$0.name.localized() < $1.name.localized()}
        let viewModel = ChoiseFoodModel.FetchFood.ViewModel(displayedFood: displayedFood)
        viewController?.displayFood(viewModel: viewModel)
    }
    
    func presentItem(response: ChoiseFoodModel.FetchItem.Response) {
        let viewModel = ChoiseFoodModel.FetchItem.ViewModel()
        viewController?.displayItem(viewModel: viewModel)
    }
}
