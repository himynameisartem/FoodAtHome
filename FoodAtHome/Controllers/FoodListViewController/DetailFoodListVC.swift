//
//  DetailFoodListVC.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.05.2022.
//

import UIKit

class DetailFoodListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var searcController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searcController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searcController.isActive && !searchBarIsEmpty
    }
    
    //MARK: Bacground View
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wallpapers")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.alpha = 0.2
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: .light)
        view.effect = blurEffect
        view.alpha = 0.8
        return view
    }()
    
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
        navigationItem.searchController = searcController
        definesPresentationContext = true
        
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurView)
        blurView.frame = view.bounds
        view.backgroundColor = .white
        
        
        view.addSubview(foodList)
        foodList.register(SearchCell.self, forCellReuseIdentifier: "detailFood")
        foodList.separatorStyle = .none
        makeConstraints()
    }
    
    func makeConstraints() {
        
        foodList.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            foodList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        
        var food = [Food]()
        
        if isFiltering {
            food = filteredFoodList
        } else {
            food = products
        }
        
        cell.addSubview(cell.image)
        cell.addSubview(cell.title)
        
        cell.title.text = food[indexPath.row].name
        cell.image.image = UIImage(named: food[indexPath.row].name)
        cell.backgroundColor = .clear
        
        
        NSLayoutConstraint.activate([
            
            cell.image.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.image.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
            cell.image.heightAnchor.constraint(equalToConstant: 60),
            cell.image.widthAnchor.constraint(equalToConstant: 60),
            cell.title.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.title.leadingAnchor.constraint(equalTo: cell.image.trailingAnchor, constant: 20),
            cell.title.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 20)
            
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: Did Select
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        alert.showAlert(viewController: self, image:  UIImage(named: products[indexPath.row].name)!, food: products[indexPath.row], picker: picker, consumePicker: consumePicker, unit: unit, currentWeigt: nil, currentProductDate: nil, currentExperationDate: nil, searchController: searcController)
        
        searcController.searchBar.resignFirstResponder()
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

//MARK: - Update SearchController

extension DetailFoodListVC: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFoodList = products.filter({ (food: Food) in
            return food.name.lowercased().contains(searchText.lowercased())
        })
        self.foodList.reloadData()
    }
}
