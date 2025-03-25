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
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Absinthe")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight:".localized()
        return label
    }()
    private let weightUnitButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.setTitle("kg.".localized(), for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    private let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.0"
        textField.textAlignment = .center
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 5
        textField.keyboardType = .decimalPad
        textField.addDoneButtonToKeyboard()
        return textField
    }()
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = #colorLiteral(red: 0.7329999804, green: 0.6669999957, blue: 1, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.7329999804, green: 0.6669999957, blue: 1, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("Add".localized(), for: .normal)
        return button
    }()
    
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
        setupConstraints()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        weightUnitButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        view.addSubview(closeButton)
        view.addSubview(foodImageView)
        view.addSubview(mainStackView)
        view.addSubview(inputStackView)
        mainStackView.addArrangedSubview(weightLabel)
        mainStackView.addArrangedSubview(inputStackView)
        inputStackView.addArrangedSubview(weightTextField)
        inputStackView.addArrangedSubview(weightUnitButton)
        view.addSubview(addButton)
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureRecognizer))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func didTapCloseButton() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -self.view.frame.height
        } completion: { _ in
            self.presentingViewController?.dismiss(animated: true)
        }
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
    
    @objc func didTapAddButton(_ sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
//            self.interactor?.handleCloseRequest()
        }
    }
    
    private func setupConstraints() {
//        let heightForMainStackView = (view.frame.height - view.frame.width / 2) - 170
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            foodImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            foodImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            foodImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            foodImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            mainStackView.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            mainStackView.heightAnchor.constraint(equalToConstant: heightForMainStackView),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            
//            mainStackView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -40),
            
        ])
    }
}

//MARK: - UIPopoverPresentationControllerDelegate

extension AddShoppingListViewController: UIPopoverPresentationControllerDelegate {
    private func showPopUpMenu(sender: UIButton) {
        let menuVC = UIViewController()
        menuVC.modalPresentationStyle = .popover
        menuVC.preferredContentSize = CGSize(width: 100, height: 240)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let kgOption = UIButton(type: .system)
        kgOption.setTitle("kg.".localized(), for: .normal)
        kgOption.addTarget(self, action: #selector(kgOptionTapped), for: .touchUpInside)
        kgOption.tintColor = .black
        
        let gOption = UIButton(type: .system)
        gOption.setTitle("g.".localized(), for: .normal)
        gOption.addTarget(self, action: #selector(gOptionTapped), for: .touchUpInside)
        gOption.tintColor = .black
        
        let lOption = UIButton(type: .system)
        lOption.setTitle("l.".localized(), for: .normal)
        lOption.addTarget(self, action: #selector(lOptionTapped), for: .touchUpInside)
        lOption.tintColor = .black
        
        let mlOption = UIButton(type: .system)
        mlOption.setTitle("ml.".localized(), for: .normal)
        mlOption.addTarget(self, action: #selector(mlOptionTapped), for: .touchUpInside)
        mlOption.tintColor = .black
        
        let pkOption = UIButton(type: .system)
        pkOption.setTitle("pk.".localized(), for: .normal)
        pkOption.addTarget(self, action: #selector(pkOptionTapped), for: .touchUpInside)
        pkOption.tintColor = .black
        
        let pcsOption = UIButton(type: .system)
        pcsOption.setTitle("pcs.".localized(), for: .normal)
        pcsOption.addTarget(self, action: #selector(pcsOptionTapped), for: .touchUpInside)
        pcsOption.tintColor = .black
        
        stackView.addArrangedSubview(kgOption)
        stackView.addArrangedSubview(gOption)
        stackView.addArrangedSubview(lOption)
        stackView.addArrangedSubview(mlOption)
        stackView.addArrangedSubview(pkOption)
        stackView.addArrangedSubview(pcsOption)
        
        menuVC.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: menuVC.view.topAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: menuVC.view.centerXAnchor, constant: -5)
        ])
        
        if let popover = menuVC.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = .any
            popover.delegate = self
        }
        
        present(menuVC, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @objc private func kgOptionTapped() {
        weightUnitButton.setTitle("kg.".localized(), for: .normal)
        dismiss(animated: true)
    }
    
    @objc private func gOptionTapped() {
        weightUnitButton.setTitle("g.".localized(), for: .normal)
        dismiss(animated: true)
    }
    @objc private func lOptionTapped() {
        weightUnitButton.setTitle("l.".localized(), for: .normal)
        dismiss(animated: true)
    }
    
    @objc private func mlOptionTapped() {
        weightUnitButton.setTitle("ml.".localized(), for: .normal)
        dismiss(animated: true)
    }
    @objc private func pkOptionTapped() {
        weightUnitButton.setTitle("pk.".localized(), for: .normal)
        dismiss(animated: true)
    }
    
    @objc private func pcsOptionTapped() {
        weightUnitButton.setTitle("pcs.".localized(), for: .normal)
        dismiss(animated: true)
    }
    
    @objc private func showMenu(sender: UIButton) {
        showPopUpMenu(sender: sender)
    }
}

//MARK: - AddShoppingListDisplayLogic

extension AddShoppingListViewController {
    func displayData(viewModel: AddShoppingList.Model.ViewModel) {
        
    }
}
