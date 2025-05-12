//
//  ShoppingListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListDisplayLogic: AnyObject {
    func displayData(viewModel: ShoppingListModel.FetchShoppingList.ViewModel)
    func deleteFood(viewModel: ShoppingListModel.DeleteFood.ViewModel)
    func displayAddToMyFood(viewModel: ShoppingListModel.AddToMyFood.ViewModel)
    func displayConfirmEditingFood(viewModel: ShoppingListModel.ConfirmEditingFood.ViewModel)
    func displayConfirmAddToMyFood(viewModel: ShoppingListModel.ConfirmAddToMyFood.ViewModel)
    func displayEditingFood(viewModel: ShoppingListModel.PrepareEditing.ViewModel)
    func displaySharedShoppingList(viewModel: ShoppingListModel.FetchSharedShoppingList.ViewModel)
    func displayConfirmRemoveAllShoppingList(viewModel: ShoppingListModel.ConfirmRemoveAllShoppingList.ViewModel)
    func displayRemoveAllShoppingList(viewModel: ShoppingListModel.RemoveAllShoppingList.ViewModel)
}

class ShoppingListViewController: UIViewController {
    
    var interactor: ShoppingListBusinessLogic?
    var router: (NSObjectProtocol & ShoppingListRoutingLogic & ShoppingListDataPassing)?
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let worker = ShoppingListWorker()
        let interactor = ShoppingListInteractor(worker: worker)
        let presenter = ShoppingListPresenter()
        let router = ShoppingListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
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
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        fetchShoppingList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureNavigationBar()
        configureActivitiIndicator()
        fetchShoppingList()
        configureTableView()
        configureDimmingView()
    }
    
    @IBOutlet weak var shoppingListTableView: UITableView!
    @IBOutlet weak var titleBalLabel: UILabel! //исправить название
    
    private var shoppingListItems: [ShoppingListModel.FetchShoppingList.ViewModel.DisplayedFood] = []
    private var sharedActivitiIndicator: UIActivityIndicatorView!
    private var dimmingView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    
    @IBAction func addFoodButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ChoiseFoodForShoppingList", sender: nil)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        let request = ShoppingListModel.RemoveAllShoppingList.Request()
        interactor?.removeAllShoppingList(request: request)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let request = ShoppingListModel.FetchSharedShoppingList.Request()
        interactor?.fetchSharedShoppingList(request: request)
    }
    
    private func fetchShoppingList() {
        let request = ShoppingListModel.FetchShoppingList.Request()
        interactor?.fetchFoodList(request: request)
    }
    
    private func editAndMoveItem(at indexPath: IndexPath) {
        let request = ShoppingListModel.PrepareEditing.Request(indexPath: indexPath)
        interactor?.prepareEditingFood(request: request)
        router?.routeToAddFood()
    }
    
    private func configureNavigationBar() {
        let x = -(view.frame.width / 2) + 10
        let y = view.frame.origin.y - ((navigationController?.navigationBar.frame.height ?? 0) / 2)
        let height = navigationController?.navigationBar.frame.height ?? 0
        let width = view.frame.width / 2
        titleBalLabel.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func configureActivitiIndicator() {
        sharedActivitiIndicator = UIActivityIndicatorView(frame: view.bounds)
        view.addSubview(sharedActivitiIndicator)
        sharedActivitiIndicator.center = view.center
        sharedActivitiIndicator.style = .large
        sharedActivitiIndicator.hidesWhenStopped = true
    }
    
    private func configureTableView() {
        shoppingListTableView.register(UINib(nibName: "ShoppingListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShoppingListCell")
    }
    
    private func configureDimmingView() {
        blurEffect = UIBlurEffect(style: .dark)
        dimmingView = UIVisualEffectView(frame: view.bounds)
        dimmingView.effect = blurEffect
        dimmingView.alpha = 0
    }
    
    private func configureContextualMenu(action: UIContextualAction,_ imageName: String) {
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

//MARK: - UITableViewDelegate

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ShoppingListTableViewCell
        let viewModel = shoppingListItems[indexPath.row]
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteItem = UIContextualAction(style: .normal, title: nil) { contextialAction, view, boolCompletion in
            let request = ShoppingListModel.DeleteFood.Request(indexPath: indexPath)
            self.interactor?.deleteFood(request: request)
        }
        let successItem = UIContextualAction(style: .normal, title: nil) { contextialAction, view, boolCompletion in
            let request = ShoppingListModel.AddToMyFood.Request(indexPath: indexPath,
                                                                completion: boolCompletion)
            self.interactor?.addToMyFood(request: request)
        }
        configureContextualMenu(action: deleteItem, "delete")
        configureContextualMenu(action: successItem, "success")
        let configuration = UISwipeActionsConfiguration(actions: [successItem, deleteItem])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editItem = UIContextualAction(style: .normal, title: nil) { contextialAction, view, boolCompletion in
            self.router?.routeToEditShoppingList()
            boolCompletion(true)
        }
        configureContextualMenu(action: editItem, "edit")
        let configuration = UISwipeActionsConfiguration(actions: [editItem])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.width / 3.9
        return height
    }
}

//MARK: - UIViewControllerTransitioningDelegate

extension ShoppingListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        fetchShoppingList()
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
    
    func displayData(viewModel: ShoppingListModel.FetchShoppingList.ViewModel) {
        shoppingListItems = viewModel.displayedFood
        shoppingListTableView.reloadData()
    }
    
    func displayAddToMyFood(viewModel: ShoppingListModel.AddToMyFood.ViewModel) {
        let alertController = UIAlertController(title: viewModel.alerTitle, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: viewModel.yesActionTitle, style: .default, handler: { _ in
            viewModel.completion(true)
            let request = ShoppingListModel.ConfirmEditingFood.Request(indexPath: viewModel.indexPath)
            self.interactor?.confirmEditingFood(request: request)
            self.router?.routeToAddFood()
        }))
        alertController.addAction(UIAlertAction(title: viewModel.noActionTitle, style: .cancel, handler: { _ in
            viewModel.completion(true)
            let request = ShoppingListModel.ConfirmAddToMyFood.Request()
            self.interactor?.confirmAddToMyFood(request: request)
        }))
        self.present(alertController, animated: true)
    }
    
    func displayConfirmEditingFood(viewModel: ShoppingListModel.ConfirmEditingFood.ViewModel) {}
    
    func displayConfirmAddToMyFood(viewModel: ShoppingListModel.ConfirmAddToMyFood.ViewModel) {}
        
    func deleteFood(viewModel: ShoppingListModel.DeleteFood.ViewModel) {
        DispatchQueue.main.async {
            self.fetchShoppingList()
        }
    }
    
    func displayEditingFood(viewModel: ShoppingListModel.PrepareEditing.ViewModel) {}
    
    func displaySharedShoppingList(viewModel: ShoppingListModel.FetchSharedShoppingList.ViewModel) {
        sharedActivitiIndicator.startAnimating()
        let controller = UIActivityViewController(
            activityItems: [viewModel.foodList],
          applicationActivities: nil
        )
        DispatchQueue.main.async{
            self.present(controller, animated: true, completion: nil)
            if controller.isViewLoaded  {
                self.sharedActivitiIndicator.stopAnimating()
            }
        }
    }
    
    func displayRemoveAllShoppingList(viewModel: ShoppingListModel.RemoveAllShoppingList.ViewModel) {
        let alertController = UIAlertController(title: viewModel.alertTitle,
                                                message: viewModel.alertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: viewModel.confirmActionTitle, style: .destructive, handler: { _ in
            let request = ShoppingListModel.ConfirmRemoveAllShoppingList.Request()
            self.interactor?.confirmRemoveAllShoppingList(request: request)
        }))
        alertController.addAction(UIAlertAction(title: viewModel.cancelActionTitle, style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func displayConfirmRemoveAllShoppingList(viewModel: ShoppingListModel.ConfirmRemoveAllShoppingList.ViewModel) {
        if viewModel.isSuccess {
            self.fetchShoppingList()
        }
    }
}
