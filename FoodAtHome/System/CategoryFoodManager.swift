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
                if foodCatigoriesList[indexPath.row].localized() == "Vegetables".localized() {
                    foodArray.append(i)
                }
            case "fruitsAndBerries":
                if foodCatigoriesList[indexPath.row].localized() == "Fruits and Berries".localized() {
                    foodArray.append(i)
                }
            case "mushrooms":
                if foodCatigoriesList[indexPath.row].localized() == "Mushrooms".localized() {
                    foodArray.append(i)
                }
            case "eggsAndDairyProducts":
                if foodCatigoriesList[indexPath.row].localized() == "Eggs and Dairy Products".localized() {
                    foodArray.append(i)
                }
            case "meatProducts":
                if foodCatigoriesList[indexPath.row].localized() == "Meat Products".localized() {
                    foodArray.append(i)
                }
            case "fishAndSeafood":
                if foodCatigoriesList[indexPath.row].localized() == "Fish and Seafood".localized() {
                    foodArray.append(i)
                }
            case "nutsAndDriedFruits":
                if foodCatigoriesList[indexPath.row].localized() == "Nuts and Dried Fruits".localized() {
                    foodArray.append(i)
                }
            case "flourAndFlourProducts":
                if foodCatigoriesList[indexPath.row].localized() == "МFlour and Bakery Products".localized() {
                    foodArray.append(i)
                }
            case "cereals":
                if foodCatigoriesList[indexPath.row].localized() == "Grains and Porridge".localized() {
                    foodArray.append(i)
                }
            case "confectioneryAndSweets":
                if foodCatigoriesList[indexPath.row].localized() == "Sweets and Confectionery".localized() {
                    foodArray.append(i)
                }
            case "greensAndFlowers":
                if foodCatigoriesList[indexPath.row].localized() == "Greens and Herbs".localized() {
                    foodArray.append(i)
                }
            case "spices":
                if foodCatigoriesList[indexPath.row].localized() == "Spices and Seasonings".localized() {
                    foodArray.append(i)
                }
            case "additives":
                if foodCatigoriesList[indexPath.row].localized() == "Raw Materials and Additives".localized() {
                    foodArray.append(i)
                }
            case "babyFood":
                if foodCatigoriesList[indexPath.row].localized() == "Baby Food".localized() {
                    foodArray.append(i)
                }
            case "softDrinks":
                if foodCatigoriesList[indexPath.row].localized() == "Non-Alcoholic Beverages".localized() {
                    foodArray.append(i)
                }
            case "alcoholicDrinks":
                if foodCatigoriesList[indexPath.row].localized() == "Alcoholic Beverages".localized() {
                    foodArray.append(i)
                }
            default:
                break
            }
        }
        return foodArray
    }
    
}
