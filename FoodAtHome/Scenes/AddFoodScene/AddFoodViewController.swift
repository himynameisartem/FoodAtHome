//
//  AddFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodDisplayLogic: AnyObject {
    func displayData(viewModel: AddFood.Model.ViewModel.ViewModelData)
}

class AddFoodViewController: UIViewController {
    
    var closeButton: UIButton!
    
    var interactor: AddFoodBusinessLogic?
    var router: (NSObjectProtocol & AddFoodRoutingLogic)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AddFoodInteractor()
        let presenter = AddFoodPresenter()
        let router = AddFoodRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.tintColor = .black
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.addSubview(closeButton)
    }
    
    @objc private func didTapCloseButton() {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}

extension AddFoodViewController: AddFoodDisplayLogic {
    
    func displayData(viewModel: AddFood.Model.ViewModel.ViewModelData) {
        
    }
    
}
