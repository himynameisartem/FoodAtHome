//
//  ShoppingListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListDisplayLogic: AnyObject {
    func displayData(viewModel: ShoppingList.ShoppingListModel.ViewModel)
//    func deleteFood()
//    func addToMyFood()
//    func deleteAllFood()
}

class ShoppingListViewController: UIViewController {
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var titleBalLabel: UILabel!
    
    var interactor: ShoppingListBusinessLogic?
    var router: (NSObjectProtocol & ShoppingListRoutingLogic)?
    
    var shoppingList: [ShoppingList.ShoppingListModel.ViewModel.DisplayedFood] = []
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ShoppingListInteractor()
        let presenter = ShoppingListPresenter()
        let router = ShoppingListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        getFoodList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationBarSetup()
        getFoodList()
        setupTabluView()
    }
        
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    @IBAction func addFoodButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ChoiseFoodForShoppingList", sender: nil)
    }
    
    private func getFoodList() {
        let request = ShoppingList.ShoppingListModel.Request()
        interactor?.showFoodList(request: request)
    }
    
    private func navigationBarSetup() {
        let x = -(view.frame.width / 2) + 10
        let y = view.frame.origin.y - ((navigationController?.navigationBar.frame.height ?? 0) / 2)
        let height = navigationController?.navigationBar.frame.height ?? 0
        let width = view.frame.width / 2
        titleBalLabel.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func setupTabluView() {
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListCell")
    }
}

//MARK: -

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        
        return cell
    }
    
    
    
    
}

//MARK: - ShoppingListDisplayLogic

extension ShoppingListViewController: ShoppingListDisplayLogic {
    
    func displayData(viewModel: ShoppingList.ShoppingListModel.ViewModel) {
        shoppingList = viewModel.displayedFood
        print(viewModel.displayedFood)
    }
}
