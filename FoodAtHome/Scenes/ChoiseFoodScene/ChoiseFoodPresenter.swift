//
//  ChoiseFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChoiseFoodPresentationLogic {
    func presentCategories(responce: ChoiseFood.ShowCategoriesFood.Response)
    func presentFood(response: ChoiseFood.ShowFood.Response)
}

class ChoiseFoodPresenter: ChoiseFoodPresentationLogic {
    
    weak var viewController: ChoiseFoodDisplayLogic?
    var worker: ChoiseFoodWorker?
    
    func presentCategories(responce: ChoiseFood.ShowCategoriesFood.Response) {
        let viewModel = ChoiseFood.ShowCategoriesFood.ViewModel(categoriesName: responce.categoriesName)
        viewController?.displayCategories(viewModel: viewModel)
    }
    
    func presentFood(response: ChoiseFood.ShowFood.Response) {
        worker = ChoiseFoodWorker()
        guard let displayedFood = worker?.displayedFood(from: response.food) else { return }
        let viewModel = ChoiseFood.ShowFood.ViewModel(displayedFood: displayedFood)
        viewController?.displayFood(viewModel: viewModel)
    }
}
