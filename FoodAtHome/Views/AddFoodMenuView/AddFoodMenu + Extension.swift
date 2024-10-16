//
//  AddAndChangeFoodView + Extension.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 07.10.2024.
//

import UIKit

extension AddFoodMenu {
    
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
    
    func checkUnit() {
        if food?.unit == "" {
            food?.unit = "kg.".localized()
        }
    }
    
    func checkWeightAndDuplicate() {
        guard let food = food else { return }
        
        let vc = getTopViewController() as? UINavigationController
        
        if self.food?.weight == "0.0" {
            let weightAlertController = UIAlertController(title: "Enter the weight of the product".localized(),
                                                          message: nil,
                                                          preferredStyle: .alert)
            weightAlertController.addAction(UIAlertAction(title: "OK".localized(), style: .default))
            getTopViewController()?.present(weightAlertController, animated: true, completion: nil)
        } else {
            if !DataManager.shared.checkFoDuplicates(food: food) {
                self.addFood()
                self.closeAddFoodMenu()
                self.delegate?.didCloseAddFood()
            } else {
                if vc?.viewControllers.last is MyFoodViewController {
                    self.updateFood()
                    self.closeAddFoodMenu()
                    self.delegate?.didCloseAddFood()
                } else {
                    let changeFoodAlertController = UIAlertController(title: "You already have this product".localized(),
                                                                      message: "Do you want to replace it?".localized(),
                                                                      preferredStyle: .alert)
                    changeFoodAlertController.addAction(UIAlertAction(title: "Yes".localized(), style: .destructive, handler: { _ in
                        self.changeFood()
                        self.closeAddFoodMenu()
                        self.delegate?.didCloseAddFood()
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
        expirationDateTextField.isEnabled = false
        consumeUpTextField.isEnabled = false
        consumeUpTextField.inputView = consumeUPPicker
        consumeUpTextField.delegate = self
    }
}
