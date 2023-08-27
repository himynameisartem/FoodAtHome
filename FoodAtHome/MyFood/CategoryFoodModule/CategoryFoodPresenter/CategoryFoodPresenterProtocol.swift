//
//  CategoryFoodPresenterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2023.
//

import Foundation

protocol CategoryFoodPresenterProtocol: AnyObject {
    var foodCount: Int { get }
    func viewDidLoad()
    func getFood(at indexPath: IndexPath) -> FoodRealm?
}
