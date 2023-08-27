//
//  CategoryListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 17.07.2022.
//


import UIKit

class CategoryListViewController: UIViewController {
    
    private var categoryFoodImageView: UIImageView!
    private var categoryListTableView: UITableView!
    
    var presenter: CategoryFoodPresenterProtocol!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        setupUI()
        setupConstraint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

extension CategoryListViewController {
    
    private func setupUI() {
                
        tabBarController?.tabBar.isHidden = true
        
        categoryFoodImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryFoodImageView.contentMode = .scaleAspectFill
        categoryFoodImageView.clipsToBounds = true
        view.addSubview(categoryFoodImageView)
        
        categoryListTableView = UITableView()
        categoryListTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryListTableView.delegate = self
        categoryListTableView.dataSource = self
        categoryListTableView.register(CategoryListTableViewCell.self, forCellReuseIdentifier: "categoryListCell")
        view.addSubview(categoryListTableView)

    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            categoryFoodImageView.topAnchor.constraint(equalTo: view.topAnchor),
            categoryFoodImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryFoodImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryFoodImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            
            categoryListTableView.topAnchor.constraint(equalTo: categoryFoodImageView.bottomAnchor),
            categoryListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - TableView DataSource

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.foodCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath) as! CategoryListTableViewCell
        
        guard let food = presenter.getFood(at: indexPath) else { return cell }
        cell.configure(food)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension CategoryListViewController: CategoryFoodViewProtocol {
    func setImage(_ imageName: String) {
        categoryFoodImageView = UIImageView(image: UIImage(named: imageName))
    }
    
    func setName(_ categoryName: String) {
        
    }
}

