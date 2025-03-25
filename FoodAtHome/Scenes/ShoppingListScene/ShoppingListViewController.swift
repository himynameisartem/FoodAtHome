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
//    func deleteAllFood()
}

class ShoppingListViewController: UIViewController {
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var titleBalLabel: UILabel!
    
    var interactor: ShoppingListBusinessLogic?
    var router: (NSObjectProtocol & ShoppingListRoutingLogic & ShoppingListDataPassing)?
    
    var shoppingList: [ShoppingList.ShoppingListModel.ViewModel.DisplayedFood] = []
    
    var menuType: ShoppingList.EditingFood.ViewModel?
    
    private var dimmingView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    
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
        router.dataStore = interactor
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
        setupDimmingView()
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
    
    private func setupDimmingView() {
        blurEffect = UIBlurEffect(style: .dark)
        dimmingView = UIVisualEffectView(frame: view.bounds)
        dimmingView.effect = blurEffect
        dimmingView.alpha = 0
    }
    
    private func editingExpirationDate(at indexPath: IndexPath) {
        let request = ShoppingList.EditingFood.Request(indexPath: indexPath)
        interactor?.getEditingFood(request: request)
        router?.routeToAddFood()
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
                self.editingExpirationDate(at: indexPath)
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
            self.router?.routeToEditShoppingList()
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

//MARK: - UIViewControllerTransitioningDelegate

extension ShoppingListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ShoppingListViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        
        var height = CGFloat()
        if transitionContext.viewController(forKey: .to)! is AddFoodViewController {
            height = 350
        } else if transitionContext.viewController(forKey: .to)! is AddShoppingListViewController {
            height = 200
        }
        trasitionAnimationForAddFoodVC(for: self, height: height, using: transitionContext, and: dimmingView)
    }
}

//MARK: - ShoppingListDisplayLogic

extension ShoppingListViewController: ShoppingListDisplayLogic {
    
    func displayData(viewModel: ShoppingList.ShoppingListModel.ViewModel) {
        shoppingList = viewModel.displayedFood
        shoppingListTableView.reloadData()
    }
        
    func deleteFood() {
        DispatchQueue.main.async {
            self.getFoodList()
        }
    }
}
