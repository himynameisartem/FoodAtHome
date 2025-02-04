//
//  AddFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddFoodPresentationLogic {
  func presentData(response: AddFood.Model.Response.ResponseType)
}

class AddFoodPresenter: AddFoodPresentationLogic {
  weak var viewController: AddFoodDisplayLogic?
  
  func presentData(response: AddFood.Model.Response.ResponseType) {
  
  }
  
}
