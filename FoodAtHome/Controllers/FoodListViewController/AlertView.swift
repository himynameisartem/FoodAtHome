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
    
    var dateInterval = Date()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    let weightTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вес:"
        return label
    }()
    
    let productionDateTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Дата изготовления:"
        label.contentMode = .center
        return label
    }()
    
    let expirationDateTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Годен до:"
        label.contentMode = .center
        return label
    }()
    
    let consumeUpTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Срок годности:"
        label.contentMode = .center
        return label
    }()
    
    var productText = ""
    var targetVC = UIViewController()
    var newFood: Food?
    var unit = String()
    var months = String()
    var day = String()
    var unitButton = UIPickerView()
    var productionDate = Date()
    
    var currentWeight = String()
    var currenProductDate: Date?
    var currentExperationDate: Date?
    var currentConsumeDate: Date?
    
    //MARK: Blur View
    
     let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: .dark)
        view.effect = blurEffect
        view.alpha = 0
        return view
    }()
    
    //MARK: Alert View
    
    
     let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    //MARK: Image View
    
     let imageView: UIImageView = {
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
        productionDateTF.resignFirstResponder()
    }
    
    //MARK: Weight TF
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.addDoneButtonToKeyboard(myAction:  #selector(textField.resignFirstResponder))
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "0.0"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    //MARK: Production Date TF
    
    let productionDateTF: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.placeholder = "дд/мм/гггг"
        return textField
    }()
    
    //MARK: Expiration Date TF
    
    let expirationDateTF: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.placeholder = "дд/мм/гггг"
        textField.isEnabled = false
        textField.alpha = 0.2
        return textField
    }()
    
    //MARK: Сonsume Date TF
    
    let consumeDateTF: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.placeholder = "0м. 0д."
        textField.isEnabled = false
        textField.alpha = 0.2
        return textField
    }()
    
    //MARK: Production Date Picker
    
    let productionDatePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .wheels
        return date
    }()
    
    //MARK: Expiration Date Picker
    
    let expirationDatePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.preferredDatePickerStyle = .wheels
        date.isEnabled = false
        return date
    }()
    var daysInterval = DateComponents()
    let currentDate = Date()
    
    var search = UISearchController()
    
    //MARK: - Show Alert
    
    func showAlert(viewController: UIViewController, image: UIImage, food: Food, picker: UIPickerView, consumePicker: UIPickerView, unit: String, currentWeigt: String?, currentProductDate: Date?, currentExperationDate: Date?, searchController: UISearchController?) {
        
        guard let targetView = viewController.view else { return }
        blurView.frame = targetView.bounds
        targetView.addSubview(blurView)
        viewController.navigationItem.hidesBackButton = true
        viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        if searchController != nil {
            search = searchController!
            search.searchBar.isHidden = true
        }
        
        weightTextField.text = currentWeigt == "0.0" ? "" : currentWeigt
        productionDateTF.text = currentProductDate != nil ? formatter.string(from: currentProductDate!) : ""
        expirationDateTF.text = currentExperationDate != nil ? formatter.string(from: currentExperationDate!) : ""
        
        if currentProductDate != nil {
            if  let toDate = currentExperationDate {
                daysInterval = Calendar.current.dateComponents([.month, .day], from: currentProductDate!, to: toDate)
                consumeDateTF.text = "\(daysInterval.month ?? 0) мес. и \(daysInterval.day ?? 0) д."
            }
        }
        
        
        if currentProductDate != nil {
            expirationDateTF.isEnabled = true
            expirationDateTF.alpha = 1
            consumeDateTF.isEnabled = true
            consumeDateTF.alpha = 1
        }
        
        newFood = food
        targetVC = viewController
        
        let height = targetView.frame.height
        
        alertView.frame = CGRect(x: 25, y: -900, width: targetView.frame.width - 50, height:
                                    height < 668 ? height / 1.3 : height / 1.7)
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
            button.backgroundColor = .addButtonSelectColor
            return button
        }()
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        alertView.addSubview(addButton)
        
        alertView.addSubview(weightTitle)
        alertView.addSubview(productionDateTitle)
        alertView.addSubview(weightTextField)
        alertView.addSubview(expirationDateTitle)
        alertView.addSubview(consumeUpTitle)
        alertView.addSubview(productionDateTF)
        alertView.addSubview(expirationDateTF)
        alertView.addSubview(consumeDateTF)
        
        newFood?.weight = weightTextField.text!
        
        unitButton = picker
        alertView.addSubview(unitButton)
        
        let maxProductionDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        let productionToolBar = UIToolbar()
        productionToolBar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let productionDoneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(productionDoneAction))
        productionDoneButton.tintColor = .black
        productionToolBar.setItems([flexSpace, productionDoneButton], animated: true)
        productionDatePicker.maximumDate = maxProductionDate
        productionDateTF.inputAccessoryView = productionToolBar
        productionDatePicker.addTarget(self, action: #selector(productionDateChanged), for: .valueChanged)
        productionDateTF.inputView = productionDatePicker
        
        let expirationToolBar = UIToolbar()
        expirationToolBar.sizeToFit()
        let expirationDoneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(expirationDoneAction))
        expirationDoneButton.tintColor = .black
        expirationToolBar.setItems([flexSpace, expirationDoneButton], animated: true)
        expirationDateTF.inputAccessoryView = expirationToolBar
        expirationDatePicker.addTarget(self, action: #selector(expirationDateChanged), for: .valueChanged)
        expirationDateTF.inputView = expirationDatePicker
        
        let consumeToolBar = UIToolbar()
        consumeToolBar.sizeToFit()
        let consumeDoneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(consumeDoneAction))
        consumeDoneButton.tintColor = .black
        consumeToolBar.setItems([flexSpace, consumeDoneButton], animated: true)
        consumeDateTF.inputAccessoryView = consumeToolBar
        consumeDateTF.inputView = consumePicker
        
        tap.addTarget(self, action: #selector(tapped))
        backgroundTap.addTarget(self, action: #selector(tapped))
        blurView.addGestureRecognizer(backgroundTap)
        alertView.addGestureRecognizer(tap)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: height == 568 ? 140 : height == 667 ? 180 : 200),
            
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
            
            productionDateTitle.topAnchor.constraint(equalTo: weightTitle.bottomAnchor, constant: 30),
            productionDateTitle.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            
            expirationDateTitle.topAnchor.constraint(equalTo: productionDateTitle.bottomAnchor, constant: 30),
            expirationDateTitle.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            
            consumeUpTitle.topAnchor.constraint(equalTo: expirationDateTitle.bottomAnchor, constant: 30),
            consumeUpTitle.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            
            unitButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            unitButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            unitButton.widthAnchor.constraint(equalToConstant: 80),
            unitButton.heightAnchor.constraint(equalToConstant: 80),
            
            weightTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18),
            weightTextField.trailingAnchor.constraint(equalTo: unitButton.leadingAnchor, constant: -10),
            weightTextField.widthAnchor.constraint(equalToConstant: 40),
            weightTextField.heightAnchor.constraint(equalToConstant: 25),
            
            productionDateTF.topAnchor.constraint(equalTo: weightTitle.bottomAnchor, constant: 28),
            productionDateTF.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            productionDateTF.widthAnchor.constraint(equalToConstant: 120),
            productionDateTF.heightAnchor.constraint(equalToConstant: 25),
            
            expirationDateTF.topAnchor.constraint(equalTo: productionDateTitle.bottomAnchor, constant: 28),
            expirationDateTF.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            expirationDateTF.widthAnchor.constraint(equalToConstant: 120),
            expirationDateTF.heightAnchor.constraint(equalToConstant: 25),
            
            consumeDateTF.topAnchor.constraint(equalTo: expirationDateTF.bottomAnchor, constant: 28),
            consumeDateTF.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            consumeDateTF.widthAnchor.constraint(equalToConstant: 120),
            consumeDateTF.heightAnchor.constraint(equalToConstant: 25),
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
                        
                        self.search.searchBar.isHidden = false
                        self.search.searchBar.text = ""
                        
                        self.weightTextField.text = ""
                        self.productionDateTF.text = ""
                        self.expirationDateTF.text = ""
                        self.consumeDateTF.text = ""
                        
                        self.alertView.removeFromSuperview()
                        self.unitButton.selectedRow(inComponent: 0)
                        self.targetVC.navigationItem.hidesBackButton = false
                        self.blurView.removeFromSuperview()
                        self.imageView.removeFromSuperview()
                        self.weightTextField.removeFromSuperview()
                        self.unitButton.removeFromSuperview()
                        self.weightTitle.removeFromSuperview()
                        
                    }
                }
            }
        }
    }
    
    //MARK: Add Button
    
    @objc func addButtonTapped() {
        
        if weightTextField.text != "" && !weightTextField.text!.isEmpty {
            
            if productionDateTF.text != ""{
                newFood?.productionDate = formatter.date(from: productionDateTF.text!)
            }
            
            if expirationDateTF.text != ""{
                newFood?.expirationDate = formatter.date(from: expirationDateTF.text!)
            }
            
            newFood?.weight = weightTextField.text!
            
            if unit.isEmpty {
                unit = "кг."
            }
            newFood?.unit = unit
            
            if !test.isEmpty {
                var check = false
                for i in test {
                    if newFood?.name == i.name {
                        check = true
                    }
                }
                if check == false {
                    test.append(newFood!)
                }
                
            } else {
                test.append(self.newFood!)
            }
            
            
            
            UIView.animate(withDuration: 0.3) {
                self.alertView.frame = CGRect(x: 25, y: 900, width: self.targetVC.view.frame.width - 50, height: self.targetVC.view.frame.height / 1.5)
            } completion: { done in
                if done {
                    UIView.animate(withDuration: 0.3) {
                        self.blurView.alpha = 0
                        self.targetVC.navigationController?.popToRootViewController(animated: true)
                    } completion: { done in
                        if done {
                            self.weightTextField.text = ""
                            self.productionDateTF.text = ""
                            self.expirationDateTF.text = ""
                            self.consumeDateTF.text = ""
                            self.unitButton.selectedRow(inComponent: 0)
                            self.targetVC.navigationItem.hidesBackButton = false
                            self.blurView.removeFromSuperview()
                            self.alertView.removeFromSuperview()
                            self.imageView.removeFromSuperview()
                            self.weightTextField.removeFromSuperview()
                            self.unitButton.removeFromSuperview()
                            self.weightTitle.removeFromSuperview()
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

extension AlertView {
    
    func height(_ height: UIViewController) -> CGFloat {
        
        var imgHeight = CGFloat()
        
        switch height.view.frame.height {
        case 568 : imgHeight = 140
        case 667 : imgHeight =  180
        default:
            imgHeight = 200
        }
        return imgHeight
    }
}

//MARK: - Make Date

extension AlertView {
    
    @objc func productionDoneAction(_ tf: UITextField) {
        getProductionDateFromPicker()
        targetVC.view.endEditing(true)
    }
    
    @objc func productionDateChanged() {
        getProductionDateFromPicker()
    }
    
    func getProductionDateFromPicker() {
        expirationDatePicker.isEnabled = true
        expirationDateTF.isEnabled = true
        expirationDateTF.alpha = 1
        consumeDateTF.isEnabled = true
        consumeDateTF.alpha = 1
        productionDateTF.text = formatter.string(from: productionDatePicker.date)
        productText = productionDateTF.text!
        productionDate = productionDatePicker.date
    }
    
    @objc func expirationDoneAction() {
        getExpirationDateFromPicker()
        targetVC.view.endEditing(true)
    }
    
    @objc func expirationDateChanged() {
        getExpirationDateFromPicker()
    }
    
    func getExpirationDateFromPicker() {
        expirationDatePicker.minimumDate = productionDate
        if productText != "" {
            expirationDateTF.text = formatter.string(from: expirationDatePicker.date)
            
            let daysAndMonthInterval = Calendar.current.dateComponents([.day, .month], from: productionDate, to: expirationDatePicker.date)
            let daysInterval = daysAndMonthInterval.day ?? 0
            let monthInterval = daysAndMonthInterval.month ?? 0
            day = String(daysInterval)
            months = String(monthInterval)
            
            if (day.isEmpty || day == "0") && (months.isEmpty || months == "0") {
                consumeDateTF.text = .none
            } else if months.isEmpty || months == "0" {
                consumeDateTF.text = day + "д"
            } else if day.isEmpty || day == "0" {
                consumeDateTF.text = months + "м"
            }  else {
                consumeDateTF.text = months + "м" + "  " + day + "д"
            }
        }
    }
    
    @objc func consumeDoneAction() {
        
        var interval = Date()
        
        if (day.isEmpty || day == "0") && (months.isEmpty || months == "0") {
            consumeDateTF.text = .none
        } else if months.isEmpty || months == "0" {
            consumeDateTF.text = day + "д"
            interval = Calendar.current.date(byAdding: .day, value: Int(day) ?? 0, to: productionDate, wrappingComponents: false)!
        } else if day.isEmpty || day == "0" {
            consumeDateTF.text = months + "м"
            interval = Calendar.current.date(byAdding: .month, value: Int(months) ?? 0, to: productionDate, wrappingComponents: false)!
        }  else {
            consumeDateTF.text = months + "м" + "  " + day + "д"
            interval = Calendar.current.date(byAdding: .month, value: Int(months) ?? 0, to: productionDate, wrappingComponents: false)!
            interval = Calendar.current.date(byAdding: .day, value: Int(day) ?? 0, to: interval, wrappingComponents: false)!
        }
        
        targetVC.view.endEditing(true)
        expirationDateTF.text = formatter.string(from: interval)
        expirationDatePicker.date = formatter.date(from: expirationDateTF.text!)!
    }
    
}

