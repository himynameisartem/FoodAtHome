//
//  FoodListViewProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

protocol FoodListViewProtocol: AnyObject {
    func reloadData()
    func showSearchBar()
    func dysplayFilteredFood(_ filteredFood: [FoodRealm])
}
