//
//  CategoryListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 17.07.2022.
//


import UIKit

class CategoryListViewController: UIViewController {
    
    private let categoryListTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    var foodCategoryArray = [FoodRealm]()
    var imageName = String()
 
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(categoryListTableView)
        categoryListTableView.frame = view.bounds
        
        categoryListTableView.delegate = self
        categoryListTableView.dataSource = self
        
        categoryListTableView.register(CategoryListTableViewCell.self, forCellReuseIdentifier: "categoryListCell")
        
    }
}

//MARK: - TableView DataSource

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath) as! CategoryListTableViewCell
        
        cell.awakeFromNib()
        
        cell.image.image = UIImage(named: foodCategoryArray[indexPath.row].name)
        cell.name.text = foodCategoryArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

