//
//  FoodListPresenterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.07.2023.
//

import Foundation

protocol FoodListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func tappedSearch()
    func updateSearchResults(for searchText: String)
    func selectedCategories(at indexPath: IndexPath) -> [FoodRealm]
}
