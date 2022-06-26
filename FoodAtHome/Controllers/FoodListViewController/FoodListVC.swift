//
//  FoodListVC.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 24.05.2022.
//

import UIKit

class FoodListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let alert = AlertView()
    var unit = String()
    var months = String()
    var days = String()
    var foodList = UITableView()
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
    
    //MARK: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        consumePicker.delegate = self
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
        
        foodList.backgroundColor = .clear
        foodList.delegate = self
        foodList.dataSource = self
        foodList.translatesAutoresizingMaskIntoConstraints = false
        foodList.register(FoodListCell.self, forCellReuseIdentifier: "listCell")
        foodList.register(SearchCell.self, forCellReuseIdentifier: "searchCell")
        foodList.showsVerticalScrollIndicator = false
        foodList.separatorStyle = .none
        
        makeConstraints()
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.backButtonTitle = "Назад"
        
    }
    
    func makeConstraints() {
        
        view.addSubview(foodList)
        
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
        }
        return foodListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFiltering {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
            
            cell.addSubview(cell.image)
            cell.addSubview(cell.title)
            
            cell.title.text = filteredFoodList[indexPath.row].name
            cell.image.image = UIImage(named: filteredFoodList[indexPath.row].name)
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
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! FoodListCell
            
            cell.addSubview(cell.shadowView)
            cell.shadowView.addSubview(cell.containerView)
            cell.containerView.addSubview(cell.title)
            cell.containerView.addSubview(cell.image)
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.image.image = UIImage(named: foodListArray[indexPath.row])
            cell.title.text = foodListArray[indexPath.row]
            
            NSLayoutConstraint.activate([
                
                cell.shadowView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5),
                cell.shadowView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 10),
                cell.shadowView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10),
                cell.shadowView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -5),
                
                cell.containerView.topAnchor.constraint(equalTo: cell.shadowView.topAnchor),
                cell.containerView.leadingAnchor.constraint(equalTo: cell.shadowView.leadingAnchor),
                cell.containerView.trailingAnchor.constraint(equalTo: cell.shadowView.trailingAnchor),
                cell.containerView.bottomAnchor.constraint(equalTo: cell.shadowView.bottomAnchor),
                
                cell.image.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 10),
                cell.image.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                cell.image.heightAnchor.constraint(equalToConstant: 70),
                cell.image.widthAnchor.constraint(equalToConstant: 70),
                
                cell.title.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                cell.title.leadingAnchor.constraint(equalTo: cell.image.trailingAnchor, constant: 20),
                cell.title.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -10)
                
            ])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFiltering{
            return 70
        } else {
            return 100
        }
    }
    
    //MARK: Did Select
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering {
            
            alert.showAlert(viewController: self, image:  UIImage(named: filteredFoodList[indexPath.row].name)!, food: filteredFoodList[indexPath.row], picker: picker, consumePicker: consumePicker, unit: unit, currentWeigt: nil, currentProductDate: nil, currentExperationDate: nil, searchController: searcController)
            
            searcController.searchBar.resignFirstResponder()
            
        } else {
            
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
}

//MARK: - Table View Cell

class FoodListCell: UITableViewCell {
    
    let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
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
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.font = UIFont(name: "pobeda-bold", size: 24)
        title.textColor = .darkGray
        return title
    }()
    
}

//MARK: - Update SearchController

extension FoodListVC: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFoodList = allFood.filter({ (food: Food) in
            return food.name.lowercased().contains(searchText.lowercased())
        })
        self.foodList.reloadData()
    }
}

//MARK: - Extension UIPickerView

extension FoodListVC: UIPickerViewDelegate, UIPickerViewDataSource {
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

class SearchCell: UITableViewCell {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 10
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "pobeda-bold", size: 24)
        title.numberOfLines = 0
        return title
    }()
    
}
