//
//  FoodListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.05.2022.
//

import UIKit
import RealmSwift

class FoodListViewController: UIViewController {

    let localRealm = try! Realm()
    
    var foodList = [FoodRealm]()
    var filteredFoodList = [FoodRealm]()
        
    var presenter: FoodListPresenterProtocol!
    private let configurator: FoodListConfiguratorProtocol = FoodListConfigurator()
            
    private var categoriesListCollectionView: UICollectionView!
    private var categoriesListCollectionViewConstraint = NSLayoutConstraint()
    private var foodListTableView: UITableView!
    private var searchButton: UIBarButtonItem!
    private var searcController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searcController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searcController.isActive && !searchBarIsEmpty
    }
    
    var time = true
    var cellWhidth = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
                
        configurator.configure(with: self)
        presenter.viewDidLoad()
        
        vcCheck = true
    }
}

//MARK: - SetupUI

extension FoodListViewController {
    
    private func setupUI() {
        
        view.backgroundColor = #colorLiteral(red: 0.9438247681, green: 0.9557064176, blue: 0.9554974437, alpha: 1)
        navigationController?.navigationBar.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
        
        searchButton = UIBarButtonItem()
        searchButton.image = UIImage(systemName: "magnifyingglass")
        searchButton.tintColor = .black
        searchButton.action = #selector(tappedSearch)
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.target = self
        
        searcController.resignFirstResponder()
        searcController.delegate = self
        searcController.searchBar.delegate = self
        searcController.searchResultsUpdater = self
        searcController.obscuresBackgroundDuringPresentation = false
        searcController.searchBar.placeholder = "Поиск"
        searcController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        definesPresentationContext = true
        
        let layoutCategoriesCollectionView = UICollectionViewFlowLayout()
        layoutCategoriesCollectionView.scrollDirection = .horizontal
        layoutCategoriesCollectionView.minimumInteritemSpacing = 20
        categoriesListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutCategoriesCollectionView)
        categoriesListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        categoriesListCollectionView.dataSource = self
        categoriesListCollectionView.delegate = self
        categoriesListCollectionView.backgroundColor = .none
        categoriesListCollectionView.bounces = false
        categoriesListCollectionView.showsHorizontalScrollIndicator = false
        categoriesListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesListCollectionView.selectItem(at: [0,0], animated: true, scrollPosition: [])
        categoriesListCollectionView.register(HorizontalMenuCollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalMenuCell")
        view.addSubview(categoriesListCollectionView)
        
        foodListTableView = UITableView()
        foodListTableView.register(DetailFoodCell.self, forCellReuseIdentifier: "detailFood")
        foodListTableView.separatorStyle = .none
        foodListTableView.delegate = self
        foodListTableView.dataSource = self
        foodListTableView.backgroundColor = .clear
        foodListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(foodListTableView)
    }
    
    func setupConstraints() {
        
        guard let item = categoriesListCollectionView else { return }
        categoriesListCollectionViewConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        view.addConstraint(categoriesListCollectionViewConstraint)
        
        NSLayoutConstraint.activate([
            
            categoriesListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            categoriesListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            categoriesListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            foodListTableView.topAnchor.constraint(equalTo: categoriesListCollectionView.bottomAnchor, constant: 5),
            foodListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -0.5),
            foodListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.5),
            foodListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    @objc func tappedSearch() {
        presenter.tappedSearch()
    }
}

//MARK: - UICollectionView

extension FoodListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        foodCatigoriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalMenuCell", for: indexPath) as! HorizontalMenuCollectionViewCell
                
        cell.configure(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        foodList = presenter.selectedCategories(at: indexPath)
        
        time = true
        foodListTableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        foodListTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let categoryFont = UIFont(name: "Inter-SemiBold", size: 24)
        let categoryAttributes = [NSAttributedString.Key.font : categoryFont as Any]
        let categoryWidth = foodCatigoriesList[indexPath.item].size(withAttributes: categoryAttributes).width
        
        return CGSize(width: categoryWidth,
                      height: collectionView.frame.height)
    }
}

//MARK: - Results SearchController

extension FoodListViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        presenter.updateSearchResults(for: searchController.searchBar.text!)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.hidesBackButton = false
        self.navigationItem.titleView = .none
        navigationItem.rightBarButtonItem = searchButton
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
            self.categoriesListCollectionViewConstraint.constant += 50
            self.view.layoutIfNeeded()
        }
        foodListTableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
}

//MARK: - UITableView

extension FoodListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredFoodList.count
        } else {
            return foodList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailFood", for: indexPath) as! DetailFoodCell
        cell.selectionStyle = .none
        
        var food = [FoodRealm]()
        if isFiltering {
            food = filteredFoodList
        } else {
            food = foodList
        }
        
        cell.configure(food[indexPath.row])
        cell.addSubview(cell.addButton)
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func tapped(sender: UIButton) {
                var food = [FoodRealm]()
                    if isFiltering {
                        food = filteredFoodList
                       } else {
                           food = foodList
                       }
        
        sender.showAnimation(for: .withColor) {
            self.presenter.showAddFoodView(food[sender.tag])
            self.searcController.searchBar.resignFirstResponder()
        }
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
    
        
//    @objc func tapped(sender: UIButton) {
//
//        print("asdasd")
//
//        let index = IndexPath(row: sender.tag, section: 0)
//        if sender.isTracking {
//            sender.backgroundColor = .addButtonSelectColor
//        }
//        else {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: {
//                sender.backgroundColor = .white
//            })
//        }
//
//        var food = [FoodRealm]()
//        if isFiltering {
//            food = filteredFoodList
//        } else {
//            food = foodList
//        }
//
//
//
//        searcController.searchBar.resignFirstResponder()
//    }
    
  
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(viewHeight: view.frame.height)
    }
    
    //MARK: - scrollViewDidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            foodListTableView.layer.borderWidth = 0.3
            foodListTableView.layer.borderColor = #colorLiteral(red: 0.34122473, green: 0.34122473, blue: 0.34122473, alpha: 0.3141556291)
        } else {
            foodListTableView.layer.borderWidth = 0.0
        }
    }
}

//MARK: - FoodListViewProtocol

extension FoodListViewController: FoodListViewProtocol {
    func reloadData() {
        foodListTableView.reloadData()
    }
    
    func dysplayFilteredFood(_ filteredFood: [FoodRealm]) {
        self.filteredFoodList = filteredFood
    }
    
    func showSearchBar() {
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
            self.categoriesListCollectionViewConstraint.constant -= 50
            self.view.layoutIfNeeded()
        }
    }
}

extension FoodListViewController: AddAndChangeFoodDelegate {
    func didAddNewFood(_ food: FoodRealm) {
        try! localRealm.write {
            localRealm.add(food)
        }
        
        presenter.backToRoot()
        presenter.viewDidLoad()
    }
}







//MARK: - Extension UIPickerView

extension FoodListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        if pickerView == picker {
//            return 1 }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == picker {
//            return pickerArray.count
//        }
//        if component == 0{
//            return monthsInterval.count
//        }
        return daysInterval.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == picker {
//            return pickerArray[row]
//        }
//        if component == 0 {
//            return monthsInterval[row] + "м"
//        }
//        return daysInterval[row] + "д"
        
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == picker {
//            alert.unit = pickerArray[row]
//        }
//        if component == 0 {
//            alert.months = monthsInterval[row]
//        }
//        if component == 1 {
//            alert.day = daysInterval[row]
//        }
    }
}



//MARK: - Detail Food Cell


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
