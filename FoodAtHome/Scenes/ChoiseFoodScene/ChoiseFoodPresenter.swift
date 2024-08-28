//
//  ChoiseFoodPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChoiseFoodPresentationLogic {
  func presentData(response: ChoiseFood.Model.Response)
}

class ChoiseFoodPresenter: ChoiseFoodPresentationLogic {
    
  weak var viewController: ChoiseFoodDisplayLogic?
  
  func presentData(response: ChoiseFood.Model.Response) {
  
  }
  
}
