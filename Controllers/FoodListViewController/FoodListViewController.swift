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
    
    var time = true
    var cellWhidth = CGFloat()
    var foodList = UITableView()
    var products = [FoodRealm]()
    let alert = AlertView()
    var unit = String()
    var months = String()
    var days = String()
    var filteredFoodList = [FoodRealm]()
    
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
        
        view.backgroundColor = #colorLiteral(red: 0.9438247681, green: 0.9557064176, blue: 0.9554974437, alpha: 1)
        
        horizontalMenu.cellDelegate = self
        view.addSubview(horizontalMenu)
        
        view.addSubview(foodList)
        foodList.register(DetailFoodCell.self, forCellReuseIdentifier: "detailFood")
        foodList.separatorStyle = .none
        makeConstraints()
        
        navigationController?.navigationBar.backgroundColor = .clear
        
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.target = self
        
        tabBarController?.tabBar.isHidden = true
                
        vcCheck = true
    }
    
    @objc func tappedSearch() {
        
        UIView.setAnimationsEnabled(true)
        
        searcController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.titleView = self.searcController.searchBar
        searcController.searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = .none
        navigationItem.hidesBackButton = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: { [weak self] in
            self?.searcController.isActive = true
        })
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseIn) {
            self.horizontalMenuConstraint.constant -= 50
            self.view.layoutIfNeeded()
        }
    }
    
    func makeConstraints() {
        foodList.backgroundColor = #colorLiteral(red: 0.9438247681, green: 0.9557064176, blue: 0.9554974437, alpha: 1)
        foodList.translatesAutoresizingMaskIntoConstraints = false
        horizontalMenuConstraint = NSLayoutConstraint(item: horizontalMenu, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        view.addConstraint(horizontalMenuConstraint)
        
        NSLayoutConstraint.activate([
            
            horizontalMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            horizontalMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            horizontalMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            foodList.topAnchor.constraint(equalTo: horizontalMenu.bottomAnchor, constant: 5),
            foodList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -0.5),
            foodList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.5),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailFood", for: indexPath) as! DetailFoodCell
        cell.selectionStyle = .none
        
        var food = [FoodRealm]()
        
        if isFiltering {
            food = filteredFoodList
        } else {
            food = products
        }
        
        cell.addSubview(cell.shadowView)
        cell.shadowView.addSubview(cell.containerView)
        cell.containerView.addSubview(cell.stack)
        cell.stack.addArrangedSubview(cell.title)
        cell.stack.addArrangedSubview(cell.colories)
        cell.containerView.addSubview(cell.image)
        cell.addSubview(cell.addButton)
        cell.image.addSubview(cell.imageBackgroundColor)
        
        cell.title.text = food[indexPath.row].name
        cell.title.font = UIFont(name: "Inter-Light", size: titleFontSize(viewHeight: view.frame.height))
        
        cell.colories.text = ("\(food[indexPath.row].calories) кКал. / 100г.")
        cell.colories.font = UIFont(name: "Inter-ExtraLight", size: titleFontSize(viewHeight: view.frame.height) - 5)
        cell.colories.alpha = 0.7
        
        cell.image.image = UIImage(named: food[indexPath.row].name)
        cell.backgroundColor = .clear
        cell.addButton.addTarget(self, action: #selector(tapped), for: .allEvents)
        cell.addButton.tag = indexPath.row
        
        NSLayoutConstraint.activate([
            
            cell.shadowView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10),
            cell.shadowView.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            cell.shadowView.widthAnchor.constraint(equalToConstant: cellWhidth(viewHeight: view.frame.height)),
            cell.shadowView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10),
            
            cell.containerView.topAnchor.constraint(equalTo: cell.shadowView.topAnchor),
            cell.containerView.leadingAnchor.constraint(equalTo: cell.shadowView.leadingAnchor),
            cell.containerView.trailingAnchor.constraint(equalTo: cell.shadowView.trailingAnchor),
            cell.containerView.bottomAnchor.constraint(equalTo: cell.shadowView.bottomAnchor),
            
            cell.image.leadingAnchor.constraint(equalTo: cell.leadingAnchor,
                                                constant: imageConstraint(viewHeight: view.frame.height)),
            cell.image.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.image.heightAnchor.constraint(equalToConstant: cellHeight(viewHeight: view.frame.height) - 35),
            cell.image.widthAnchor.constraint(equalToConstant: cellHeight(viewHeight: view.frame.height) - 35),
            
            cell.imageBackgroundColor.leadingAnchor.constraint(equalTo: cell.leadingAnchor,
                                                               constant: imageConstraint(viewHeight: view.frame.height)),
            cell.imageBackgroundColor.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.imageBackgroundColor.heightAnchor.constraint(equalToConstant: 65),
            cell.imageBackgroundColor.widthAnchor.constraint(equalToConstant: 65),
            
            cell.stack.topAnchor.constraint(equalTo: cell.shadowView.topAnchor, constant: 8),
            cell.stack.leadingAnchor.constraint(equalTo: cell.image.trailingAnchor, constant: 20),
            cell.stack.trailingAnchor.constraint(equalTo: cell.shadowView.trailingAnchor, constant: -10),
            cell.stack.bottomAnchor.constraint(equalTo: cell.shadowView.bottomAnchor, constant: -8),
            
            cell.addButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.addButton.centerXAnchor.constraint(equalTo: cell.trailingAnchor,
                                                    constant: -((view.frame.width - cellWhidth(viewHeight: view.frame.height)) / 4)),
            cell.addButton.widthAnchor.constraint(equalToConstant: 40),
            cell.addButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if time {
            cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
            } completion: { done in
                if done {
                    self.time = false
                }
            }
        }
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
        
        var food = [FoodRealm]()
        
        if isFiltering {
            food = filteredFoodList
        } else {
            food = products
        }
        
        alert.showAlert(viewController: self, image:  UIImage(named: food[index.row].name)!, food: food[index.row], picker: picker, consumePicker: consumePicker, unit: unit, currentWeigt: nil, currentProductDate: nil, currentExperationDate: nil, searchController: searcController)
        
        searcController.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(viewHeight: view.frame.height)
    }
    
    //MARK: - scrollViewDidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            foodList.layer.borderWidth = 0.3
            foodList.layer.borderColor = #colorLiteral(red: 0.34122473, green: 0.34122473, blue: 0.34122473, alpha: 0.3141556291)
        } else {
            foodList.layer.borderWidth = 0.0
        }
    }
}

//MARK: - SelectCollectionViewItemProtocol

extension FoodListViewController: SelectCollectionViewItemProtocol {
    func itemName(name: String) {
        
        if name == "Овощи" {
            products = vegitables
        } else if  name == "Фрукты и ягоды" {
            products = fruitsAndBerries
        } else if  name == "Грибы" {
            products = mushrooms
        }
        
        time = true
        foodList.contentOffset = CGPoint(x: 0.0, y: 0.0)
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
        filteredFoodList = allFood.filter({ (food: FoodRealm) in
            return food.name.lowercased().contains(searchText.lowercased())
        })
        
        if isFiltering {
            foodList.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
        
        self.foodList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        navigationItem.hidesBackButton = false
        self.navigationItem.titleView = .none
        navigationItem.rightBarButtonItem = searchButton
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
            self.horizontalMenuConstraint.constant += 50
            self.view.layoutIfNeeded()
        }
        foodList.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
}

//MARK: - Detail Food Cell

class DetailFoodCell: UITableViewCell {
    
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
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        return title
    }()
    
    let colories: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
}

//MARK: - Size Items and Font


extension FoodListViewController {
    
    func cellWhidth(viewHeight: Double) -> CGFloat {
        switch viewHeight {
        case iPhoneScreensHeight.iPhone_5s_SE.rawValue:
            return 190
        case iPhoneScreensHeight.iPhone_6S_6SPlus_7_8_SE2nd.rawValue:
            return 220
        case iPhoneScreensHeight.iPhone_7Plus_8Plus.rawValue:
            return 250
        case iPhoneScreensHeight.iPhone_X_XS_12mini_13mini.rawValue:
            return 230
        case iPhoneScreensHeight.iPhone_12_12Pro_13_13Pro.rawValue:
            return 230
        case iPhoneScreensHeight.iPhone_XSMax_XR_11_11Pro_11ProMax.rawValue:
            return 260
        case iPhoneScreensHeight.iPhone_12ProMax_13ProMax.rawValue:
            return 260
        default:
            return 250
        }
    }
    
    func cellHeight(viewHeight: Double) -> CGFloat {
        switch viewHeight {
        case iPhoneScreensHeight.iPhone_5s_SE.rawValue:
            return 90
        case iPhoneScreensHeight.iPhone_6S_6SPlus_7_8_SE2nd.rawValue:
            return 90
        case iPhoneScreensHeight.iPhone_7Plus_8Plus.rawValue:
            return 100
        case iPhoneScreensHeight.iPhone_X_XS_12mini_13mini.rawValue:
            return 100
        case iPhoneScreensHeight.iPhone_12_12Pro_13_13Pro.rawValue:
            return 95
        case iPhoneScreensHeight.iPhone_XSMax_XR_11_11Pro_11ProMax.rawValue:
            return 100
        case iPhoneScreensHeight.iPhone_12ProMax_13ProMax.rawValue:
            return 100
        default:
            return 100
        }
    }
    
    func addButtonConstraint(viewHeight: Double) -> CGFloat {
        switch viewHeight {
        case iPhoneScreensHeight.iPhone_5s_SE.rawValue:
            return -12
        case iPhoneScreensHeight.iPhone_6S_6SPlus_7_8_SE2nd.rawValue:
            return -20
        case iPhoneScreensHeight.iPhone_7Plus_8Plus.rawValue:
            return -20
        case iPhoneScreensHeight.iPhone_X_XS_12mini_13mini.rawValue:
            return -20
        case iPhoneScreensHeight.iPhone_12_12Pro_13_13Pro.rawValue:
            return -20
        case iPhoneScreensHeight.iPhone_XSMax_XR_11_11Pro_11ProMax.rawValue:
            return -15
        case iPhoneScreensHeight.iPhone_12ProMax_13ProMax.rawValue:
            return -20
        default:
            return -20
        }
    }
    
    func imageConstraint(viewHeight: Double) -> CGFloat {
        switch viewHeight {
        case iPhoneScreensHeight.iPhone_5s_SE.rawValue:
            return 30
        case iPhoneScreensHeight.iPhone_6S_6SPlus_7_8_SE2nd.rawValue:
            return 45
        case iPhoneScreensHeight.iPhone_7Plus_8Plus.rawValue:
            return 45
        case iPhoneScreensHeight.iPhone_X_XS_12mini_13mini.rawValue:
            return 40
        case iPhoneScreensHeight.iPhone_12_12Pro_13_13Pro.rawValue:
            return 45
        case iPhoneScreensHeight.iPhone_XSMax_XR_11_11Pro_11ProMax.rawValue:
            return 40
        case iPhoneScreensHeight.iPhone_12ProMax_13ProMax.rawValue:
            return 45
        default:
            return 45
        }
    }
    

    func titleFontSize(viewHeight: Double) -> CGFloat {
        switch viewHeight {
        case iPhoneScreensHeight.iPhone_5s_SE.rawValue:
            return 12
        case iPhoneScreensHeight.iPhone_6S_6SPlus_7_8_SE2nd.rawValue:
            return 14
        case iPhoneScreensHeight.iPhone_7Plus_8Plus.rawValue:
            return 16
        case iPhoneScreensHeight.iPhone_X_XS_12mini_13mini.rawValue:
            return 14
        case iPhoneScreensHeight.iPhone_12_12Pro_13_13Pro.rawValue:
            return 16
        case iPhoneScreensHeight.iPhone_XSMax_XR_11_11Pro_11ProMax.rawValue:
            return 16
        case iPhoneScreensHeight.iPhone_12ProMax_13ProMax.rawValue:
            return 16
        default:
            return 16
        }
    }

    
}
