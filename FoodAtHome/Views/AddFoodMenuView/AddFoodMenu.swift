//
//  AddFoodMenu.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 18.09.2024.
//

import UIKit

protocol AddFoodMenuDelegate: AnyObject {
    func didCloseAddFood()
}

class AddFoodMenu: UIView {
    
    weak var delegate: AddFoodMenuDelegate?
    
    private var dimmingView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    var datePicker: UIDatePicker!
    var consumeUPPicker: UIPickerView!
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var productionDateLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var consumeUpLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var popupMenuButton: UIButton!
    @IBOutlet weak var productionDateTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var consumeUpTextField: UITextField!
    @IBOutlet weak var addFoodButton: UIButton!
    @IBOutlet weak var stackViewContainer: UIStackView!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    var food: FoodRealm?
    private let monthWheel: [Int] = Array(0...48)
    private let daysWheel: [Int] = Array(0...31)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPopupMenu()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closeAddFoodMenu()
    }
    
    @IBAction func swipeToClose(_ sender: Any) {
        closeAddFoodMenu()
    }
    
    @IBAction func addFoodButtonTapped(_ sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
                self.checkWeightAndDuplicate()
        }
    }
    
    func configure(from food: FoodRealm) {
        foodImageView.image = UIImage(named: food.name)
        if food.weight != "0.0" {
            weightTextField.text = food.weight
        }
        productionDateTextField.text = food.productionDateString()
        expirationDateTextField.text = food.expirationDateString()
        consumeUpTextField.text = food.consumeUpString()
        
        self.food = food
    }
    
    func addFood() {
        checkUnit()
        guard let food = food else { return }
        DataManager.shared.writeFood(food)
    }
    
    func changeFood() {
        checkUnit()
        guard let food = food else { return }
        DataManager.shared.changeFood(food)
    }
    
    func updateFood() {
        guard let food = food else { return }
        DataManager.shared.updateFood(food)
    }
    
    func closeAddFoodMenu() {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = -900
        } completion: { done in
            UIView.animate(withDuration: 0.3) {
                self.dimmingView.alpha = 0
            } completion: { done in
                if done {
                    self.dimmingView.removeFromSuperview()
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    func showAddFoodMenu() {
        let viewController = getTopViewController()
        guard let view = viewController?.view else { return }
        let width = view.frame.width - 40
        let height = width * 1.7
        self.frame = CGRect(x: view.center.x - width / 2, y: -900, width: width, height: height)
        
        blurEffect = UIBlurEffect(style: .dark)
        dimmingView = UIVisualEffectView(frame: view.bounds)
        setupUI()
        
        view.addSubview(dimmingView)
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
        } completion: { done in
            UIView.animate(withDuration: 0.3) {
                self.frame = CGRect(x: view.center.x - width / 2, y: view.center.y - height / 2, width: width, height: height)
            }
        }
    }
    
    private func setupUI() {
        dimmingView.effect = blurEffect
        dimmingView.alpha = 0
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        
        datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        consumeUPPicker = UIPickerView()
        consumeUPPicker.dataSource = self
        consumeUPPicker.delegate = self
        
        setupTextFields()
    }
    
    private func setupPopupMenu() {
        let optionClosure = { (action : UIAction) in
            let unit = action.title
            self.food?.unit = unit
        }
        popupMenuButton.menu = UIMenu(children: [
            UIAction(title: "kg.".localized(), state: .off, handler: optionClosure),
            UIAction(title: "g.".localized(), state: .off, handler: optionClosure),
            UIAction(title: "l.".localized(), state: .off, handler: optionClosure),
            UIAction(title: "ml.".localized(), state: .off, handler: optionClosure),
            UIAction(title: "pk.".localized(), state: .off, handler: optionClosure),
            UIAction(title: "pcs.".localized(), state: .off, handler: optionClosure),
        ])
        
        popupMenuButton.showsMenuAsPrimaryAction = true
        popupMenuButton.changesSelectionAsPrimaryAction = true
    }
    
    
}

//MARK: - UITextFieldDelegate

extension AddFoodMenu: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == productionDateTextField {
            expirationDateTextField.isEnabled = true
            consumeUpTextField.isEnabled = true
            food?.productionDate = datePicker.date
        } else if textField == expirationDateTextField  {
            food?.expirationDate = datePicker.date
        } else if textField == consumeUpTextField {
            let month = consumeUPPicker.selectedRow(inComponent: 0)
            let day = consumeUPPicker.selectedRow(inComponent: 1)
            food?.consumeUp = ConsumeUp(months: month, days: day)
            guard let expirationDate = food?.expirationDate else { return }
            if expirationDate < Date.now {
                food?.expirationDate = Date.now
            }
        } else if textField == weightTextField {
            if weightTextField.text == "" {
                food?.weight = "0.0"
            } else {
                food?.weight = weightTextField.text ?? "0.0"
            }
        }
        productionDateTextField.text = food?.productionDateString()
        expirationDateTextField.text = food?.expirationDateString()
        consumeUpTextField.text = food?.consumeUpString()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == productionDateTextField {
            datePicker.maximumDate = Date.now
            datePicker.minimumDate = nil
            guard let productionDate = food?.productionDate else { return }
            datePicker.date = productionDate
        } else if textField == expirationDateTextField {
            datePicker.minimumDate = Date.now
            datePicker.maximumDate = nil
            if let expirationDate = food?.expirationDate {
                datePicker.date = expirationDate
            } else {
                datePicker.date = Date.now
            }
        } else if textField == consumeUpTextField && consumeUpTextField.text != ""{
            guard let expirationDate = food?.consumeUp else { return }
            let month = expirationDate.months ?? 0
            let day = expirationDate.days ?? 0
            consumeUPPicker.selectRow(month, inComponent: 0, animated: true)
            consumeUPPicker.selectRow(day, inComponent: 1, animated: true)
        }
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension AddFoodMenu: UIPickerViewDelegate, UIPickerViewDataSource {
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
