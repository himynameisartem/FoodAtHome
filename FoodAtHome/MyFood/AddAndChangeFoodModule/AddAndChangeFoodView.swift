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

protocol AddAndChangeClosedViewDelegate: AnyObject {
    func didRequestToclosedView()
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
    private var weaightTypeView: UIView!
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
        setupConstraints()
        
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
        
        addView = UIView(frame: CGRect(x: 25, y: -900, width: view.frame.width - 40, height: view.frame.width * 1.4))
        addView.backgroundColor = .white
        addView.layer.cornerRadius = 10
        view.addSubview(addView)
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        addButton.setTitle("Add".localized(), for: .normal)
        addButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , for: .normal)
        addButton.backgroundColor = .addButtonSelectColor
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addView.addSubview(addButton)
        
        
        mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 10
        addView.addSubview(mainStackView)
        
        labelsStackView = UIStackView()
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .fillEqually
        labelsStackView.spacing = 20
        mainStackView.addArrangedSubview(labelsStackView)
        
        optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.distribution = .fillEqually
        optionsStackView.spacing = 20
        mainStackView.addArrangedSubview(optionsStackView)
        
        weightOptionsStack = UIStackView()
        weightOptionsStack.axis = .horizontal
        weightOptionsStack.spacing = 10
        optionsStackView.addArrangedSubview(weightOptionsStack)
        
        weightLabel = UILabel()
        dateOfManufactureLabel = UILabel()
        sellByLabel = UILabel()
        leftLabel = UILabel()
        
        
        let labels = [weightLabel, dateOfManufactureLabel, sellByLabel, leftLabel]
        for label in labels {
            guard let label = label else { return }
            label.font = UIFont(name: "Inter-Light", size: 15)
            label.minimumScaleFactor = 0.5
            label.adjustsFontSizeToFitWidth = true
            labelsStackView.addArrangedSubview(label)
        }
        
        weightTextField = UITextField()
        weightTextField.keyboardType = .decimalPad
        weightTextField.placeholder = "0.0"
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        dateOfManufactureTextField = UITextField()
        dateOfManufactureTextField.placeholder = "-"
        dateOfManufactureTextField.inputView = datePickerView
        sellByTextField = UITextField()
        sellByTextField.placeholder = "-"
        sellByTextField.inputView = datePickerView
        leftTextField = UITextField()
        leftTextField.placeholder = "-"
        
        let textFields = [weightTextField, dateOfManufactureTextField, sellByTextField, leftTextField]
        for textField in textFields {
            guard let textField = textField else { return }
            textField.layer.cornerRadius = 8
            textField.addDoneButtonToKeyboard(myAction: #selector(textField.resignFirstResponder))
            textField.backgroundColor = .systemGray6
            textField.tintColor = .black
            textField.textAlignment = .center
            textField.delegate = self
            if textField == weightTextField {
                weightOptionsStack.addArrangedSubview(textField)
            } else {
                optionsStackView.addArrangedSubview(textField)
            }
        }
        
        weaightTypeView = UIView()
        weaightTypeView.backgroundColor = .systemGray6
        weaightTypeView.layer.cornerRadius = 8
        weaightTypeView.translatesAutoresizingMaskIntoConstraints = false
        
        weightTypePickerView = UIPickerView()
        weightTypePickerView.tag = 0
        weightTypePickerView.translatesAutoresizingMaskIntoConstraints = false
        weightOptionsStack.addArrangedSubview(weaightTypeView)
        weaightTypeView.addSubview(weightTypePickerView)
        
        leftDaysPickerView = UIPickerView()
        leftDaysPickerView.tag = 1
        leftTextField.inputView = leftDaysPickerView
    
        if dateOfManufactureTextField.text == "" {
            leftTextField.isEnabled = false
        }
    }
    
    private func setupConstraints() {
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
            addButton.widthAnchor.constraint(equalToConstant: addView.frame.width / 1.6),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            
            weightTextField.leadingAnchor.constraint(equalTo: weightOptionsStack.leadingAnchor),
            weightTextField.topAnchor.constraint(equalTo: weightOptionsStack.topAnchor),
            weightTextField.bottomAnchor.constraint(equalTo: weightOptionsStack.bottomAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: addView.frame.width / 6),
            
            weaightTypeView.trailingAnchor.constraint(equalTo: weightOptionsStack.trailingAnchor),
            weaightTypeView.topAnchor.constraint(equalTo: weightOptionsStack.topAnchor),
            weaightTypeView.bottomAnchor.constraint(equalTo: weightOptionsStack.bottomAnchor),
            
            weightTypePickerView.topAnchor.constraint(equalTo: weaightTypeView.topAnchor, constant: -20),
            weightTypePickerView.leadingAnchor.constraint(equalTo: weaightTypeView.leadingAnchor),
            weightTypePickerView.trailingAnchor.constraint(equalTo: weaightTypeView.trailingAnchor),
            weightTypePickerView.bottomAnchor.constraint(equalTo: weaightTypeView.bottomAnchor, constant: 20),
            
            mainStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: addView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: addView.trailingAnchor, constant: -20),
            mainStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 210),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor, constant: -20),
        ])
    }
    
    func configure(food: FoodRealm) {
        imageView.image = UIImage(named: food.name)
        weightLabel.text = "Weight:                        ".localized()
        dateOfManufactureLabel.text = "Manufacturing Date:".localized()
        sellByLabel.text = "Expires on:                ".localized()
        leftLabel.text = "Shelf Life:                ".localized()
        if food.weight != "0.0" {
            weightTextField.text = food.weight
        }
        dateOfManufactureTextField.text = DateManager.shared.dateFromString(with: food.productionDate)
        sellByTextField.text = DateManager.shared.dateFromString(with: food.expirationDate)
        leftTextField.text = DateManager.shared.intervalDate(from: food.productionDate, to: food.expirationDate, type: .experation)
        foodItem.name = food.name
        foodItem.type = food.type
        foodItem.weight = food.weight
        foodItem.productionDate = food.productionDate
        foodItem.expirationDate = food.expirationDate
    }
    
     func closedView() {
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
    
    @objc private func exitButtonTapped(sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
            self.closedView()
        }
    }
    
    @objc private func addButtonTapped(sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
            self.foodItem.unit = pickerArray[self.weightTypePickerView.selectedRow(inComponent: 0)]
            self.delegate.didAddNewFood(self.foodItem)
            
            if FoodManager.shared.menuStatus == .didClosedMenu {
                self.closedView()
                self.foodItem = FoodRealm()
            }
        }
    }
}

//MARK: - TexField Delegate

extension AddAndChangeFoodView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let date = DateManager.shared.dateFromString(with: datePickerView.date)
        
        if textField == dateOfManufactureTextField || textField == sellByTextField {
            textField.text = date
            
            if dateOfManufactureTextField.text != "" {
                leftTextField.isEnabled = true
            }
            
            leftTextField.text = DateManager.shared.intervalDate(
                from: DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? ""),
                to: DateManager.shared.stringFromDate(with: sellByTextField.text ?? ""), type: .experation)
            
        } else if textField == leftTextField {
            
            let month = leftDaysPickerView.selectedRow(inComponent: 0)
            let days = leftDaysPickerView.selectedRow(inComponent: 1)
            leftTextField.text = monthsInterval[month] + "m".localized() + "." + " " + daysInterval[days] + "d".localized() + "."
            sellByTextField.text = DateManager.shared.dateFromString(
                with: DateManager.shared.sellByDate(productedByDate: DateManager.shared.stringFromDate(
                    with: dateOfManufactureTextField.text ?? ""),
                                                    months: month,
                                                    days: days))
        }
        
        foodItem.weight = weightTextField.text ?? ""
        foodItem.productionDate = DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? "")
        foodItem.expirationDate = DateManager.shared.stringFromDate(with: sellByTextField.text ?? "")
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
        let dateOfManufacture = DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? "")
        let sellBy = DateManager.shared.stringFromDate(with: sellByTextField.text ?? "")
        let days = DateManager.shared.pickerRows(from: dateOfManufacture, to: sellBy, daysOrMonths: .days)
        let months = DateManager.shared.pickerRows(from: dateOfManufacture, to: sellBy, daysOrMonths: .months)
        
        leftDaysPickerView.selectRow(months ?? 0, inComponent: 0, animated: false)
        leftDaysPickerView.selectRow(days ?? 0, inComponent: 1, animated: false)
        
        foodItem.productionDate = DateManager.shared.stringFromDate(with: dateOfManufactureTextField.text ?? "")
        foodItem.expirationDate = DateManager.shared.stringFromDate(with: sellByTextField.text ?? "")
    }
}

extension AddAndChangeFoodView: AddAndChangeClosedViewDelegate {
    func didRequestToclosedView() {
        closedView()
    }
}
