//
//  MyFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.05.2022.
//

import UIKit
import RealmSwift

class MyFoodViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let localRealm = try! Realm()
        
    var presenter: MyFoodPresenterProtocol!
    private let configurator: MyFoodConfiguratorProtocol = MyFoodConfigurator()
    
    private let gestureForClosePopup = UITapGestureRecognizer()
    private var wallpapers: UIImageView!
    private var categoriesCollectionView: UICollectionView!
    private var myFoodCollectionView: UICollectionView!
    private var navView: UIView!
    private var navTitle: UILabel!
    
    let alert = AlertView()
    var unit = String()
    var months = String()
    var days = String()
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        presenter.viewDidLoad()
        view.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        
        configurator.configure(with: self)
        presenter.viewDidLoad()
        
//        picker.delegate = self
//        consumePicker.delegate = self
    }
}

extension MyFoodViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .systemGray5
        
        navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.tintColor = .black
        
        wallpapers = UIImageView(image: UIImage(named: "wallpapers"))
        wallpapers.contentMode = .scaleAspectFit
        wallpapers.alpha = 0.2
        wallpapers.frame = view.bounds
        view.addSubview(wallpapers)
        
        navView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 100))
        navTitle = UILabel()
        navTitle.text = "ЕДА ДОМА"
        navTitle.translatesAutoresizingMaskIntoConstraints = false
        navTitle.font = UIFont(name: "Inter-Light", size: 18)
        navView.addSubview(navTitle)
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
        myFoodCollectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 15)
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
            
            navTitle.topAnchor.constraint(equalTo: navView.topAnchor, constant: 5),
            navTitle.leadingAnchor.constraint(equalTo: navView.leadingAnchor),
            navTitle.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: -(view.frame.width / 1.7)),
            navTitle.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: -5),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 140),
            
            myFoodCollectionView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor),
            myFoodCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            myFoodCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            myFoodCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
        ])
    }
}

extension MyFoodViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myFoodCollectionView{
            guard let count = presenter.myFoodCount else { return 1 }
            return count + 1
        } else {
            return foodListArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == myFoodCollectionView {
            if indexPath.row != presenter.myFoodCount {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
                guard let myFood = presenter.food(atIndex: indexPath) else { return cell }
                cell.configure(food: myFood)
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCollectionViewCell
            cell.addButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            cell.configure(at: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == myFoodCollectionView {
            
            if view.frame.height < 700 && view.frame.height > 568 {
                return CGSize(width: 80, height: 110)
            }
            if view.frame.height == 568 {
                return CGSize(width: 65, height: 90)
            }
            return CGSize(width: 90, height: 120)
        } else {
            return CGSize(width: 180, height: 120)
        }
    }
    
    //MARK: Did Select
    
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
    
    //MARK: - Context Menu
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if collectionView == myFoodCollectionView {
            
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                
                let item = self.presenter.myFood[indexPath.row]
                
                let edit = UIAction(title: "Изменить", image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    self.presenter.showChangeFoodMenu(for: self)
                    self.presenter.configureChangeFoodMenu(food: item)
                    //                    self.alert.showAlert(viewController: self,
                    //                                         image:  UIImage(named: item.name)!,
                    //                                         food: item,
                    //                                         picker: self.picker,
                    //                                         consumePicker: self.consumePicker,
                    //                                         unit: self.unit,
                    //                                         currentWeigt: item.weight,
                    //                                         currentProductDate: item.productionDate,
                    //                                         currentExperationDate: item.expirationDate,
                    //                                         searchController: nil)
                }
                
                let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    
                    try! self.localRealm.write {
                        self.localRealm.delete(item)
                    }
                    
                    self.viewDidAppear(true)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline , children: [edit, delete])
            }
            return config
        }
        return nil
    }
}


//MARK: - UIPickerView

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

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return pickerArray[row]
        } else {
            if component == 0 {
                return monthsInterval[row] + "м"
            }
            return daysInterval[row] + "д"
        }
    }
    
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //        if pickerView == picker {
    //            alert.unit = pickerArray[row]
    //        }
    //        if component == 0 {
    //            alert.months = monthsInterval[row]
    //        }
    //        if component == 1 {
    //            alert.day = daysInterval[row]
    //        }
    //    }
}



// MARK: - TapGestureAction

extension MyFoodViewController {
    
    @objc func tapped(sender: UIButton) {
        
        sender.backgroundColor = .addButtonSelectColor
        let listVC = FoodListViewController()
        listVC.modalPresentationStyle = .fullScreen
        listVC.products = vegitables
        self.viewDidAppear(true)
        navigationController?.pushViewController(listVC, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15, execute: {
            sender.backgroundColor = .white
        })        
    }
}

extension MyFoodViewController: MyFoodViewProtocol {
    func reloadData() {            
        self.myFoodCollectionView.reloadData()
    }
    
    @objc func closePopup() {
        presenter.hidePopupMenu(from: self, and: gestureForClosePopup)
    }
}

extension MyFoodViewController: AddAndChangeFoodDelegate {
    func didAddNewFood(_ food: FoodRealm) {
        try! localRealm.write {
            localRealm.add(food)
        }
        
//        presenter.viewDidLoad()
//        self.myFoodCollectionView.reloadData()
        
        self.viewDidAppear(true)
        
    }

}