//
//  CategoryDetailsPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsPresentationLogic {
    func presentCategory(response: CategoryDetails.ShowCategory.Response)
    func presentCells(response: CategoryDetails.ShowFood.Response)
}

class CategoryDetailsPresenter: CategoryDetailsPresentationLogic {
    
    weak var viewController: CategoryDetailsDisplayLogic?
    
    func presentCategory(response: CategoryDetails.ShowCategory.Response) {
        let displayedDetails = CategoryDetails.ShowCategory.ViewModel.DisplayedCategory(categoryName: response.category.localized(), categoryImage: response.category)
        let viewModel = CategoryDetails.ShowCategory.ViewModel(displayedCategory: displayedDetails)
        viewController?.displayCategoryData(viewModel: viewModel)
    }
    
    func presentCells(response: CategoryDetails.ShowFood.Response) {
        let displayedCells = zip(response.food, response.color).map { food, color in
            CategoryDetails.ShowFood.ViewModel.DisplayedCells(foodName: food.name.localized(),
                                                              imageName: food.name,
                                                              weight: food.weight,
                                                              calories: food.calories + " " + "kCal".localized() + " / " + "100g.".localized(),
                                                              unit: food.unit.localized(),
                                                              warningColor: color)
        }
        let viewModel = CategoryDetails.ShowFood.ViewModel(displayedCells: displayedCells)
        viewController?.displayCellsData(viewModel: viewModel)
    }
}
