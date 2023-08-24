//
//  FoodListPresenterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.07.2023.
//

import UIKit

protocol FoodListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func tappedSearch()
    func updateSearchResults(for searchText: String)
    func selectedCategories(at indexPath: IndexPath) -> [FoodRealm]
    func showAddFoodView(_ food: FoodRealm)
    func backToRoot()
    func addAndChangeFood(_ food: FoodRealm)
}
