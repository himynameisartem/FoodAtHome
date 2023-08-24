//
//  FoddListInteractorProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

protocol FoodListInteractorProtocol: AnyObject {
    func fetchMyFood()
    func filterContentForSearchText(_ searchText: String)
}


protocol FoodListInteractorOutputProtocol: AnyObject {
    func foodDidRecieve(_ food: [FoodRealm])
    func didFilterFood(_ filteredFoodList: [FoodRealm])
}
