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
                if foodCatigoriesList[indexPath.row] == "Овощи" {
                    foodArray.append(i)
                }
            case "fruitsAndBerries":
                if foodCatigoriesList[indexPath.row] == "Фрукты и ягоды" {
                    foodArray.append(i)
                }
            case "mushrooms":
                if foodCatigoriesList[indexPath.row] == "Грибы" {
                    foodArray.append(i)
                }
            case "eggsAndDairyProducts":
                if foodCatigoriesList[indexPath.row] == "Яйца и молочные продукты" {
                    foodArray.append(i)
                }
            case "meatProducts":
                if foodCatigoriesList[indexPath.row] == "Мясные продукты" {
                    foodArray.append(i)
                }
            case "fishAndSeafood":
                if foodCatigoriesList[indexPath.row] == "Рыба и морепродукты" {
                    foodArray.append(i)
                }
            case "nutsAndDriedFruits":
                if foodCatigoriesList[indexPath.row] == "Орехи и сухофрукты" {
                    foodArray.append(i)
                }
            case "flourAndFlourProducts":
                if foodCatigoriesList[indexPath.row] == "Мука и мучные изделия" {
                    foodArray.append(i)
                }
            case "cereals":
                if foodCatigoriesList[indexPath.row] == "Крупы и каши" {
                    foodArray.append(i)
                }
            case "confectioneryAndSweets":
                if foodCatigoriesList[indexPath.row] == "Кондитерские изделия, сладости" {
                    foodArray.append(i)
                }
            case "greensAndFlowers":
                if foodCatigoriesList[indexPath.row] == "Зелень и цветы" {
                    foodArray.append(i)
                }
            case "spices":
                if foodCatigoriesList[indexPath.row] == "Специи и пряности" {
                    foodArray.append(i)
                }
            case "additives":
                if foodCatigoriesList[indexPath.row] == "Сырье и добавки" {
                    foodArray.append(i)
                }
            case "babyFood":
                if foodCatigoriesList[indexPath.row] == "Детское питание" {
                    foodArray.append(i)
                }
            case "softDrinks":
                if foodCatigoriesList[indexPath.row] == "Безалкогольные напитки" {
                    foodArray.append(i)
                }
            case "alcoholicDrinks":
                if foodCatigoriesList[indexPath.row] == "Алкогольные напитки" {
                    foodArray.append(i)
                }
            default:
                break
            }
        }
        return foodArray
    }
    
}
