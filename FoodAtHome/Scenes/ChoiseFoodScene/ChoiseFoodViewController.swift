//
//  ChoiseFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ChoiseFoodDisplayLogic: AnyObject {
    func displayFood(viewModel: ChoiseFood.Model.ViewModel)
}

class ChoiseFoodViewController: UIViewController {
        
    @IBOutlet weak var navItem: UINavigationItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var interactor: ChoiseFoodBusinessLogic?
    var router: (NSObjectProtocol & ChoiseFoodRoutingLogic)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ChoiseFoodInteractor()
        let presenter = ChoiseFoodPresenter()
        let router = ChoiseFoodRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchController.searchBar.showsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.delegate = self
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if navItem.titleView == nil {
            navItem.titleView = searchController.searchBar
        } else {
            navItem.titleView = nil
        }
    }
}

extension ChoiseFoodViewController: ChoiseFoodDisplayLogic {
    
    func displayFood(viewModel: ChoiseFood.Model.ViewModel) {
        
    }
}

extension ChoiseFoodViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navItem.titleView = nil
    }
}


