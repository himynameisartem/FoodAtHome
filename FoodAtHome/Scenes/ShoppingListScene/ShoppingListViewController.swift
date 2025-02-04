//
//  ShoppingListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListDisplayLogic: AnyObject {
    func displayData(viewModel: ShoppingList.ShoppingListModel.ViewModel)
    func deleteFood()
    func addToMyFood(viewModel: ShoppingList.AddToMyFood.ViewModel)
    func changeFood(viewModel: ShoppingList.ChangeFood.ViewModel)
//    func deleteAllFood()
}

class ShoppingListViewController: UIViewController {
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var titleBalLabel: UILabel!
    
    var interactor: ShoppingListBusinessLogic?
    var router: (NSObjectProtocol & ShoppingListRoutingLogic)?
    
    var shoppingList: [ShoppingList.ShoppingListModel.ViewModel.DisplayedFood] = []
    
    private var addFoodMenu = AddFoodMenu()
    
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
        setupAddFoodMenu()
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
    
    private func setupAddFoodMenu() {
        addFoodMenu = Bundle.main.loadNibNamed("AddFoodMenu", owner: ChoiseFoodViewController.self)?.first as! AddFoodMenu
    }
}

//MARK: -

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        let viewModel = shoppingList[indexPath.row]
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .normal, title: nil) { contextialAction, view, boolCompletion in
            let request = ShoppingList.DeleteFood.Request(indexPath: indexPath)
            self.interactor?.deleteFood(request: request)
        }
        let successItem = UIContextualAction(style: .normal, title: nil) { contextialAction, view, boolCompletion in
            let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { _ in
                let request = ShoppingList.AddToMyFood.Request(indexPath: indexPath)
                self.interactor?.showAddToMyFood(request: request)
                boolCompletion(true)
            }
            let noAction = UIAlertAction(title: "No".localized(), style: .cancel) { _ in
                boolCompletion(true)
            }
            let alertController = UIAlertController(title: "Add an expiration date?".localized(), message: nil, preferredStyle: .alert)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true)
        }
        setupContextualMenu(action: deleteItem, "delete")
        setupContextualMenu(action: successItem, "success")
        let configuration = UISwipeActionsConfiguration(actions: [successItem, deleteItem])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editItem = UIContextualAction(style: .normal, title: nil) { contextialAction, view, boolCompletion in
            let request = ShoppingList.ChangeFood.Request(indexPath: indexPath)
            self.interactor?.showChangeFood(request: request)
            boolCompletion(true)
        }
        setupContextualMenu(action: editItem, "edit")
        let configuration = UISwipeActionsConfiguration(actions: [editItem])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        (view.frame.width - 30) / 3.6
        let height = view.frame.width / 3.9
        return height
    }
    
    func setupContextualMenu(action: UIContextualAction,_ imageName: String) {
        action.backgroundColor = .systemGray5
        action.image = UIImage(named: imageName)

        action.image?.withRenderingMode(.alwaysOriginal)
        action.backgroundColor = .systemGray6
        let buttonSize = CGSize(width: 50, height: 50)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        action.image = UIGraphicsImageRenderer(size: buttonSize).image { _ in
            UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSize), cornerRadius: buttonSize.width / 2).addClip()
            action.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSize).inset(by: insets))
        }
    }
}

//MARK: - ShoppingListDisplayLogic

extension ShoppingListViewController: ShoppingListDisplayLogic {
    
    func displayData(viewModel: ShoppingList.ShoppingListModel.ViewModel) {
        shoppingList = viewModel.displayedFood
        shoppingListTableView.reloadData()
    }
    
    func addToMyFood(viewModel: ShoppingList.AddToMyFood.ViewModel) {
//        addFoodMenu.configure(from: viewModel.food)
        addFoodMenu.showMenu(size: .full)
        addFoodMenu.delegate = self
    }
    
    func changeFood(viewModel: ShoppingList.ChangeFood.ViewModel) {
//        addFoodMenu.configure(from: viewModel.food)
        addFoodMenu.showMenu(size: .small)
        addFoodMenu.delegate = self
    }
    
    func deleteFood() {
        DispatchQueue.main.async {
            self.getFoodList()
        }
    }
}

//MARK: - AddFoodMenuDelegate

extension ShoppingListViewController: AddFoodMenuDelegate {
    func didCloseAddFood() {
        DispatchQueue.main.async{
            self.getFoodList()
        }
    }
}
