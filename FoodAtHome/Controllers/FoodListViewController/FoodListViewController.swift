//
//  FoodListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.05.2022.
//

import UIKit

class FoodListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: HorizontalMenuCollectionView
    
    let horizontalMenu = HorizontalMenuCollectionView()
    private var horizontalMenuConstraint = NSLayoutConstraint()
    
    //MARK: PickerView
    
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
    
    //MARK: Constants
    
    var foodList = UITableView()
    var products = [Food]()
    let alert = AlertView()
    var unit = String()
    var months = String()
    var days = String()
    var filteredFoodList = [Food]()
    
    //MARK: Search Controller
    
    let searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "magnifyingglass")
        button.tintColor = .black
        button.action = #selector(tappedSearch)
        return button
    }()
    
    var searcController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searcController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searcController.isActive && !searchBarIsEmpty
    }
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        consumePicker.delegate = self
        foodList.delegate = self
        foodList.dataSource = self
        foodList.backgroundColor = .clear
        
        searcController.resignFirstResponder()
        searcController.delegate = self
        searcController.searchBar.delegate = self
        searcController.searchResultsUpdater = self
        searcController.obscuresBackgroundDuringPresentation = false
        searcController.searchBar.placeholder = "Поиск"
        searcController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        definesPresentationContext = true
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        horizontalMenu.cellDelegate = self
        view.addSubview(horizontalMenu)
        
        view.addSubview(foodList)
        foodList.register(SearchCell.self, forCellReuseIdentifier: "detailFood")
        foodList.separatorStyle = .none
        makeConstraints()
        
        navigationController?.navigationBar.backgroundColor = .clear
        
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.target = self
    }
    
    @objc func tappedSearch() {
        
        
        if navigationItem.searchController == searcController {
            searcController.isActive = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: { [weak self] in
                self?.navigationItem.searchController = nil
            })
            
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn) {
                self.horizontalMenuConstraint.constant += 50
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.searcController.hidesNavigationBarDuringPresentation = false
            self.navigationItem.searchController = self.searcController
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [weak self] in
                self?.searcController.isActive = true
                self?.searcController.searchBar.becomeFirstResponder()
            })
            
            UIView.animate(withDuration: 0.1, delay: 0.3, options: .curveEaseIn) {
                self.horizontalMenuConstraint.constant -= 50
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func makeConstraints() {
        
        foodList.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalMenuConstraint = NSLayoutConstraint(item: horizontalMenu, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        view.addConstraint(horizontalMenuConstraint)
        
        NSLayoutConstraint.activate([
            
            horizontalMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            horizontalMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            horizontalMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            horizontalMenu.heightAnchor.constraint(equalToConstant: 40),
            
            foodList.topAnchor.constraint(equalTo: horizontalMenu.bottomAnchor, constant: 5),
            foodList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            foodList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            foodList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredFoodList.count
        } else {
            
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailFood", for: indexPath) as! SearchCell
        cell.selectionStyle = .none
        
        var food = [Food]()
        
        if isFiltering {
            food = filteredFoodList
        } else {
            food = products
        }
        
        cell.addSubview(cell.shadowView)
        cell.shadowView.addSubview(cell.containerView)
        cell.containerView.addSubview(cell.title)
        cell.containerView.addSubview(cell.image)
        cell.addSubview(cell.addButton)
        cell.image.addSubview(cell.imageBackgroundColor)
        
        cell.title.text = food[indexPath.row].name
        cell.image.image = UIImage(named: food[indexPath.row].name)
        cell.backgroundColor = .clear
        cell.addButton.addTarget(self, action: #selector(tapped), for: .allEvents)
        cell.addButton.tag = indexPath.row
                
        NSLayoutConstraint.activate([
            
            cell.shadowView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10),
            cell.shadowView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            cell.shadowView.widthAnchor.constraint(equalToConstant: 250),
            cell.shadowView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10),
            
            cell.containerView.topAnchor.constraint(equalTo: cell.shadowView.topAnchor),
            cell.containerView.leadingAnchor.constraint(equalTo: cell.shadowView.leadingAnchor),
            cell.containerView.trailingAnchor.constraint(equalTo: cell.shadowView.trailingAnchor),
            cell.containerView.bottomAnchor.constraint(equalTo: cell.shadowView.bottomAnchor),
            
            cell.image.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 45),
            cell.image.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.image.heightAnchor.constraint(equalToConstant: 65),
            cell.image.widthAnchor.constraint(equalToConstant: 65),
            
            cell.imageBackgroundColor.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 45),
            cell.imageBackgroundColor.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.imageBackgroundColor.heightAnchor.constraint(equalToConstant: 65),
            cell.imageBackgroundColor.widthAnchor.constraint(equalToConstant: 65),
            
            cell.title.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.title.leadingAnchor.constraint(equalTo: cell.image.trailingAnchor, constant: 20),
            cell.title.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -10),
            
            cell.addButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.addButton.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20),
            cell.addButton.widthAnchor.constraint(equalToConstant: 40),
            cell.addButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        return cell
    }
    
    @objc func tapped(sender: UIButton) {

        let index = IndexPath(row: sender.tag, section: 0)
        
        if sender.isTracking {
            sender.backgroundColor = .addButtonSelectColor
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: { 
                sender.backgroundColor = .white
            })
            
        }
        
        var food = [Food]()
        
        if isFiltering {
            food = filteredFoodList
        } else {
            food = products
        }
        
        alert.showAlert(viewController: self, image:  UIImage(named: food[index.row].name)!, food: food[index.row], picker: picker, consumePicker: consumePicker, unit: unit, currentWeigt: nil, currentProductDate: nil, currentExperationDate: nil, searchController: searcController)
        
                searcController.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
    

extension FoodListViewController: SelectCollectionViewItemProtocol {
    func itemName(name: String) {
        
        if name == "ОВОЩИ" {
            products = vegitables
        } else if  name == "ФРУКТЫ И ЯГОДЫ" {
            products = fruitsAndBerries
        } else if  name == "ГРИБЫ" {
            products = mushrooms
        }
        
        foodList.reloadData()
    }
    
    
}

//MARK: - Extension UIPickerView

extension FoodListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

//MARK: - Update SearchController

extension FoodListViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFoodList = allFood.filter({ (food: Food) in
            return food.name.lowercased().contains(searchText.lowercased())
        })
        self.foodList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn) {
            self.horizontalMenuConstraint.constant += 50
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: { [weak self] in
            self?.navigationItem.searchController = nil
        })
    }
}

class SearchCell: UITableViewCell {
    
    let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.tintColor = .black
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        return button
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    let imageBackgroundColor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        view.alpha = 0.2
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "pobeda-bold", size: 24)
        title.numberOfLines = 0
        return title
    }()
    
   
}

