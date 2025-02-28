//
//  AddShoppingListPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddShoppingListPresentationLogic {
    func presentData(response: AddShoppingList.Model.Response)
}

class AddShoppingListPresenter: AddShoppingListPresentationLogic {
    weak var viewController: AddShoppingListDisplayLogic?
    
    func presentData(response: AddShoppingList.Model.Response) {
        
    }
    
}
