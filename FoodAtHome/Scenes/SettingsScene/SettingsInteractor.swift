//
//  SettingsInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SettingsBusinessLogic {
  func makeRequest(request: Settings.Model.Request)
}

class SettingsInteractor: SettingsBusinessLogic {

  var presenter: SettingsPresentationLogic?
  var service: SettingsService?
  
  func makeRequest(request: Settings.Model.Request) {
    if service == nil {
      service = SettingsService()
    }
  }
  
}
