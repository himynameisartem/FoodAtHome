//
//  AlertView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 30.05.2022.
//

import UIKit

class AlertView {
    
    //MARK: - Constants
    
    struct Constants {
        static let blurAlpha: CGFloat = 1
    }
    
    var targetVC = UIViewController()
    var newFood: Food?
    var unit = String()
    var unitButton = UIPickerView()
    var weightLabel = UILabel()
    
    //MARK: Blur View
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: .dark)
        view.effect = blurEffect
        view.alpha = 0
        return view
    }()
    
    //MARK: Alert View
    
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    //MARK: Image View
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    //MARK: Tap Gesture Recognizer
    
    let tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()
    
    let backgroundTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()
    
    @objc func tapped() {
        weightTextField.resignFirstResponder()
    }
    
    //MARK: Weight TF
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "0.0"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    
    
    //MARK: - Show Alert
    
    func showAlert(viewController: UIViewController, image: UIImage, food: Food, picker: UIPickerView, unit: String) {
        
        guard let targetView = viewController.view else { return }
        blurView.frame = targetView.bounds
        targetView.addSubview(blurView)
        viewController.navigationItem.hidesBackButton = true
        viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        newFood = food
        targetVC = viewController
        
        alertView.frame = CGRect(x: 25, y: -900, width: targetView.frame.width - 50, height: targetView.frame.height / 1.5)
        targetView.addSubview(alertView)
        
        imageView.image = image
        alertView.addSubview(imageView)
        
        let exitButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.alpha = 0.6
            button.layer.cornerRadius = 20
            button.setImage(UIImage(systemName: "multiply"), for: .normal)
            button.scalesLargeContentImage = true
            button.tintColor = .black
            return button
        }()
        
        alertView.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        let addButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 10
            button.setTitle("Добавить", for: .normal)
            button.backgroundColor = UIColor(cgColor: CGColor(red: 236 / 255, green: 153 / 255, blue: 75 / 255, alpha: 1))
            return button
        }()
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        alertView.addSubview(addButton)
        
        let weightTitle: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Вес:"
            return label
        }()
        
        alertView.addSubview(weightTitle)
        weightLabel = weightTitle
        
        alertView.addSubview(weightTextField)
        newFood?.weight = weightTextField.text!
        
        unitButton = picker
        alertView.addSubview(unitButton)
        
        tap.addTarget(self, action: #selector(tapped))
        backgroundTap.addTarget(self, action: #selector(tapped))
        blurView.addGestureRecognizer(backgroundTap)
        alertView.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            exitButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            exitButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            exitButton.heightAnchor.constraint(equalToConstant: 40),
            exitButton.widthAnchor.constraint(equalToConstant: 40),
            
            addButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            addButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 50),
            addButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -50),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            weightTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            weightTitle.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            
            unitButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -40),
            unitButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            unitButton.widthAnchor.constraint(equalToConstant: 80),
            unitButton.heightAnchor.constraint(equalToConstant: 140),
            
            weightTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: unitButton.leadingAnchor, constant: 20),
            weightTextField.widthAnchor.constraint(equalToConstant: 80)
            
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = Constants.blurAlpha
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = targetView.center
                }
            }
        }
    }
    
    //MARK: Exit Button
    
    @objc func exitButtonTapped() {
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 25, y: -900, width: self.targetVC.view.frame.width - 50, height: self.targetVC.view.frame.height / 1.5)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.blurView.alpha = 0
                } completion: { done in
                    if done {
                        self.weightTextField.text = ""
                        self.unitButton.selectedRow(inComponent: 0)
                        self.targetVC.navigationItem.hidesBackButton = false
                        self.blurView.removeFromSuperview()
                        self.alertView.removeFromSuperview()
                        self.imageView.removeFromSuperview()
                        self.weightTextField.removeFromSuperview()
                        self.unitButton.removeFromSuperview()
                        self.weightLabel.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    //MARK: Add Button
    
    @objc func addButtonTapped() {
        
        if weightTextField.text != "" && !weightTextField.text!.isEmpty {
            newFood?.weight = weightTextField.text!
            if unit.isEmpty {
                unit = "кг."
            }
            newFood?.unit = unit
            test.append(newFood!)
            UIView.animate(withDuration: 0.3) {
                self.alertView.frame = CGRect(x: 25, y: 900, width: self.targetVC.view.frame.width - 50, height: self.targetVC.view.frame.height / 1.5)
            } completion: { done in
                if done {
                    UIView.animate(withDuration: 0.3) {
                        self.blurView.alpha = 0
                        self.targetVC.navigationController?.popToRootViewController(animated: true)
                    } completion: { done in
                        if done {
                            self.blurView.removeFromSuperview()
                            self.alertView.removeFromSuperview()
                            self.imageView.removeFromSuperview()
                            self.weightTextField.removeFromSuperview()
                            self.unitButton.removeFromSuperview()
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Введите вес продукта", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            targetVC.present(alert, animated: true)
        }
    }
}

//MARK: - Extension TF

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        done.tintColor = .black
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
