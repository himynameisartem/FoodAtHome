//
//  MyFoodInteractorProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation

protocol OldMyFoodInteractorProtocol: AnyObject {
    func fetchMyFood()
}

protocol OldMyFoodInteractorOutputProtocol: AnyObject {
    func foodDidRecieve(_ food: [FoodRealm])
}
