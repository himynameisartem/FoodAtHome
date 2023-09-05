//
//  MyFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.05.2022.
//

import UIKit
import RealmSwift

class MyFoodViewController: UIViewController {
    
    let localRealm = try! Realm()
    
    var presenter: MyFoodPresenterProtocol!
    private let configurator: MyFoodConfiguratorProtocol = MyFoodConfigurator()
    
    private let gestureForClosePopup = UITapGestureRecognizer()
    private var wallpapers: UIImageView!
    private var categoriesCollectionView: UICollectionView!
    private var myFoodCollectionView: UICollectionView!
    private var navView: UIView!
    private var navTitle: UILabel!
    private var removeAll: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        configurator.configure(with: self)
        presenter.viewDidLoad()
    }
}

//MARK: - SetupUI

extension MyFoodViewController {
    
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
        removeAll = UIButton()
        removeAll.translatesAutoresizingMaskIntoConstraints = false
        removeAll.setImage(UIImage(systemName: "trash"), for: .normal)
        removeAll.addTarget(self, action: #selector(removeAllButtonTapped), for: .touchUpInside)
        removeAll.contentMode = .center
        navView.addSubview(removeAll)

        navigationItem.titleView = navView
        
        let layoutCategoriesCollectionView = UICollectionViewFlowLayout()
        layoutCategoriesCollectionView.scrollDirection = .horizontal
        layoutCategoriesCollectionView.minimumLineSpacing = 10
        layoutCategoriesCollectionView.minimumInteritemSpacing = 0
        categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutCategoriesCollectionView)
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.layer.cornerRadius = 10
        categoriesCollectionView.backgroundColor = .none
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        view.addSubview(categoriesCollectionView)
        
        let layuotMyFoodCollectionView = UICollectionViewFlowLayout()
        layuotMyFoodCollectionView.scrollDirection = .vertical
        layuotMyFoodCollectionView.minimumLineSpacing = 10
        layuotMyFoodCollectionView.minimumInteritemSpacing = 0
        myFoodCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layuotMyFoodCollectionView)
        myFoodCollectionView.backgroundColor = .clear
        myFoodCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 40, right: 15)
        myFoodCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myFoodCollectionView.backgroundColor = .none
        myFoodCollectionView.layer.cornerRadius = 10
        myFoodCollectionView.showsVerticalScrollIndicator = false
        myFoodCollectionView.delegate = self
        myFoodCollectionView.dataSource = self
        myFoodCollectionView.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "foodCell")
        myFoodCollectionView.register(AddCollectionViewCell.self, forCellWithReuseIdentifier: "addCell")
        view.addSubview(myFoodCollectionView)
        gestureForClosePopup.addTarget(self, action: #selector(closePopup))
    }
    
    private func setupConstraints() {
         
        NSLayoutConstraint.activate([
            
            navTitle.topAnchor.constraint(equalTo: navView.topAnchor),
            navTitle.leadingAnchor.constraint(equalTo: navView.leadingAnchor),
            navTitle.bottomAnchor.constraint(equalTo: navView.bottomAnchor),
            navTitle.widthAnchor.constraint(equalToConstant: view.frame.width),
            navTitle.trailingAnchor.constraint(equalTo: navView.trailingAnchor),
            
            removeAll.topAnchor.constraint(equalTo: navView.topAnchor),
            removeAll.centerYAnchor.constraint(equalTo: navTitle.centerYAnchor),
            removeAll.widthAnchor.constraint(equalToConstant: 20),
            removeAll.bottomAnchor.constraint(equalTo: navView.bottomAnchor),

            categoriesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: (view.frame.width / 3) + 5),
            
            myFoodCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor),
            myFoodCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            myFoodCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            myFoodCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        if UIDevice.current.name == "iPhone SE (1st generation)" {
            removeAll.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: view.frame.width - 40).isActive = true
        } else {
            removeAll.trailingAnchor.constraint(equalTo: navView.trailingAnchor).isActive = true
        }
        
    }
}

//MARK: - CollectionView DataSource

extension MyFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myFoodCollectionView{
            guard let count = presenter.myFoodCount else { return 1 }
            return count + 1
        } else {
            return foodCatigoriesList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myFoodCollectionView {
            if indexPath.row != presenter.myFoodCount {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell",
                                                              for: indexPath) as! FoodCollectionViewCell
                guard let myFood = presenter.food(atIndex: indexPath) else { return cell }
                cell.configure(food: myFood)
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell",
                                                          for: indexPath) as! AddCollectionViewCell
            cell.addButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                          for: indexPath) as! CategoryCollectionViewCell
            cell.configure(at: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == myFoodCollectionView {
            return CGSize(width: (view.frame.width / 4) - 15, height: (view.frame.width / 4 - 15) * 1.5)
        } else {
            return CGSize(width: view.frame.width / 2 - 15, height: (view.frame.width / 3 - 15))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == myFoodCollectionView {
            if indexPath.row != presenter.myFoodCount {
                guard let cell = collectionView.cellForItem(at: indexPath) else { return }
                guard let myFood = presenter.food(atIndex: indexPath) else { return }
                
                presenter.showPopupMenu(from: cell , at: indexPath, from: self)
                presenter.configurePopupMenu(food: myFood)
                tabBarController?.view.addGestureRecognizer(gestureForClosePopup)
            }
        } else {
            presenter.showCategoryFood(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if collectionView == myFoodCollectionView {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let item = self.presenter.myFood[indexPath.row]
                let edit = UIAction(title: "Edit".localized(),
                                    image: UIImage(systemName: "pencil"),
                                    identifier: nil,
                                    discoverabilityTitle: nil,
                                    state: .off) { _ in
                    self.presenter.showChangeFoodMenu(for: self)
                    self.presenter.configureChangeFoodMenu(food: item)
                }
                let delete = UIAction(title: "Delete".localized(),
                                      image: UIImage(systemName: "trash"),
                                      attributes: .destructive) { _ in
                    self.presenter.deleteFood(food: item)
                    self.presenter.viewDidLoad()
                    self.myFoodCollectionView.reloadData()
                }
                return UIMenu(title: "",
                              image: nil,
                              identifier: nil,
                              options: UIMenu.Options.displayInline ,
                              children: [edit, delete])
            }
            return config
        }
        return nil
    }
}

//MARK: - PickerView DataSource

extension MyFoodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

//MARK: RemoveAll Button Action

extension MyFoodViewController {
    
    @objc func removeAllButtonTapped(sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
            let alert = UIAlertController(title: "Delete All Products?".localized(), message: "This action will delete all your products, are you sure you want to continue?".localized(), preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { done in

                self.presenter.removeAllFood()
                self.presenter.viewDidLoad()
                self.myFoodCollectionView.reloadData()
            }
            
            let action = UIAlertAction(title: "Delete only expired", style: .default) { done in
                
                self.presenter.removeExpiredProducts(food: self.presenter.myFood)
                self.presenter.viewDidLoad()
                self.myFoodCollectionView.reloadData()
                
            }
            
            let cancelAction = UIAlertAction(title: "No".localized(), style: .default)
            alert.addAction(doneAction)
            alert.addAction(action)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
    }
}

// MARK: - TapGestureAction

extension MyFoodViewController {
    
    @objc func tapped(sender: UIButton) {
        
        sender.showAnimation(for: .withColor) {
            self.presenter.showFoodListViewController()
        }
    }
}

//MARK: - MyFoodViewProtocol

extension MyFoodViewController: MyFoodViewProtocol {
    func reloadData() {
        self.myFoodCollectionView.reloadData()
    }
    
    @objc func closePopup() {
        presenter.hidePopupMenu(from: self, and: gestureForClosePopup)
    }
}

//MARK: - AddAndChangeFoodDelegate

extension MyFoodViewController: AddAndChangeFoodDelegate {
    func didAddNewFood(_ food: FoodRealm) {
        presenter.changeFood(food, viewController: self)
        presenter.viewDidLoad()
        self.myFoodCollectionView.reloadData()
        
    }
}
