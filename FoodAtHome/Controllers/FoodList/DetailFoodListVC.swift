//
//  DetailFoodListVC.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.05.2022.
//

import UIKit

class DetailFoodListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let pickerArray = ["кг.", "г.", "л.", "мл.", "уп."]
    let monthsInterval = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36"]
    let daysInterval = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    
    let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let consumePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.isOpaque = false
        return picker
    }()
    
    var foodList = UITableView()
    var products = [Food]()
    let alert = AlertView()
    var unit = String()
    var months = String()
    var days = String()
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        picker.delegate = self
        picker.dataSource = self
        consumePicker.delegate = self
        foodList.delegate = self
        foodList.dataSource = self
        view.addSubview(foodList)
        makeConstraints()
        foodList.register(UITableViewCell.self, forCellReuseIdentifier: "detailFood")
        view.backgroundColor = .white
    }
    
    func makeConstraints() {
        
        foodList.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            foodList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            foodList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailFood", for: indexPath)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = products[indexPath.row].name
        cell.imageView?.image = UIImage(named: products[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: Did Select
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        alert.showAlert(viewController: self, image:  UIImage(named: products[indexPath.row].name)!, food: products[indexPath.row], picker: picker, consumePicker: consumePicker, unit: unit)
        
    }
}

//MARK: - Extension UIPickerView

extension DetailFoodListVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == picker {
            return 1 }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker {
            return pickerArray.count
        }
        if component == 0{
            return monthsInterval.count
        }
        return daysInterval.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker {
            return pickerArray[row]
        }
        if component == 0 {
            return monthsInterval[row] + "м"
        }
        return daysInterval[row] + "д"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker {
            alert.unit = pickerArray[row]
        }
        if component == 0 {
            alert.months = monthsInterval[row]
        }
        if component == 1 {
        alert.day = daysInterval[row]
        }
    }
}
