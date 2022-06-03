//
//  DetailFoodListVC.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.05.2022.
//

import UIKit

class DetailFoodListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let pickerArray = ["кг.", "г.", "л.", "мл.", "уп."]
    let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var foodList = UITableView()
    var products = [Food]()
    let alert = AlertView()
    var unit = String()
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
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
        
        alert.showAlert(viewController: self, image:  UIImage(named: products[indexPath.row].name)!, food: products[indexPath.row], picker: picker, unit: unit)
        
    }
}

//MARK: - Extension UIPickerView

extension DetailFoodListVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alert.unit = pickerArray[row]
        print(pickerArray[row])
    }
}
