//
//  AddAndChangeFoodView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.07.2023.
//

import UIKit
import RealmSwift

protocol AddAndChangeFoodDelegate: AnyObject {
    func didAddNewFood(_ food: FoodRealm)
}

class AddAndChangeFoodView: UIView {
    
    weak var delegate: AddAndChangeFoodDelegate!
    
    let localRealm = try! Realm()
    var foodItem = FoodRealm()
    
    let currentDate = Date()
    
    private let blurAlpha: CGFloat = 1
    private var blurView: UIVisualEffectView!
    private var addView: UIView!
    private var imageView: UIImageView!
    private var closeButton: UIButton!
    private var addButton: UIButton!
    
    private var weightLabel: UILabel!
    private var dateOfManufactureLabel: UILabel!
    private var sellByLabel: UILabel!
    private var leftLabel: UILabel!
    
    private var labelsStackView: UIStackView!
    private var optionsStackView: UIStackView!
    private var mainStackView: UIStackView!
    private var weightOptionsStack: UIStackView!
    
    private var weightTextField: UITextField!
    private var weightTypePickerView: UIPickerView!
    private var dateOfManufactureTextField: UITextField!
    private var sellByTextField: UITextField!
    private var leftTextField: UITextField!
    
    private var datePickerView: UIDatePicker!
    private var leftDaysPickerView: UIPickerView!
    
    func sohowAddAndChangeFoodView(for viewController: UIViewController) {
        guard let view = viewController.tabBarController?.view else { return }
        guard let viewControllerPickerDelegate = viewController as? UIPickerViewDelegate else { return }
        guard let viewControllerFoodDelegate = viewController as? AddAndChangeFoodDelegate else { return }
        
        self.delegate = viewControllerFoodDelegate
        setupUI(for: view)
        setuoConstraints()
        
        weightTypePickerView.delegate = viewControllerPickerDelegate
        leftDaysPickerView.delegate = viewControllerPickerDelegate
        
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = self.blurAlpha
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.addView.center = view.center
                }
            }
        }
    }
}

//MARK: - SetupUI

extension AddAndChangeFoodView {
    private func setupUI(for view: UIView) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        addView = UIView(frame: CGRect(x: 25, y: -900, width: view.frame.width - 50, height: view.frame.height / 1.4))
        addView.backgroundColor = .white
        addView.layer.cornerRadius = 10
        view.addSubview(addView)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        addView.addSubview(imageView)
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        closeButton.tintColor = .systemGray
        addView.addSubview(closeButton)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 10
        addButton.setTitle("Добавить", for: .normal)
        addButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , for: .normal)
        addButton.backgroundColor = .purple
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addView.addSubview(addButton)
        
        
        mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.distribution = .fillEqually
        addView.addSubview(mainStackView)
        
        labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .fillEqually
        mainStackView.addArrangedSubview(labelsStackView)
        
        optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.distribution = .fillEqually
        optionsStackView.contentMode = .center
        mainStackView.addArrangedSubview(optionsStackView)
        
        weightOptionsStack = UIStackView()
        weightOptionsStack.axis = .horizontal
        weightOptionsStack.distribution = .fillEqually
        optionsStackView.addArrangedSubview(weightOptionsStack)
        
        weightLabel = UILabel()
        setupLabels(label: weightLabel, stack: labelsStackView)
        dateOfManufactureLabel = UILabel()
        setupLabels(label: dateOfManufactureLabel, stack: labelsStackView)
        sellByLabel = UILabel()
        setupLabels(label: sellByLabel, stack: labelsStackView)
        leftLabel = UILabel()
        setupLabels(label: leftLabel, stack: labelsStackView)
        
        weightTextField = UITextField()
        weightTextField.keyboardType = .decimalPad
        weightTextField.placeholder = "0.0"
        setupTextField(textField: weightTextField, stack: weightOptionsStack)
        weightTypePickerView = UIPickerView()
        weightTypePickerView.tag = 0
        weightOptionsStack.addArrangedSubview(weightTypePickerView)
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        dateOfManufactureTextField = UITextField()
        dateOfManufactureTextField.inputView = datePickerView
        setupTextField(textField: dateOfManufactureTextField, stack: optionsStackView)
        sellByTextField = UITextField()
        setupTextField(textField: sellByTextField, stack: optionsStackView)
        sellByTextField.inputView = datePickerView
        leftTextField = UITextField()
        setupTextField(textField: leftTextField, stack: optionsStackView)
        leftDaysPickerView = UIPickerView()
        leftDaysPickerView.tag = 1
        leftTextField.inputView = leftDaysPickerView
    }
    
    private func setuoConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: addView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: addView.frame.width / 2),
            imageView.heightAnchor.constraint(equalToConstant: addView.frame.width / 2),
            
            closeButton.topAnchor.constraint(equalTo: addView.topAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -5),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            addButton.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -20),
            addButton.centerXAnchor.constraint(equalTo: addView.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: addView.frame.width / 1.5),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            mainStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -120),
        ])
    }
    
    func configure(food: FoodRealm) {
        imageView.image = UIImage(named: food.name)
        weightLabel.text = "Вес:              "
        dateOfManufactureLabel.text = "Дата изготовления:"
        sellByLabel.text = "Годен до:         "
        leftLabel.text = "Срок годности:    "
        weightTextField.text = food.weight
        dateOfManufactureTextField.text = DateManager.shared.dateFromString(with: food.productionDate)
        sellByTextField.text = DateManager.shared.dateFromString(with: food.expirationDate)
        leftTextField.text = DateManager.shared.intervalDate(from: food.productionDate, to: food.expirationDate, type: .experation)
        foodItem.name = food.name
        foodItem.type = food.type
        foodItem.weight = food.weight
        foodItem.productionDate = food.productionDate
        foodItem.expirationDate = food.expirationDate
    }
    
    private func closedView() {
        UIView.animate(withDuration: 0.3) {
            self.addView.layer.position.y = -900
        } completion: { done in
            if done {
                self.blurView.alpha = 0
                self.blurView.removeFromSuperview()
                self.addView.removeFromSuperview()
            }
        }
    }
    
}

//MARK: - Setup Action

extension AddAndChangeFoodView {
    
    @objc private func exitButtonTapped() {
        closedView()
    }
    
    @objc private func addButtonTapped() {
        foodItem.unit = pickerArray[weightTypePickerView.selectedRow(inComponent: 0)]
        
        delegate.didAddNewFood(foodItem)
        closedView()
        
        foodItem = FoodRealm()
        
    }
}

//MARK: - TexField Delegate

extension AddAndChangeFoodView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let date = DateManager.shared.dateFromString(with: datePickerView.date)
        
        if textField == dateOfManufactureTextField || textField == sellByTextField {
            textField.text = date
            
            leftTextField.text = DateManager.shared.intervalDate(
                from: DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? "-"),
                to: DateManager.shared.stringFromDate(with: sellByTextField.text ?? "-"), type: .experation)
            
        } else if textField == leftTextField {
            
            let month = leftDaysPickerView.selectedRow(inComponent: 0)
            let days = leftDaysPickerView.selectedRow(inComponent: 1)
            leftTextField.text = monthsInterval[month] + "м." + " " + daysInterval[days] + "д."
            sellByTextField.text = DateManager.shared.dateFromString(
                with: DateManager.shared.sellByDate(productedByDate: DateManager.shared.stringFromDate(
                    with: dateOfManufactureTextField.text ?? "-"),
                                                    months: month,
                                                    days: days))
        }
        
        foodItem.weight = weightTextField.text ?? "-"
        foodItem.productionDate = DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? "-")
        foodItem.expirationDate = DateManager.shared.stringFromDate(with: sellByTextField.text ?? "-")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let update = DateManager.shared.stringFromDate(with: textField.text) else { return }
        if textField == dateOfManufactureTextField || textField == sellByTextField {

            datePickerView.date = update
        }

        if textField == dateOfManufactureTextField {
            datePickerView.maximumDate = currentDate
            datePickerView.minimumDate = nil
        } else if textField == sellByTextField {
            datePickerView.maximumDate = nil
            datePickerView.minimumDate = currentDate
        }

    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let dateOfManufacture = DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? "-")
        let sellBy = DateManager.shared.stringFromDate(with: sellByTextField.text ?? "-")
        let days = DateManager.shared.pickerRows(from: dateOfManufacture, to: sellBy, daysOrMonths: .days)
        let months = DateManager.shared.pickerRows(from: dateOfManufacture, to: sellBy, daysOrMonths: .months)
        
        leftDaysPickerView.selectRow(months ?? 0, inComponent: 0, animated: false)
        leftDaysPickerView.selectRow(days ?? 0, inComponent: 1, animated: false)
        
        foodItem.productionDate = DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? "-")
        foodItem.expirationDate = DateManager.shared.stringFromDate(with: sellByTextField.text ?? "-")
    }
}

//MARK: - Support Methods

extension AddAndChangeFoodView {
    private func setupLabels(label: UILabel, stack: UIStackView) {
        label.font = UIFont(name: "Inter-Light", size: 15)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        stack.addArrangedSubview(label)
    }
    
    private func setupTextField(textField: UITextField, stack: UIStackView) {
        textField.layer.cornerRadius = 8
        textField.addDoneButtonToKeyboard(myAction: #selector(textField.resignFirstResponder))
        textField.backgroundColor = .systemGray6
        textField.tintColor = .black
        textField.textAlignment = .center
        textField.delegate = self
        stack.addArrangedSubview(textField)
    }
}
