//
//  MyFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation

class OldMyFoodInteractor {
    
    weak var presenter: OldMyFoodInteractorOutputProtocol!
    
    required init(presenter: OldMyFoodInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
}

extension OldMyFoodInteractor: OldMyFoodInteractorProtocol {

    func fetchMyFood() {
        self.presenter.foodDidRecieve(FoodManager.shared.fetchMyFoodList())
    }
    
}
