//
//  MyFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation

class MyFoodInteractor {
    
    weak var presenter: MyFoodInteractorOutputProtocol!
    
    required init(presenter: MyFoodInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
}

extension MyFoodInteractor: MyFoodInteractorProtocol {

    func fetchMyFood() {
        self.presenter.foodDidRecieve(FoodManager.shared.fetchMyFoodList())
    }
    
}
