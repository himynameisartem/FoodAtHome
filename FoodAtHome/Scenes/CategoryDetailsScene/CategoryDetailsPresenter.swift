//
//  CategoryDetailsPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsPresentationLogic {
    func presentCategory(responce: CategoryDetails.ShowCategory.Responce)
    func presentCells(response: CategoryDetails.ShowFood.Response)
}

class CategoryDetailsPresenter: CategoryDetailsPresentationLogic {
    
    weak var viewController: CategoryDetailsDisplayLogic?
    var worker: CategoryDetailsWorker?
    
    func presentCategory(responce: CategoryDetails.ShowCategory.Responce) {
        let displayedDetails = CategoryDetails.ShowCategory.ViewModel.DisplayedCategory(categoryName: responce.category.localized(), categoryImage: responce.category)
        let viewModel = CategoryDetails.ShowCategory.ViewModel(displayedCategory: displayedDetails)
        viewController?.displayCategoryData(viewModel: viewModel)
    }
    
    func presentCells(response: CategoryDetails.ShowFood.Response) {
        
        worker = CategoryDetailsWorker()
        guard let displayedDetails = worker?.getDisplayedFood(food: response.food) else { return }
        let viewModel = CategoryDetails.ShowFood.ViewModel(displayedCells: displayedDetails)
        viewController?.displayCellsData(viewModel: viewModel)
    }
}
