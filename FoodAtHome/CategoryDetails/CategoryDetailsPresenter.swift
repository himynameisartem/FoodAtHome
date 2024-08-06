//
//  CategoryDetailsPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsPresentationLogic {
    func presentData(response: CategoryDetails.ShowDetails.Response)
}

class CategoryDetailsPresenter: CategoryDetailsPresentationLogic {
    
    weak var viewController: CategoryDetailsDisplayLogic?
    var worker: CategoryDetailsWorker?
    
    func presentData(response: CategoryDetails.ShowDetails.Response) {
        
        worker = CategoryDetailsWorker()
        guard let displayedDetails = worker?.getDisplayedFood(food: response.food) else { return }
        let viewModel = CategoryDetails.ShowDetails.ViewModel(displayedDetails: displayedDetails)
        viewController?.displayData(viewModel: viewModel)
    }
}
