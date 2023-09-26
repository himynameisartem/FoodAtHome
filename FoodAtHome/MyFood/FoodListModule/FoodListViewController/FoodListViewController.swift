//
//  FoodListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 28.05.2022.
//

import UIKit
import RealmSwift

class FoodListViewController: UIViewController {

    weak var delegate: AddAndChangeClosedViewDelegate?
    
    let localRealm = try! Realm()
    var foodList = [FoodRealm]()
    var filteredFoodList = [FoodRealm]()
        
    var presenter: FoodListPresenterProtocol!
    private let configurator: FoodListConfiguratorProtocol = FoodListConfigurator()
            
    private var wallpapers: UIImageView!
    private var categoriesListCollectionView: UICollectionView!
    private var categoriesListCollectionViewConstraint = NSLayoutConstraint()
    private var foodListTableView: UITableView!
    private var searchButton: UIBarButtonItem!
    private var searcController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searcController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searcController.isActive && !searchBarIsEmpty
    }
    
    private var openAnimation = true
    private var cellWhidth = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
                
        configurator.configure(with: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - SetupUI

extension FoodListViewController {
    
    private func setupUI() {
        
        navigationController?.navigationBar.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = true
        
        view.backgroundColor = .systemGray5
        
        wallpapers = UIImageView(image: UIImage(named: "wallpapers"))
        wallpapers.contentMode = .scaleAspectFill
        wallpapers.alpha = 0.2
        wallpapers.frame = view.bounds
        view.addSubview(wallpapers)
        
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
        searcController.searchBar.placeholder = "Search".localized()
        searcController.searchBar.setValue("Cancel".localized(), forKey: "cancelButtonText")
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
        
        openAnimation = true
        foodListTableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        foodListTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let categoryFont = UIFont(name: "Inter-SemiBold", size: 24)
        let categoryAttributes = [NSAttributedString.Key.font : categoryFont as Any]
        let categoryWidth = foodCatigoriesList[indexPath.item].localized().size(withAttributes: categoryAttributes).width
        
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
    
    @objc func tappedSearch() {
        presenter.tappedSearch()
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
        cell.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addButtonTapped(sender: UIButton) {
                var food = [FoodRealm]()
                    if isFiltering {
                        food = filteredFoodList
                       } else {
                           food = foodList
                       }
        
        sender.showAnimation(for: .withColor) {
            self.presenter.showAddFoodView(food[sender.tag], self)
            self.searcController.searchBar.resignFirstResponder()
        }
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if openAnimation {
            cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
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

        presenter.addAndChangeFood(food, viewController: self, closedView: delegate!.didRequestToclosedView)
        presenter.backToRoot()
        presenter.viewDidLoad()
    }
}

//MARK: - Extension UIPickerView

extension FoodListViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
