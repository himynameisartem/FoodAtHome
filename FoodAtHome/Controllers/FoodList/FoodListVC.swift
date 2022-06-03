//
//  FoodListVC.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 24.05.2022.
//

import UIKit

class FoodListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var foodList = UITableView()
    var foodListArray = ["Овощи" ,"Фрукты и ягоды" ,"Грибы" ,"Яйца и молочные продукты" ,"Мясные продукты" ,"Рыба и морепродукты" ,"Орехи и сухофрукты" ,"Мука и мучные изделия" ,"Крупы и каши" ,"Кондитерские изделия, сладости" ,"Зелень и цветы", "Специи и пряности", "Сырье и добавки", "Детское питание", "Безалкогольные напитки", "Алкогольные напитки"]
    
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(foodList)
        foodList.delegate = self
        foodList.dataSource = self
        foodList.translatesAutoresizingMaskIntoConstraints = false
        foodList.register(UITableViewCell.self, forCellReuseIdentifier: "listCell")
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        makeConstraints()
    }
    
    func makeConstraints() {
        
        NSLayoutConstraint.activate([
            
            foodList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            foodList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        cell.selectionStyle = .default
        cell.textLabel?.text = foodListArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: Did Select
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailFoodVC = DetailFoodListVC()
        
        if foodListArray[indexPath.row] == "Овощи" {
            detailFoodVC.products = vegitables
        }
        
        if foodListArray[indexPath.row] == "Фрукты и ягоды" {
            detailFoodVC.products = fruitsAndBerries
        }
        
        if foodListArray[indexPath.row] == "Грибы" {
            detailFoodVC.products = mushrooms
        }
        
        detailFoodVC.modalPresentationStyle = .currentContext
        navigationController?.pushViewController(detailFoodVC, animated: true)
    }
}
