//
//  CategoryFoodViewProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2023.
//

import Foundation

protocol CategoryFoodViewProtocol: AnyObject {
    func setImage(_ imageName: String)
    func setName(_ categoryName: String)
}
