//
//  AddAndChangeFoodView + Extension.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 07.10.2024.
//

import UIKit

extension AddFoodMenu {
    
    enum ChoiseMenuForShoppingList {
        case full
        case small
    }
    
    enum CheckRootViewContrller {
        case editFromMyFoodVC
        case addFromMyFoodVC
        case addFromShoppingListVC
        case addFromShoppingListVCtoMyfoodVC
        case editFromShoppingListVC
    }
    
    func getTopViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            var topController = window.rootViewController
            while let presentedViewController = topController?.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    func showMenu(size: ChoiseMenuForShoppingList?) {
        let selectedItem = getTopViewController() as? TabBarController
        let vc = selectedItem?.selectedViewController as? UINavigationController
        
        if vc?.viewControllers.count == 1 {
            if vc?.viewControllers.last is MyFoodViewController {
                showFullMenu()
                rootVC = .editFromMyFoodVC
                print("Edit food from MyFoodViewController (1.1)")
            } else if vc?.viewControllers.first is ShoppingListViewController  {
                guard let size else { return }
                if size == .full {
                    showFullMenu()
                    rootVC = .addFromShoppingListVCtoMyfoodVC
                    print("Add food from ShoppingListViewController for MyFoodViewController (1.3)")
                } else {
                    showSmallMenu()
                    rootVC = .editFromShoppingListVC
                    print("Edit food from ShoppingListViewController for ShoppingListViewController (2.2)")
                }
            }
        } else {
            if vc?.viewControllers.first is MyFoodViewController && vc?.viewControllers.last is ChoiseFoodViewController {
                showFullMenu()
                rootVC = .addFromMyFoodVC
                print("Add food from MyFoodViewController -> ChoiseFoodViewController for MyFoodViewController (1.2)")
            } else if vc?.viewControllers.first is ShoppingListViewController && vc?.viewControllers.last is ChoiseFoodViewController {
                showSmallMenu()
                rootVC = .addFromShoppingListVC
                print("Add food from ShoppingListViewController -> ChoiseFoodViewController for ShoppingListViewController (2.1)")
            }
        }
        
    }
    
    func isShoppingList() -> Bool {
        
        let tabBarController = getTopViewController() as? TabBarController
        let selectedItem = tabBarController?.selectedViewController as? UINavigationController
        
        if tabBarController?.tabBar.selectedItem?.title == "Shopping List" {
            if selectedItem?.viewControllers.last is ChoiseFoodViewController {
                return true
            }
        }
        return false
    }

    func checkUnit() {
        if food?.unit == "" {
            food?.unit = "kg.".localized()
        }
    }
    
    func checkWeightAndDuplicateTest() {
        guard let food = food else { return }
        
        if self.food?.weight == "0.0" {
            let weightAlertController = UIAlertController(title: "Enter the weight of the product".localized(),
                                                          message: nil,
                                                          preferredStyle: .alert)
            weightAlertController.addAction(UIAlertAction(title: "OK".localized(), style: .default))
            getTopViewController()?.present(weightAlertController, animated: true, completion: nil)
        } else {
            switch rootVC {
            case .addFromMyFoodVC:
                if !DataManager.shared.checkFoodListDuplicates(food: food) {
                    self.addFood()
                } else {
                    let changeFoodAlertController = UIAlertController(title: "You already have this product".localized(),
                                                                      message: "Do you want to replace it?".localized(),
                                                                      preferredStyle: .alert)
                    changeFoodAlertController.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { _ in
                        self.changeFood()
                    }))
                    changeFoodAlertController.addAction(UIAlertAction(title: "No".localized(), style: .cancel))
                    getTopViewController()?.present(changeFoodAlertController, animated: true, completion: nil)
                };
            case .editFromMyFoodVC:
                self.updateFood();
            case .addFromShoppingListVC:
                if !DataManager.shared.checkShoppingListDuplicate(food: food) {
                    self.addFood()
                } else {
                    let changeFoodAlertController = UIAlertController(title: "You already have this product".localized(),
                                                                      message: "Do you want to replace it?".localized(),
                                                                      preferredStyle: .alert)
                    changeFoodAlertController.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { _ in
                        self.food?.isShoppingList = true
                        self.changeFoodForShoppingList()
                    }))
                    changeFoodAlertController.addAction(UIAlertAction(title: "No".localized(), style: .cancel))
                    getTopViewController()?.present(changeFoodAlertController, animated: true, completion: nil)
                };
            case .editFromShoppingListVC:
                updateFoodForShoppingList();
            case .addFromShoppingListVCtoMyfoodVC:
                if !DataManager.shared.checkFoodListDuplicates(food: food) {
                    self.addFood()
                } else {
                    let changeFoodAlertController = UIAlertController(title: "You already have this product".localized(),
                                                                      message: "Do you want to replace it?".localized(),
                                                                      preferredStyle: .alert)
                    changeFoodAlertController.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { _ in
                        self.changeFood()
                    }))
                    changeFoodAlertController.addAction(UIAlertAction(title: "No".localized(), style: .cancel))
                    getTopViewController()?.present(changeFoodAlertController, animated: true, completion: nil)
                };
            default :
                break
            }
        }
    }
    
    func checkWeightAndDuplicate() {
        guard let food = food else { return }
        let selectedItem = getTopViewController() as? TabBarController
        let vc = selectedItem?.selectedViewController as? UINavigationController
        
        
        if self.food?.weight == "0.0" {
            let weightAlertController = UIAlertController(title: "Enter the weight of the product".localized(),
                                                          message: nil,
                                                          preferredStyle: .alert)
            weightAlertController.addAction(UIAlertAction(title: "OK".localized(), style: .default))
            getTopViewController()?.present(weightAlertController, animated: true, completion: nil)
        } else {
            if !DataManager.shared.checkFoodListDuplicates(food: food) {
                self.addFood()
            } else {
                if vc?.viewControllers.last is MyFoodViewController {
                    self.updateFood()
                }  else {
                    
                    if vc?.viewControllers.first is ShoppingListViewController {
                        print("Shopping List")
                    }
                    let changeFoodAlertController = UIAlertController(title: "You already have this product".localized(),
                                                                      message: "Do you want to replace it?".localized(),
                                                                      preferredStyle: .alert)
                    changeFoodAlertController.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { _ in
                        self.changeFood()
                    }))
                    changeFoodAlertController.addAction(UIAlertAction(title: "No".localized(), style: .cancel))
                    getTopViewController()?.present(changeFoodAlertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func setupTextFields() {
        weightLabel.text = "Weight:".localized()
        productionDateLabel.text = "Manufacturing Date:".localized()
        expirationDateLabel.text = "Expires on:".localized()
        consumeUpLabel.text = "Shelf Life:".localized()
        addFoodButton.setTitle("Add".localized(), for: .normal)
        var fontSize = productionDateLabel.font.pointSize
        
        while productionDateLabel.intrinsicContentSize.width > (self.frame.width / 2 - 20) {
            fontSize -= 1
            productionDateLabel.font = UIFont.systemFont(ofSize: fontSize)
        }
        weightLabel.font = UIFont.systemFont(ofSize: fontSize)
        expirationDateLabel.font = UIFont.systemFont(ofSize: fontSize)
        consumeUpLabel.font = UIFont.systemFont(ofSize: fontSize)
        weightTextField.font = UIFont.systemFont(ofSize: fontSize)
        productionDateTextField.font = UIFont.systemFont(ofSize: fontSize)
        expirationDateTextField.font = UIFont.systemFont(ofSize: fontSize)
        consumeUpTextField.font = UIFont.systemFont(ofSize: fontSize)
        popupMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        weightTextField.keyboardType = .decimalPad
        weightTextField.addDoneButtonToKeyboard()
        weightTextField.delegate = self
        productionDateTextField.inputView = datePicker
        productionDateTextField.addDoneButtonToKeyboard()
        productionDateTextField.delegate = self
        expirationDateTextField.inputView = datePicker
        expirationDateTextField.delegate = self
        expirationDateTextField.addDoneButtonToKeyboard()
        consumeUpTextField.addDoneButtonToKeyboard()
        consumeUpTextField.inputView = consumeUPPicker
        consumeUpTextField.delegate = self
        
        if food?.productionDate != nil {
            expirationDateTextField.isEnabled = true
            consumeUpTextField.isEnabled = true
        } else {
            expirationDateTextField.isEnabled = false
            consumeUpTextField.isEnabled = false
        }
    }
}

//MARK: - layoutForShoppingList

extension AddFoodMenu {
    
    func layoutForShoppingList() {
        productionDateTextField.isHidden = true
        productionDateLabel.isHidden = true
        expirationDateTextField.isHidden = true
        expirationDateLabel.isHidden = true
        consumeUpLabel.isHidden = true
        consumeUpTextField.isHidden = true
        
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        foodImageView.translatesAutoresizingMaskIntoConstraints = false
        addFoodButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            foodImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackViewContainer.heightAnchor.constraint(equalToConstant: 30),
            addFoodButton.topAnchor.constraint(equalTo: stackViewContainer.bottomAnchor, constant: 20),
            addFoodButton.heightAnchor.constraint(equalToConstant: 40),
            addFoodButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            addFoodButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            addFoodButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            foodImageView.bottomAnchor.constraint(equalTo: stackViewContainer.topAnchor, constant: -20)
        ])
    }
}
