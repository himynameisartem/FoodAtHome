//
//  CategoryFoodManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 11.07.2023.
//

import UIKit

class CategoryFoodManager {
    
    static let shared = CategoryFoodManager()
    
    func appendFoodOnType(at indexPath: IndexPath, from myFood: [FoodRealm]) -> [FoodRealm] {
        
        var foodArray: [FoodRealm] = []
        
        for i in myFood {
            
            switch i.type {
            case "vegetables":
                if foodCatigoriesList[indexPath.row] == "Vegetables".localized() {
                    foodArray.append(i)
                }
            case "fruitsAndBerries":
                if foodCatigoriesList[indexPath.row] == "Fruits and Berries".localized() {
                    foodArray.append(i)
                }
            case "mushrooms":
                if foodCatigoriesList[indexPath.row] == "Mushrooms".localized() {
                    foodArray.append(i)
                }
            case "eggsAndDairyProducts":
                if foodCatigoriesList[indexPath.row] == "Eggs and Dairy Products".localized() {
                    foodArray.append(i)
                }
            case "meatProducts":
                if foodCatigoriesList[indexPath.row] == "Meat Products".localized() {
                    foodArray.append(i)
                }
            case "fishAndSeafood":
                if foodCatigoriesList[indexPath.row] == "Fish and Seafood".localized() {
                    foodArray.append(i)
                }
            case "nutsAndDriedFruits":
                if foodCatigoriesList[indexPath.row] == "Nuts and Dried Fruits".localized() {
                    foodArray.append(i)
                }
            case "flourAndFlourProducts":
                if foodCatigoriesList[indexPath.row] == "МFlour and Bakery Products".localized() {
                    foodArray.append(i)
                }
            case "cereals":
                if foodCatigoriesList[indexPath.row] == "Grains and Porridge".localized() {
                    foodArray.append(i)
                }
            case "confectioneryAndSweets":
                if foodCatigoriesList[indexPath.row] == "Sweets and Confectionery".localized() {
                    foodArray.append(i)
                }
            case "greensAndFlowers":
                if foodCatigoriesList[indexPath.row] == "Greens and Herbs".localized() {
                    foodArray.append(i)
                }
            case "spices":
                if foodCatigoriesList[indexPath.row] == "Spices and Seasonings".localized() {
                    foodArray.append(i)
                }
            case "additives":
                if foodCatigoriesList[indexPath.row] == "Raw Materials and Additives".localized() {
                    foodArray.append(i)
                }
            case "babyFood":
                if foodCatigoriesList[indexPath.row] == "Baby Food".localized() {
                    foodArray.append(i)
                }
            case "softDrinks":
                if foodCatigoriesList[indexPath.row] == "Non-Alcoholic Beverages".localized() {
                    foodArray.append(i)
                }
            case "alcoholicDrinks":
                if foodCatigoriesList[indexPath.row] == "Alcoholic Beverages".localized() {
                    foodArray.append(i)
                }
            default:
                break
            }
        }
        return foodArray
    }
    
}
