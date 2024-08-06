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
    
    private var openAnimation = true
    
    private var wallpapers: UIImageView!
    private var navView: UIView!
    private var navTitle: UILabel!
    private var removeAll: UIButton!
    private var addFood: UIButton!
    
    private var isEditingFromList = false
    
    private var shoppingListTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewDidLoad()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupConstraint()
        
        configurator.configure(with: self)
        presenter.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        openAnimation = true
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

//MARK: - UITableViewDelegate

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
        let item = self.presenter.food(at: indexPath)
        let okAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            self.isEditingFromList = true
            
            if self.presenter.checkExistFood(food: item) {
                
                let alert = UIAlertController(title: "You already have this product".localized(), message: "Do you want to replace it?".localized(), preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { done in
                    
                    let alert = UIAlertController(title: "Add an expiration date?".localized(), message: "", preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { done in
                        self.presenter.addExperationDate(food: item, viewController: self)
                        self.presenter.configureChangeMenu(food: item)
                        self.presenter.viewDidLoad()
                    }
                    let noAction = UIAlertAction(title: "No".localized(), style: .default) { done in
                        self.presenter.addFoodForFoodList(food: item, viewController: self)
                        self.presenter.deleteFoodAfterAdding(food: item)
                        self.presenter.viewDidLoad()
                        tableView.reloadData()
                    }
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    self.present(alert, animated: true)
                }
                
                let noAction = UIAlertAction(title: "No".localized(), style: .default)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Add an expiration date?".localized(), message: "", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { done in
                    self.presenter.addExperationDate(food: item, viewController: self)
                    self.presenter.configureChangeMenu(food: item)
                    self.presenter.viewDidLoad()
                }
                let noAction = UIAlertAction(title: "No".localized(), style: .default) { done in
                    self.presenter.moveFood(food: item, viewController: self)
                    self.presenter.viewDidLoad()
                    tableView.reloadData()
                }
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true)
            }
            completionHandler(true)
        }
        
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            self.isEditingFromList = false
            self.presenter.deleteProducts(food: item)
            self.presenter.viewDidLoad()
            tableView.reloadData()
            completionHandler(true)
        }
        
        ContextualActionViewManager.shared.setupAction(action: okAction, imageName: "success")
        ContextualActionViewManager.shared.setupAction(action: deleteAction, imageName: "delete")
        
        let actions = UISwipeActionsConfiguration(actions: [okAction, deleteAction])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = presenter.food(at: indexPath)
        
        let changeAction = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            self.isEditingFromList = false
            self.presenter.showChangeMenu(viewController: self)
            self.presenter.configureChangeMenu(food: item)
            completionHandler(true)
        }
        
        ContextualActionViewManager.shared.setupAction(action: changeAction, imageName: "edit")
        
        let actions = UISwipeActionsConfiguration(actions: [changeAction])
        actions.performsFirstActionWithFullSwipe = false
        return actions
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if openAnimation {
            cell.transform = CGAffineTransform(translationX: -cell.contentView.frame.width, y: 0)
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row)) {
                cell.transform = .identity
            } completion: { done in
                if done {
                    self.openAnimation = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - PickerView DataSource

extension ShoppingListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return pickerArray.count
        } else {
            if component == 0 {
                return monthsInterval.count
            }
            return daysInterval.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()

        if pickerView.tag == 0 {
            pickerLabel.text = pickerArray[row].localized()
        } else {
            if component == 0 {
                pickerLabel.text = monthsInterval[row] + "m".localized()
            } else {
                pickerLabel.text = daysInterval[row] + "d".localized()
            }
        }
     
        pickerLabel.textAlignment = .center
        pickerLabel.font = UIFont(name: "Helvetica", size: 22)

        for subview in pickerView.subviews {
            subview.backgroundColor = .clear
        }
        
         return pickerLabel
    }
}

extension ShoppingListViewController: AddAndChangeFoodDelegate {
    func didAddNewFood(_ food: FoodRealm) {
        if isEditingFromList {
            presenter.addFoodForFoodList(food: food, viewController: self)
            presenter.deleteFoodAfterAdding(food: food)
            presenter.viewDidLoad()
            shoppingListTableView.reloadData()
        } else {
            presenter.changeFood(food: food, viewController: self)
            presenter.viewDidLoad()
            shoppingListTableView.reloadData()
        }
    }
}

extension ShoppingListViewController: ShoppingListViewProtocol {
    func reloadData() {
        shoppingListTableView.reloadData()
    }
}
