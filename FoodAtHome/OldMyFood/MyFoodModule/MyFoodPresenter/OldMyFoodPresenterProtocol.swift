//
//  MyFoodPresenterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import UIKit

protocol OldMyFoodPresenterProtocol: AnyObject {
    var myFood: [FoodRealm] { get }
    var myFoodCount: Int? { get }
    func viewDidLoad()
    func food(atIndex idexPath: IndexPath) -> FoodRealm?
    
    func showPopupMenu(from sourceCell: UICollectionViewCell?, at indexPath: IndexPath?, from viewController: UIViewController)
    func hidePopupMenu(from viewController: UIViewController, and tapGesture: UITapGestureRecognizer)
    func configurePopupMenu(food: FoodRealm)
    
    func showCategoryFood(at indexPath: IndexPath)
    
    func showChangeFoodMenu(for viewController: UIViewController)
    func configureChangeFoodMenu(food: FoodRealm)
    func deleteFood(food: FoodRealm)
    func changeFood(_ food: FoodRealm, viewController: UIViewController)
    func showFoodListViewController()
    
    func removeAllFood()
    func removeExpiredProducts(food: [FoodRealm])
}
