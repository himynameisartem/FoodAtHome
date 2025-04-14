//
//  AddFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodDisplayLogic: AnyObject {
    func displayData(viewModel: AddFoodModel.ShowFood.ViewModel)
    func displayUpdatedDates(viewModel: AddFoodModel.DateUpdate.ViewModel)
    func displayUpdatePickerValues(viewModel: AddFoodModel.DatePickerValueUpdate.ViewModel)
    func displayAlert(viewModel: AddFoodModel.AddFood.ViewModel)
}

class AddFoodViewController: UIViewController {
    
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
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    private let weightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight:".localized()
        return label
    }()
    private let productionDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Manufacturing Date:".localized()
        return label
    }()
    private let expirationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Expires on:".localized()
        return label
    }()
    private let consumeUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Shelf Life:".localized()
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
    private let datePickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    private let productionDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        textField.addDoneButtonToKeyboard()
        return textField
    }()
    private let expirationDateTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        textField.isEnabled = false
        textField.addDoneButtonToKeyboard()
        return textField
    }()
    private let consumeUpPickerView = UIPickerView()
    private let consumeUpTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        textField.isEnabled = false
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
    
    private let monthWheel: [Int] = Array(0...48)
    private let daysWheel: [Int] = Array(0...31)
    
    var interactor: AddFoodBusinessLogic?
    var router: (NSObjectProtocol & AddFoodRoutingLogic & AddFoodDataPassing)?
    
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
        setupUI()
        setupConstraints()
        getFood()
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
        router.dataStore = interactor
    }
    
    private func getFood() {
        let request = AddFoodModel.ShowFood.Request()
        interactor?.showSelectedFood(request: request)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.layer.cornerRadius = 10
        self.view.layer.masksToBounds = true
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        weightUnitButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        productionDateTextField.inputView = datePickerView
        expirationDateTextField.inputView = datePickerView
        consumeUpPickerView.delegate = self
        consumeUpPickerView.dataSource = self
        consumeUpTextField.inputView = consumeUpPickerView
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
        
        weightTextField.delegate = self
        productionDateTextField.delegate = self
        expirationDateTextField.delegate = self
        consumeUpTextField.delegate = self
        
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureRecognizer))
        view.addGestureRecognizer(panGestureRecognizer)
        view.addSubview(addButton)
        
//        guard let productionDateString = productionDateTextField.text else { return }
//        if !productionDateString.isEmpty {
//            expirationDateTextField.isEnabled = true
//            consumeUpTextField.isEnabled = true
//        }
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

        let request = AddFoodModel.AddFood.Request(weight: weightTextField.text,
                                                   unit: weightUnitButton.titleLabel?.text ?? "kg.".localized(),
                                                   prductionDate: productionDateTextField.text,
                                                   expirationDate: expirationDateTextField.text,
                                                   view: self.view
        )
        sender.showAnimation(for: .withoutColor) {
            self.interactor?.addSelectedFood(request: request)
        }
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

//MARK: - UIPickerViewDelegate

extension AddFoodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            let firstComponent = String(monthWheel[row]) + "m.".localized()
            return firstComponent
        } else {
            let secondComponent = String(daysWheel[row]) + "d.".localized()
            return secondComponent
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthWheel.count
        } else {
            return daysWheel.count
        }
    }
}

//MARK: - UIPopoverPresentationControllerDelegate

extension AddFoodViewController: UIPopoverPresentationControllerDelegate {
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

//MARK: - UITextFieldDelegate

extension AddFoodViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var request: AddFoodModel.DateUpdate.Request
        
        if textField == productionDateTextField {
            request = AddFoodModel.DateUpdate.Request(productionDate: textField.text,
                                                      expirationDate: expirationDateTextField.text,
                                                      consumeUpMonths: nil,
                                                      consumeUpDays: nil,
                                                      activeField: .productionDate,
                                                      datePickerDate: datePickerView.date
            )
            expirationDateTextField.isEnabled = true
            consumeUpTextField.isEnabled = true
        } else if textField == expirationDateTextField {
            request = AddFoodModel.DateUpdate.Request(productionDate: productionDateTextField.text,
                                                      expirationDate: textField.text,
                                                      consumeUpMonths: nil,
                                                      consumeUpDays: nil,
                                                      activeField: .expirationDate,
                                                      datePickerDate: datePickerView.date
            )
        } else if textField == consumeUpTextField {
            request = AddFoodModel.DateUpdate.Request(productionDate: productionDateTextField.text,
                                                      expirationDate: expirationDateTextField.text,
                                                      consumeUpMonths: consumeUpPickerView.selectedRow(inComponent: 0),
                                                      consumeUpDays: consumeUpPickerView.selectedRow(inComponent: 1),
                                                      activeField: .consumeUp,
                                                      datePickerDate: nil
            )
        } else {
            return
        }
        
        interactor?.updateDates(request: request)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var request: AddFoodModel.DatePickerValueUpdate.Request
        if textField == productionDateTextField {
            request = AddFoodModel.DatePickerValueUpdate.Request(activeField: .productionDate,
                                                                 productionDate: textField.text,
                                                                 expirationDate: nil,
                                                                 consumeUpDate: nil)
        } else if textField == expirationDateTextField {
            request = AddFoodModel.DatePickerValueUpdate.Request(activeField: .expirationDate,
                                                                 productionDate: productionDateTextField.text,
                                                                 expirationDate: textField.text,
                                                                 consumeUpDate: nil)
        } else if textField == consumeUpTextField {
            request = AddFoodModel.DatePickerValueUpdate.Request(activeField: .consumeUp,
                                                                 productionDate: productionDateTextField.text,
                                                                 expirationDate: expirationDateTextField.text,
                                                                 consumeUpDate: ConsumeUp(months: consumeUpPickerView.selectedRow(inComponent: 0),
                                                                                          days: consumeUpPickerView.selectedRow(inComponent: 1)))
        } else {
            return
        }
        interactor?.updatePickerValues(request: request)
    }
}

//MARK: - AddFoodDisplayLogic

extension AddFoodViewController: AddFoodDisplayLogic {
    
    func displayData(viewModel: AddFoodModel.ShowFood.ViewModel) {
        foodImageView.image = viewModel.displayedFood.image
        weightTextField.text = viewModel.displayedFood.weight
        productionDateTextField.text = viewModel.displayedFood.productionDate
        expirationDateTextField.text = viewModel.displayedFood.expirationDate
        consumeUpTextField.text = viewModel.displayedFood.consumeUp
        weightUnitButton.setTitle(viewModel.displayedFood.unit, for: .normal)
        if viewModel.displayedFood.productionDate != nil {
            expirationDateTextField.isEnabled = true
            consumeUpTextField.isEnabled = true
        }
    }
    
    func displayUpdatedDates(viewModel: AddFoodModel.DateUpdate.ViewModel) {
        if let productionDate = viewModel.productionDate {
            productionDateTextField.text = productionDate
        }
        
        if let expirationDate = viewModel.expirationDate {
            expirationDateTextField.text = expirationDate
        }
        
        if let consumeUpText = viewModel.consumeUpText {
            consumeUpTextField.text = consumeUpText
        }
    }
    
    func displayUpdatePickerValues(viewModel: AddFoodModel.DatePickerValueUpdate.ViewModel) {
        datePickerView.date = viewModel.displayedValues.pickerCurrentValue
        datePickerView.minimumDate = viewModel.displayedValues.pickerMinValue
        datePickerView.maximumDate = viewModel.displayedValues.pickerMaxValue
        consumeUpPickerView.selectRow(viewModel.displayedValues.currentMonthsPicker, inComponent: 0, animated: false)
        consumeUpPickerView.selectRow(viewModel.displayedValues.currentDaysPicker, inComponent: 1, animated: false)
    }
    
    func displayAlert(viewModel: AddFoodModel.AddFood.ViewModel) {
        if let alert = viewModel.alertController {
            self.present(alert, animated: true)
        } else {
            performCloseAnimation()
        }
    }
}
