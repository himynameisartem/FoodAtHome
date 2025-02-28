//
//  AddShoppingListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListDisplayLogic: AnyObject {
    func displayData(viewModel: AddShoppingList.Model.ViewModel)
}

class AddShoppingListViewController: UIViewController, AddShoppingListDisplayLogic {
    
    var interactor: AddShoppingListBusinessLogic?
    var router: (NSObjectProtocol & AddShoppingListRoutingLogic & AddShoppingListDataPassing)?
    
    private var panGestureRecognizer = UIPanGestureRecognizer()
    private var initialY: CGFloat = 0
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AddShoppingListInteractor()
        let presenter = AddShoppingListPresenter()
        let router = AddShoppingListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
        
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureRecognizer))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func handlePanGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
        let screenSize = UIScreen.main.bounds.size
        let positionY = (screenSize.height - view.frame.height) / 2
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            initialY = view.frame.origin.y
        case .changed:
            let newY = initialY + translation.y
            if newY < positionY {
                view.frame.origin.y = newY
            }
        case .ended:
            let dismissThreshold = 0 - (view.frame.height / 4)
            if view.frame.origin.y < dismissThreshold {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = -self.view.frame.height
                } completion: { _ in
                    self.presentingViewController?.dismiss(animated: true)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = positionY
                }
            }
        default:
            break
        }
    }
}

//MARK: - AddShoppingListDisplayLogic

extension AddShoppingListViewController {
    func displayData(viewModel: AddShoppingList.Model.ViewModel) {
        
    }
}
