//
//  AddFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AddFoodBusinessLogic {
  func makeRequest(request: AddFood.Model.Request.RequestType)
}

class AddFoodInteractor: AddFoodBusinessLogic {

  var presenter: AddFoodPresentationLogic?
  var service: AddFoodService?
  
  func makeRequest(request: AddFood.Model.Request.RequestType) {
    if service == nil {
      service = AddFoodService()
    }
  }
  
}
