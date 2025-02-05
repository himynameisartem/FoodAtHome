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
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Absinthe")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    let weightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    var weightLabel = UILabel()
    var productionDateLabel = UILabel()
    var expirationDateLabel = UILabel()
    var consumeUpLabel = UILabel()
    let weightUnitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 5
        return button
    }()
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.0"
        textField.textAlignment = .center
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 5
        return textField
    }()
    let productionDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        return textField
    }()
    let expirationDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        return textField
    }()
    let consumeUpTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = #colorLiteral(red: 0.7329999804, green: 0.6669999957, blue: 1, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.7329999804, green: 0.6669999957, blue: 1, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitle("Add", for: .normal)
        return button
    }()
    
    
    
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
        configure()
    }
    
    // MARK: Setup
    
    private func configure() {
        weightLabel.text = "Weight: "
        productionDateLabel.text = "Production date: "
        expirationDateLabel.text = "Expiration date: "
        consumeUpLabel.text = "Consume up: "
    }
    
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
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        weightUnitButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        view.addSubview(closeButton)
        view.addSubview(foodImageView)
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(rightStackView)
        leftStackView.addArrangedSubview(weightLabel)
        leftStackView.addArrangedSubview(productionDateLabel)
        leftStackView.addArrangedSubview(expirationDateLabel)
        leftStackView.addArrangedSubview(consumeUpLabel)
        rightStackView.addArrangedSubview(weightStackView)
        weightStackView.addArrangedSubview(weightTextField)
        weightStackView.addArrangedSubview(weightUnitButton)
        rightStackView.addArrangedSubview(productionDateTextField)
        rightStackView.addArrangedSubview(expirationDateTextField)
        rightStackView.addArrangedSubview(consumeUpTextField)
        
        view.addSubview(addButton)
    }
    
    @objc private func didTapCloseButton() {
        presentingViewController?.dismiss(animated: true)
    }
    
    private func setupConstraints() {
        let heightForMainStackView = (view.frame.height - view.frame.width / 2) - 170
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            foodImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            foodImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            foodImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            foodImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2),
            
            mainStackView.topAnchor.constraint(equalTo: foodImageView.bottomAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.heightAnchor.constraint(equalToConstant: heightForMainStackView),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            
            mainStackView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -40),
            
        ])
    }
}

extension AddFoodViewController: AddFoodDisplayLogic {
    
    func displayData(viewModel: AddFood.Model.ViewModel.ViewModelData) {
        
    }
    
}

extension AddFoodViewController: UIPopoverPresentationControllerDelegate {
    func showPopUpMenu(sender: UIButton) {
        let menuVC = UIViewController()
        menuVC.modalPresentationStyle = .popover
        menuVC.preferredContentSize = CGSize(width: 100, height: 240)
        
        // Создаем стек с кнопками меню
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем кнопки в стек
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
        
        // Констрейнты для стека
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: menuVC.view.topAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: menuVC.view.centerXAnchor, constant: -5)
        ])
        
        // Настройка PopoverPresentationController
        if let popover = menuVC.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
            popover.permittedArrowDirections = .any
            popover.delegate = self
        }
        
        present(menuVC, animated: true)
    }
    
    // Делегат для поддержки стиля popover на iPhone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @objc func kgOptionTapped() {
        // Действие для первой опции
        dismiss(animated: true)
    }
    
    @objc func gOptionTapped() {
        // Действие для второй опции
        dismiss(animated: true)
    }
    @objc func lOptionTapped() {
        // Действие для первой опции
        dismiss(animated: true)
    }
    
    @objc func mlOptionTapped() {
        // Действие для второй опции
        dismiss(animated: true)
    }
    @objc func pkOptionTapped() {
        // Действие для первой опции
        dismiss(animated: true)
    }
    
    @objc func pcsOptionTapped() {
        // Действие для второй опции
        dismiss(animated: true)
    }
    
    @objc func showMenu(sender: UIButton) {
        showPopUpMenu(sender: sender)
    }
}
