//
//  AddShoppingListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListDisplayLogic: AnyObject {
    func displayData(viewModel: AddShoppingListModel.ShowFood.ViewModel)
    func displayCheckedWeightField(viewModel: AddShoppingListModel.CheckWeightField.ViewModel)
    func displayCheckedDuplicate(viewModel: AddShoppingListModel.CheckDuplicate.ViewModel)
    func displayCheckedEditAction(viewModel: AddShoppingListModel.CheckEditAction.ViewModel)
    func displayConfirmAddFood(viewModel: AddShoppingListModel.ConfirmAddFood.ViewModel)
    func displayConfirmChangeFood(viewModel: AddShoppingListModel.ConfirmChangeFood.ViewModel)
    func displayConfirmEditAction(viewModel: AddShoppingListModel.ConfirmEditAction.ViewModel)
}

class AddShoppingListViewController: UIViewController, AddShoppingListDisplayLogic {
    
    var interactor: AddShoppingListBusinessLogic?
    var router: (NSObjectProtocol & AddShoppingListRoutingLogic & AddShoppingListDataPassing)?
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let worker = AddShoppingListWorker()
        let interactor = AddShoppingListInteractor(worker: worker)
        let presenter = AddShoppingListPresenter()
        let router = AddShoppingListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFoodData()
        configureUI()
        setupConstraints()
    }
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.tintColor = .text
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Absinthe")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 8
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
        label.textColor = .text
        return label
    }()
    private let weightUnitButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.text, for: .normal)
        button.backgroundColor = .textField
        button.setTitle("kg.".localized(), for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    private let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.0"
        textField.textAlignment = .center
        textField.backgroundColor = .textField
        textField.textColor = .text
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
    private var panGestureRecognizer = UIPanGestureRecognizer()
    private var initialY: CGFloat = 0
    
    private func fetchFoodData() {
        let request = AddShoppingListModel.ShowFood.Request()
        interactor?.showSelectedFood(request: request)
    }
    
    private func configureUI() {
        view.backgroundColor = .foodCardCell
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        self.view.makeShadow(opacity: 0.3)
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            foodImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            foodImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            foodImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            foodImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            mainStackView.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func didTapCloseButton() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -self.view.frame.height
        } completion: { _ in
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    private func performCloseAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = -self.view.frame.height
        }, completion: { _ in
            self.router?.navigateToTabBarController(window: self.view.window!)
        })
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
            let request = AddShoppingListModel.CheckWeightField.Request(weight: self.weightTextField.text ?? "")
            self.interactor?.checkWeightField(request: request)
        }
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
        kgOption.tintColor = .text
        
        let gOption = UIButton(type: .system)
        gOption.setTitle("g.".localized(), for: .normal)
        gOption.addTarget(self, action: #selector(gOptionTapped), for: .touchUpInside)
        gOption.tintColor = .text
        
        let lOption = UIButton(type: .system)
        lOption.setTitle("l.".localized(), for: .normal)
        lOption.addTarget(self, action: #selector(lOptionTapped), for: .touchUpInside)
        lOption.tintColor = .text
        
        let mlOption = UIButton(type: .system)
        mlOption.setTitle("ml.".localized(), for: .normal)
        mlOption.addTarget(self, action: #selector(mlOptionTapped), for: .touchUpInside)
        mlOption.tintColor = .text
        
        let pkOption = UIButton(type: .system)
        pkOption.setTitle("pk.".localized(), for: .normal)
        pkOption.addTarget(self, action: #selector(pkOptionTapped), for: .touchUpInside)
        pkOption.tintColor = .text
        
        let pcsOption = UIButton(type: .system)
        pcsOption.setTitle("pcs.".localized(), for: .normal)
        pcsOption.addTarget(self, action: #selector(pcsOptionTapped), for: .touchUpInside)
        pcsOption.tintColor = .text
        
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
    func displayData(viewModel: AddShoppingListModel.ShowFood.ViewModel) {
        foodImageView.image = viewModel.image
        weightTextField.text = viewModel.weight
        if viewModel.unit != "" {
            weightUnitButton.setTitle(viewModel.unit, for: .normal)
        } else {
            weightUnitButton.setTitle("kg.".localized(), for: .normal)
        }
    }
    
    func displayCheckedWeightField(viewModel: AddShoppingListModel.CheckWeightField.ViewModel) {
        if viewModel.isValid {
            let alertController = UIAlertController(title: viewModel.aletrtTitle, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: viewModel.okButtonTitle, style: .default))
            self.present(alertController, animated: true)
        } else {
            let request = AddShoppingListModel.CheckEditAction.Request()
            interactor?.checkEditAction(request: request)
        }
    }
    
    func displayCheckedEditAction(viewModel: AddShoppingListModel.CheckEditAction.ViewModel) {
        if viewModel.isValid {
            let request = AddShoppingListModel.ConfirmEditAction.Request(weight: self.weightTextField.text ?? "",
                                                                         unit: self.weightUnitButton.titleLabel?.text ?? "kg.".localized())
            interactor?.confirmEditAction(request: request)
        } else {
            let request = AddShoppingListModel.CheckDuplicate.Request()
            interactor?.checkDuplicate(request: request)
        }
    }
    
    func displayCheckedDuplicate(viewModel: AddShoppingListModel.CheckDuplicate.ViewModel) {
        if viewModel.isValid {
            let alertController = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: viewModel.confirmActionTitle, style: .destructive, handler: { _ in
                let request = AddShoppingListModel.ConfirmChangeFood.Request(weight: self.weightTextField.text ?? "",
                                                                             unit: self.weightUnitButton.titleLabel?.text ?? "kg.".localized())
                self.interactor?.confirmChangeFood(request: request)
            }))
            alertController.addAction(UIAlertAction(title: viewModel.cancelActionTitle, style: .cancel))
            self.present(alertController, animated: true)
        } else {
            let request = AddShoppingListModel.ConfirmAddFood.Request(weight: self.weightTextField.text ?? "",
                                                                      unit: self.weightUnitButton.titleLabel?.text ?? "kg.".localized())
            interactor?.confirmAddItemToShoppingList(request: request)
        }
    }
    
    func displayConfirmAddFood(viewModel: AddShoppingListModel.ConfirmAddFood.ViewModel) {
        performCloseAnimation()
    }
    
    func displayConfirmChangeFood(viewModel: AddShoppingListModel.ConfirmChangeFood.ViewModel) {
        performCloseAnimation()
    }
    
    func displayConfirmEditAction(viewModel: AddShoppingListModel.ConfirmEditAction.ViewModel) {
        performCloseAnimation()
    }
}

