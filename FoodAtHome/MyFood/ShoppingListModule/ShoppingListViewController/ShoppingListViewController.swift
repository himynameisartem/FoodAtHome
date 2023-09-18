//
//  ShoppingListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 05.07.2022.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    var presenter: ShoppingListPresenterProtocol!
    private let configurator: ShoppingListConfiguratorProtocol = ShoppingListConfigurator()
    
    private var wallpapers: UIImageView!
    private var navView: UIView!
    private var navTitle: UILabel!
    private var removeAll: UIButton!
    private var addFood: UIButton!
    
    private var shoppingListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraint()
        
        configurator.configure(with: self)
        presenter.viewDidLoad()
        
    }
}

//MARK: - SetupUI

extension ShoppingListViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .systemGray5
        navigationItem.backButtonTitle = "Back".localized()
        navigationController?.navigationBar.tintColor = .black
        wallpapers = UIImageView(image: UIImage(named: "wallpapers"))
        wallpapers.contentMode = .scaleAspectFill
        wallpapers.alpha = 0.2
        wallpapers.frame = view.bounds
        view.addSubview(wallpapers)
        
        navView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        navTitle = UILabel()
        navTitle.contentMode = .center
        navTitle.text = "FOOD AT HOME".localized()
        navTitle.translatesAutoresizingMaskIntoConstraints = false
        navTitle.font = UIFont(name: "Inter-Light", size: 18)
        navView.addSubview(navTitle)
        addFood = UIButton()
        addFood.translatesAutoresizingMaskIntoConstraints = false
        addFood.setImage(UIImage(systemName: "plus"), for: .normal)
        addFood.addTarget(self, action: #selector(addFoodButtonTapped), for: .touchUpInside)
        addFood.contentMode = .center
        navView.addSubview(addFood)
        removeAll = UIButton()
        removeAll.translatesAutoresizingMaskIntoConstraints = false
        removeAll.setImage(UIImage(systemName: "trash"), for: .normal)
        removeAll.addTarget(self, action: #selector(removeAllButtonTapped), for: .touchUpInside)
        removeAll.contentMode = .center
        navView.addSubview(removeAll)
        
        navigationItem.titleView = navView
        
        shoppingListTableView = UITableView()
        shoppingListTableView.translatesAutoresizingMaskIntoConstraints = false
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        shoppingListTableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: "shoppingListTableViewCell")
        shoppingListTableView.showsVerticalScrollIndicator = false
        shoppingListTableView.backgroundColor = .clear
        shoppingListTableView.separatorStyle = .none
        view.addSubview(shoppingListTableView)
        
        shoppingListTableView.frame = view.bounds
        
        
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            
            navTitle.topAnchor.constraint(equalTo: navView.topAnchor),
            navTitle.leadingAnchor.constraint(equalTo: navView.leadingAnchor),
            navTitle.bottomAnchor.constraint(equalTo: navView.bottomAnchor),
            navTitle.widthAnchor.constraint(equalToConstant: view.frame.width),
            navTitle.trailingAnchor.constraint(equalTo: navView.trailingAnchor),
            
            addFood.topAnchor.constraint(equalTo: navView.topAnchor),
            addFood.centerYAnchor.constraint(equalTo: navTitle.centerYAnchor),
            addFood.widthAnchor.constraint(equalToConstant: 20),
            addFood.bottomAnchor.constraint(equalTo: navView.bottomAnchor),
            
            removeAll.topAnchor.constraint(equalTo: navView.topAnchor),
            removeAll.centerYAnchor.constraint(equalTo: navTitle.centerYAnchor),
            removeAll.widthAnchor.constraint(equalToConstant: 20),
            removeAll.bottomAnchor.constraint(equalTo: navView.bottomAnchor),
        ])
        
        if UIDevice.current.name == "iPhone SE (1st generation)" {
            addFood.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: view.frame.width - 40).isActive = true
            removeAll.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: view.frame.width - 80).isActive = true
        } else {
            addFood.trailingAnchor.constraint(equalTo: navView.trailingAnchor).isActive = true
            removeAll.trailingAnchor.constraint(equalTo: addFood.leadingAnchor, constant: -20).isActive = true
        }
        
    }
    
}

//MARK: Targets

extension ShoppingListViewController {
    
    @objc func removeAllButtonTapped(_ sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
            
            let alert = UIAlertController(title: "Delete All Products?".localized(), message: "This action will lead to the removal of all products from the shopping list. Are you sure you want to proceed?".localized(), preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { done in
                self.presenter.removeAllFood()
                self.presenter.viewDidLoad()
            }

            let cancelAction = UIAlertAction(title: "No".localized(), style: .default)
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)

            
        }
    }
    @objc func addFoodButtonTapped(_ sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
            self.presenter.showFoodListViewController()
        }
    }
    
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.shoppingListCounter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListTableViewCell", for: indexPath) as! ShoppingListTableViewCell
        
        let food = presenter.food(at: indexPath)
        cell.configure(food)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let okAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            completionHandler(true)
        }
        
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            completionHandler(true)
        }
        
        ContextualActionViewManager.shared.setupAction(action: okAction, imageName: "success")
        ContextualActionViewManager.shared.setupAction(action: deleteAction, imageName: "delete")
                
        let actions = UISwipeActionsConfiguration(actions: [okAction, deleteAction])
        return actions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let changeAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            completionHandler(true)
        }
        
        ContextualActionViewManager.shared.setupAction(action: changeAction, imageName: "edit")

        let actions = UISwipeActionsConfiguration(actions: [changeAction])
        return actions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ShoppingListViewController: ShoppingListViewProtocol {
    func reloadData() {
        shoppingListTableView.reloadData()
    }
}
