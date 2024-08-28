//
//  ChoiseFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChoiseFoodBusinessLogic {
  func makeRequest(request: ChoiseFood.Model.Request)
}

class ChoiseFoodInteractor: ChoiseFoodBusinessLogic {

  var presenter: ChoiseFoodPresentationLogic?
  var worker: ChoiseFoodWorker?
  
  func makeRequest(request: ChoiseFood.Model.Request) {

  }
  
}
