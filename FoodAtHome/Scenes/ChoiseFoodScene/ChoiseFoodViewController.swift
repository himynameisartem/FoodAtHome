//
//  ChoiseFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

protocol ChoiseFoodDisplayLogic: AnyObject {
    func displayFood(viewModel: ChoiseFood.Model.ViewModel)
}

class ChoiseFoodViewController: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let hideSearchBarGesture = UITapGestureRecognizer()
    
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
        setupSearchBar()
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        navItem.titleView = self.searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
        navItem.hidesBackButton = true
        navItem.rightBarButtonItem = .none
        navItem.leftBarButtonItem = .none
        hideSearchBarGesture.addTarget(self, action: #selector(tapForCloseSearchBar))
        view.addGestureRecognizer(hideSearchBarGesture)
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.resignFirstResponder()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search".localized()
        searchController.searchBar.setValue("Cancel".localized(), forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .black
        searchController.delegate = self

    }
    
    private func hideSearchBar() {
        navItem.titleView = .none
        navItem.leftBarButtonItem = backButton
        navItem.rightBarButtonItem = searchButton
    }
    
    @objc private func tapForCloseSearchBar() {
        hideSearchBar()
        view.removeGestureRecognizer(hideSearchBarGesture)
    }
}

extension ChoiseFoodViewController: ChoiseFoodDisplayLogic {
    
    func displayFood(viewModel: ChoiseFood.Model.ViewModel) {
        
    }
}

extension ChoiseFoodViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}


