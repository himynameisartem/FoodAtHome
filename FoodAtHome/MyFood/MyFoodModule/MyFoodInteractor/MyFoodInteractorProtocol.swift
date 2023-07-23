//
//  MyFoodInteractorProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation

protocol MyFoodInteractorProtocol: AnyObject {
    func fetchMyFood()
}

protocol MyFoodInteractorOutputProtocol: AnyObject {
    func foodDidRecieve(_ food: [FoodRealm])
}
