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
                if foodListArray[indexPath.row] == "Овощи" {
                    foodArray.append(i)
                }
            case "fruitsAndBerries":
                if foodListArray[indexPath.row] == "Фрукты и ягоды" {
                    foodArray.append(i)
                }
            case "mushrooms":
                if foodListArray[indexPath.row] == "Грибы" {
                    foodArray.append(i)
                }
            case "eggsAndDairyProducts":
                if foodListArray[indexPath.row] == "Яйца и молочные продукты" {
                    foodArray.append(i)
                }
            case "meatProducts":
                if foodListArray[indexPath.row] == "Мясные продукты" {
                    foodArray.append(i)
                }
            case "fishAndSeafood":
                if foodListArray[indexPath.row] == "Рыба и морепродукты" {
                    foodArray.append(i)
                }
            case "nutsAndDriedFruits":
                if foodListArray[indexPath.row] == "Орехи и сухофрукты" {
                    foodArray.append(i)
                }
            case "flourAndFlourProducts":
                if foodListArray[indexPath.row] == "Мука и мучные изделия" {
                    foodArray.append(i)
                }
            case "cereals":
                if foodListArray[indexPath.row] == "Крупы и каши" {
                    foodArray.append(i)
                }
            case "confectioneryAndSweets":
                if foodListArray[indexPath.row] == "Кондитерские изделия, сладости" {
                    foodArray.append(i)
                }
            case "greensAndFlowers":
                if foodListArray[indexPath.row] == "Зелень и цветы" {
                    foodArray.append(i)
                }
            case "spices":
                if foodListArray[indexPath.row] == "Специи и пряности" {
                    foodArray.append(i)
                }
            case "additives":
                if foodListArray[indexPath.row] == "Сырье и добавки" {
                    foodArray.append(i)
                }
            case "babyFood":
                if foodListArray[indexPath.row] == "Детское питание" {
                    foodArray.append(i)
                }
            case "softDrinks":
                if foodListArray[indexPath.row] == "Безалкогольные напитки" {
                    foodArray.append(i)
                }
            case "alcoholicDrinks":
                if foodListArray[indexPath.row] == "Алкогольные напитки" {
                    foodArray.append(i)
                }
            default:
                break
            }
        }
        return foodArray
    }
    
}
