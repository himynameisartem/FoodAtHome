//
//  MyFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

@objc protocol MyFoodRoutingLogic {
    func routeToCategoryDetails(segue: UIStoryboardSegue?)
    func routeToAddFood(segue: UIStoryboardSegue?)
}

protocol MyFoodDataPassing {
    var dataStore: MyFoodDataStore? { get }
}

class MyFoodRouter: NSObject, MyFoodRoutingLogic, MyFoodDataPassing {
    
    weak var viewController: MyFoodViewController?
    var dataStore: MyFoodDataStore?
    var worker = MyFoodWorker()
    var addFoodMenu = AddFoodMenu()
    
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
    
    func routeToAddFood(segue: UIStoryboardSegue?) {
        let destinationVC = AddFoodViewController()
        if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
            passDataToEditFood(source: sourceDS, destination: &destinationDS)
        }
        navigationToEditFood(source: viewController!, destination: destinationVC)
    }
    
//MARK: Navigation
    
    func navigateToCategoryDetails(source: MyFoodViewController, destination: CategoryDetailsViewController) {
        source.show(destination, sender: nil)
    }
    
    func navigationToEditFood(source: MyFoodViewController, destination: AddFoodViewController) {
        destination.transitioningDelegate = viewController
        destination.modalPresentationStyle = .custom
        source.present(destination, animated: true)
    }
    
    
//MARK: Passing data
    
    func passDataToCategoryDetails(source: MyFoodDataStore, destination: inout CategoryDetailsDataStore) {
        guard let indexPath = viewController?.categoryCollectionView.indexPathsForSelectedItems?.first else { return }
        let category = source.categories[indexPath.row]
        let food = worker.prepareFoodForRouting(source: source.myFood, type: category)
        destination.category = category
        destination.food = food
    }
    
    func passDataToEditFood(source: MyFoodDataStore, destination: inout AddFoodDataStore) {
        destination.food = source.editingFood
    }
}
