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
    
    @IBOutlet weak var foodListTableView: UITableView!
    
    private let backButton = UIBarButtonItem()
    private let searchButton = UIBarButtonItem()
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
        setupNavigationView()
        setupTableView()
    }

    private func setupNavigationView() {
        backButton.tintColor = .black
        backButton.image = UIImage(systemName: "chevron.backward")
        searchButton.tintColor = .black
        searchButton.image = UIImage(systemName: "magnifyingglass")
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = searchButton
        backButton.target = self
        backButton.action = #selector(backButtonTapped(sender:))
        searchButton.target = self
        searchButton.action = #selector(searchButtonTapped(sender:))
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.resignFirstResponder()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search".localized()
        searchController.searchBar.setValue("Cancel".localized(), forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .black

    }

    private func hideSearchBar() {
        navigationItem.titleView = .none
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func setupTableView() {
        foodListTableView.delegate = self
        foodListTableView.dataSource = self
        foodListTableView.register(UINib(nibName: "FoodListTableViewCell", bundle: nil), forCellReuseIdentifier: "foodListCell")
        
    }
    
    
    @objc private func searchButtonTapped(sender: UIBarButtonItem) {
        navigationItem.titleView = searchController.searchBar
        navigationItem.leftBarButtonItem = .none
        navigationItem.rightBarButtonItem = .none
        searchController.searchBar.becomeFirstResponder()
        hideSearchBarGesture.addTarget(self, action: #selector(tapForCloseSearchBar))
        view.addGestureRecognizer(hideSearchBarGesture)
    }
    
    @objc private func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func tapForCloseSearchBar() {
        hideSearchBar()
        view.removeGestureRecognizer(hideSearchBarGesture)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ChoiseFoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodListCell", for: indexPath) as! FoodListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.width / 3.9
        return height
    }
}

//MARK: - UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating

extension ChoiseFoodViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}

//MARK: - ChoiseFoodDisplayLogic

extension ChoiseFoodViewController: ChoiseFoodDisplayLogic {
    
    func displayFood(viewModel: ChoiseFood.Model.ViewModel) {
        
    }
}

