//
//  MyFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

@objc protocol MyFoodRoutingLogic {
    func routeToCategoryDetails(segue: UIStoryboardSegue?)
}

protocol MyFoodDataPassing {
    var dataStore: MyFoodDataStore? { get }
}

class MyFoodRouter: NSObject, MyFoodRoutingLogic, MyFoodDataPassing {
    
    weak var viewController: MyFoodViewController?
    var dataStore: MyFoodDataStore?
    // MARK: Routing
    
    func routeToCategoryDetails(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! CategoryDetailsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCategoryDetails(source: dataStore!, destination: &destinationDS)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "CategoryDetailsViewController") as! CategoryDetailsViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCategoryDetails(source: dataStore!, destination: &destinationDS)
            navigateToCategoryDetails(source: viewController!, destination: destinationVC)
        }
    }
    
//MARK: Navigation
    
    func navigateToCategoryDetails(source: MyFoodViewController, destination: CategoryDetailsViewController) {
        source.show(destination, sender: nil)

    }
    
//MARK: Passing data
    
    func passDataToCategoryDetails(source: MyFoodDataStore, destination: inout CategoryDetailsDataStore) {
        guard let indexPath = viewController?.categoryMyFoodCollectionView.indexPathsForSelectedItems?.first else { return }
        destination.category = source.categories[indexPath.row]
        destination.food = source.myFood
    }
}

