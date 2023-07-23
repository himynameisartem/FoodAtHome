//
//  MyFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.05.2022.
//

import UIKit
import Popover
import RealmSwift

class MyFoodViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let localRealm = try! Realm()
    
    let alert = AlertView()
    var unit = String()
    var months = String()
    var days = String()
    
    let wallpapers: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wallpapers")
        view.contentMode = .scaleAspectFit
        view.alpha = 0.2
        return view
    }()
    
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
    
    let tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()
    
    var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cv
    }()
    
    var foodOnTheShelf: UICollectionView = {
        let layuot = UICollectionViewFlowLayout()
        layuot.scrollDirection = .vertical
        layuot.minimumLineSpacing = 10
        layuot.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layuot)
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 15)
        return cv
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        foodOnTheShelf.reloadData()
        view.reloadInputViews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFood()
        
        picker.delegate = self
        consumePicker.delegate = self
        foodOnTheShelf.delegate = self
        foodOnTheShelf.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        createNavigationItem()
        createCollectionViews()
        
        view.addSubview(wallpapers)
        view.backgroundColor = .systemGray5
        
        navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.tintColor = .black
        
        wallpapers.frame = view.bounds
        
    }

    func loadFood() {
        
        foodRealmArra = localRealm.objects(FoodRealm.self)
        
    }
    
    //MARK: - Create Views
    
    private func createNavigationItem() {
        
        let navView = UIView()
        let navTitle = UILabel()
        
        navView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 350, height: 100))
        
        navView.addSubview(navTitle)
        
        navTitle.translatesAutoresizingMaskIntoConstraints = false
        navTitle.text = "FOOD AT HOME"
        navTitle.font = UIFont(name: "Inter-Light", size: 18)
        
        NSLayoutConstraint.activate([
            
            navTitle.topAnchor.constraint(equalTo: navView.topAnchor, constant: 5),
            navTitle.leadingAnchor.constraint(equalTo: navView.leadingAnchor),
            navTitle.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: -(view.frame.width / 1.7)),
            navTitle.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: -5)
            
        ])
        navigationItem.titleView = navView
    }
    
    private func createCollectionViews() {
        
        view.addSubview(foodOnTheShelf)
        view.addSubview(categoriesCollectionView)
        
        foodOnTheShelf.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: "foodCell")
        foodOnTheShelf.register(AddCollectionViewCell.self, forCellWithReuseIdentifier: "addCell")
        categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.layer.cornerRadius = 10
        categoriesCollectionView.backgroundColor = .none

        foodOnTheShelf.translatesAutoresizingMaskIntoConstraints = false
        foodOnTheShelf.backgroundColor = .none
        foodOnTheShelf.layer.cornerRadius = 10
        foodOnTheShelf.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            
            categoriesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 140),

            foodOnTheShelf.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor),
            foodOnTheShelf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            foodOnTheShelf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            foodOnTheShelf.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == foodOnTheShelf{
            return foodRealmArra.count + 1
        } else {
            return foodListArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == foodOnTheShelf {
            
        if indexPath.row != foodRealmArra.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
            cell.layer.cornerRadius = 10

//            var daysInterval = DateComponents()
//            let currentDate = Date()
//            var differenceOfDays = Int()
//
//            if let toDate = test[indexPath.row].expirationDate {
//            daysInterval = Calendar.current.dateComponents([.day], from: currentDate, to: toDate)
//                differenceOfDays = daysInterval.day.unsafelyUnwrapped
                
//                if differenceOfDays < 4 {
//                    cell.attentionView.isHidden = false
//                    cell.attentionView.tintColor = .orange
//                }
//                if differenceOfDays <= 1 {
//                    cell.attentionView.isHidden = false
//                    cell.attentionView.tintColor = .red
//                }
//            }
            
//            cell.foodImage.image = UIImage(named: test[indexPath.row].name)
//            cell.foodName.text = test[indexPath.row].name
            
            cell.foodImage.image = UIImage(named: foodRealmArra[indexPath.row].name)
            cell.foodName.text = foodRealmArra[indexPath.row].name
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCollectionViewCell

            cell.addButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        return cell
            
        } else {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            
            cell.categoryImage.image = UIImage(named: foodListArray[indexPath.row])
            cell.categoryName.text = foodListArray[indexPath.row]
            cell.backgroundImage.image = UIImage(named: "backgroundImage")
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == foodOnTheShelf {
        
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
        
        if collectionView == foodOnTheShelf {
        if indexPath.row != foodRealmArra.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
            cell.addGestureRecognizer(tap)
            let touch = tap.location(in: collectionView.cellForItem(at: indexPath))

            var touchType = CGFloat()
            let popover = Popover()

            if touch.y * (-1) < view.frame.height - (view.frame.height / 3) {
                touchType = touch.y * (-1) + cell.frame.height

            } else {
                touchType = touch.y * (-1)
                popover.popoverType = .up
            }
                        
            let startPoint = CGPoint(x: cell.center.x + 20  , y: touchType )
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 100))
            
            popover.show(aView, point: startPoint)
            popOverMunuView(view: aView, indexPath: indexPath, popover: popover)
            
            }
        } else {
            
            let vc = CategoryListViewController()
            vc.imageName = foodListArray[indexPath.row]
            var categoryArray = [FoodRealm]()
            
            for i in foodRealmArra {

                switch i.type {
                case "vegetables":
                    if foodListArray[indexPath.row] == "Овощи" {
                    categoryArray.append(i)
                    }
                case "fruitsAndBerries":
                    if foodListArray[indexPath.row] == "Фрукты и ягоды" {
                    categoryArray.append(i)
                    }
                case "mushrooms":
                    if foodListArray[indexPath.row] == "Грибы" {
                    categoryArray.append(i)
                    }
                case "eggsAndDairyProducts":
                    if foodListArray[indexPath.row] == "Яйца и молочные продукты" {
                    categoryArray.append(i)
                    }
                case "meatProducts":
                    if foodListArray[indexPath.row] == "Мясные продукты" {
                    categoryArray.append(i)
                    }
                case "fishAndSeafood":
                    if foodListArray[indexPath.row] == "Рыба и морепродукты" {
                    categoryArray.append(i)
                    }
                case "nutsAndDriedFruits":
                    if foodListArray[indexPath.row] == "Орехи и сухофрукты" {
                    categoryArray.append(i)
                    }
                case "flourAndFlourProducts":
                    if foodListArray[indexPath.row] == "Мука и мучные изделия" {
                    categoryArray.append(i)
                    }
                case "cereals":
                    if foodListArray[indexPath.row] == "Крупы и каши" {
                    categoryArray.append(i)
                    }
                case "confectioneryAndSweets":
                    if foodListArray[indexPath.row] == "Кондитерские изделия, сладости" {
                    categoryArray.append(i)
                    }
                case "greensAndFlowers":
                    if foodListArray[indexPath.row] == "Зелень и цветы" {
                    categoryArray.append(i)
                    }
                case "spices":
                    if foodListArray[indexPath.row] == "Специи и пряности" {
                    categoryArray.append(i)
                    }
                case "additives":
                    if foodListArray[indexPath.row] == "Сырье и добавки" {
                    categoryArray.append(i)
                    }
                case "babyFood":
                    if foodListArray[indexPath.row] == "Детское питание" {
                    categoryArray.append(i)
                    }
                case "softDrinks":
                    if foodListArray[indexPath.row] == "Безалкогольные напитки" {
                    categoryArray.append(i)
                    }
                case "alcoholicDrinks":
                    if foodListArray[indexPath.row] == "Алкогольные напитки" {
                    categoryArray.append(i)
                    }
                default:
                    break
                }
            }
            vc.foodCategoryArray = categoryArray
            vc.modalTransitionStyle = .crossDissolve
            navigationController?.pushViewController(vc, animated: true)
            
        }
}
    
    //MARK: - Context Menu

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        if collectionView == foodOnTheShelf {


            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

                let edit = UIAction(title: "Изменить", image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in

                    self.alert.showAlert(viewController: self,
                                         image:  UIImage(named: foodRealmArra[indexPath.row].name)!,
                                         food: foodRealmArra[indexPath.row],
                                         picker: self.picker,
                                         consumePicker: self.consumePicker,
                                         unit: self.unit,
                                         currentWeigt: foodRealmArra[indexPath.row].weight,
                                         currentProductDate: foodRealmArra[indexPath.row].productionDate,
                                         currentExperationDate: foodRealmArra[indexPath.row].expirationDate,
                                         searchController: nil)
                }

                let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in

                    let item = foodRealmArra[indexPath.row]
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
        if pickerView == picker {
            return 1 }
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker {
            return pickerArray.count
        }
        if component == 0 {
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

// MARK: - PopOverMenu

    extension MyFoodViewController {

        func popOverMunuView(view: UIView, indexPath: IndexPath, popover: Popover) {
            
            var daysInterval = DateComponents()
            let currentDate = Date()
            
            var differenceOfDays = Float()
            var daysFromProductDate = Int()
            var daysFromCurrentDate = Int()
            
            var differenceInterval = DateComponents()
            
            if  let toDate = foodRealmArra[indexPath.row].expirationDate {
                
                var dayFromCurrentDate = DateComponents()
                
                daysInterval = Calendar.current.dateComponents([.month, .day], from: currentDate, to: toDate)
                
                if let fromDate = foodRealmArra[indexPath.row].productionDate{
                    
                    differenceInterval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
                    dayFromCurrentDate = Calendar.current.dateComponents([.day], from: fromDate, to: currentDate)
                    daysFromCurrentDate = dayFromCurrentDate.day.unsafelyUnwrapped
                    
                        if toDate >= currentDate {
                            daysFromProductDate = differenceInterval.day.unsafelyUnwrapped
                    }
                }
            }
            
            differenceOfDays = 1 - (((Float(daysFromCurrentDate) / Float(daysFromProductDate)) *  100) / 100)
            
            let name = UILabel()
            let mainStack: UIStackView = {
                let stack = UIStackView()
                stack.axis = .horizontal
                stack.spacing = 0
                stack.distribution = .fillEqually
                return stack
            }()

            let leftStack: UIStackView = {
                let stack = UIStackView()
                stack.axis = .vertical
                stack.spacing = 2
                stack.distribution = .fillEqually
                return stack
            }()

            let rightStack: UIStackView = {
                let stack = UIStackView()
                stack.axis = .vertical
                stack.spacing = 2
                stack.distribution = .fillEqually
                stack.alignment = .trailing
                return stack
            }()

            let weight = UILabel()
            let productionDateTitle = UILabel()
            let expirationDateTitle = UILabel()
            let daysLeftTitle = UILabel()

            let weightData = UILabel()
            let productionDate = UILabel()
            let expirationDate = UILabel()
            let daysLeft = UILabel()

            view.addSubview(name)
            view.addSubview(mainStack)

            mainStack.addArrangedSubview(leftStack)
            mainStack.addArrangedSubview(rightStack)

            leftStack.addArrangedSubview(weight)
            leftStack.addArrangedSubview(productionDateTitle)
            leftStack.addArrangedSubview(expirationDateTitle)
            leftStack.addArrangedSubview(daysLeftTitle)

            rightStack.addArrangedSubview(weightData)
            rightStack.addArrangedSubview(productionDate)
            rightStack.addArrangedSubview(expirationDate)
            rightStack.addArrangedSubview(daysLeft)

            mainStack.translatesAutoresizingMaskIntoConstraints = false

            name.numberOfLines = 2
            name.text = foodRealmArra[indexPath.row].name
            name.translatesAutoresizingMaskIntoConstraints = false
            name.font = UIFont(name: "Inter-Light", size: 12)
            name.textAlignment = .center

            weight.translatesAutoresizingMaskIntoConstraints = false
            weight.font = UIFont(name: "Inter-ExtraLight", size: 10)
            weight.text = "Вес: "

            productionDateTitle.translatesAutoresizingMaskIntoConstraints = false
            productionDateTitle.font = UIFont(name: "Inter-ExtraLight", size: 10)
            productionDateTitle.text = "Дата изготовления: "

            expirationDateTitle.translatesAutoresizingMaskIntoConstraints = false
            expirationDateTitle.font = UIFont(name: "Inter-ExtraLight", size: 10)
            expirationDateTitle.text = "Годен до: "

            daysLeftTitle.translatesAutoresizingMaskIntoConstraints = false
            daysLeftTitle.font = UIFont(name: "Inter-ExtraLight", size: 10)
            daysLeftTitle.text = "Осталось: "

            weightData.translatesAutoresizingMaskIntoConstraints = false
            weightData.font = UIFont(name: "Inter-ExtraLight", size: 10)
            weightData.text = foodRealmArra[indexPath.row].weight + " " + foodRealmArra[indexPath.row].unit

            productionDate.translatesAutoresizingMaskIntoConstraints = false
            productionDate.font = UIFont(name: "Inter-ExtraLight", size: 10)
            if let productDate = foodRealmArra[indexPath.row].productionDate {
                productionDate.text = formatter.string(from: productDate)
            } else {
                productionDate.text = "-"
            }
            

            expirationDate.translatesAutoresizingMaskIntoConstraints = false
            expirationDate.font = UIFont(name: "Inter-ExtraLight", size: 10)
            if let expDate = foodRealmArra[indexPath.row].expirationDate {
                    expirationDate.text = formatter.string(from: expDate)
            } else {
                expirationDate.text = "-"
            }

            daysLeft.translatesAutoresizingMaskIntoConstraints = false
            daysLeft.font = UIFont(name: "Inter-ExtraLight", size: 10)
            daysLeft.text = "\(daysInterval.month ?? 0) мес. и \(daysInterval.day ?? 0) д."
            
            let shapeView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let foreGroundLayer = CAShapeLayer()
            let backGroundLayer = CAShapeLayer()

            let center = CGPoint(x: shapeView.frame.height / 2, y: shapeView.frame.width / 2)
            let endAngle = (-CGFloat.pi / 2)
            let startAngle = 2 * CGFloat.pi + endAngle
            let circularPath = UIBezierPath(arcCenter: center, radius: 10, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            backGroundLayer.path = circularPath.cgPath
            backGroundLayer.lineWidth = 3
            backGroundLayer.strokeEnd = CGFloat(differenceOfDays)
            backGroundLayer.fillColor = .none
            backGroundLayer.strokeColor = UIColor.systemGray5.cgColor
            backGroundLayer.strokeEnd = 1
            
            foreGroundLayer.path = circularPath.cgPath
            foreGroundLayer.lineWidth = 3
            foreGroundLayer.strokeEnd = CGFloat(differenceOfDays)
            foreGroundLayer.fillColor = .none
            
            if foreGroundLayer.strokeEnd >= 0.5 {
                foreGroundLayer.strokeColor = UIColor.green.cgColor
            } else if foreGroundLayer.strokeEnd < 0.5 && foreGroundLayer.strokeEnd >= 0.2 {
                foreGroundLayer.strokeColor = UIColor.orange.cgColor
            } else {
                foreGroundLayer.strokeColor = UIColor.red.cgColor
            }
            
            foreGroundLayer.lineCap = .round
            
            shapeView.layer.addSublayer(backGroundLayer)
            shapeView.layer.addSublayer(foreGroundLayer)
            shapeView.isHidden = true
            
            view.addSubview(shapeView)
            
            if expirationDate.text != "-" {
                shapeView.isHidden = false
            }

            if popover.popoverType == .down {

            NSLayoutConstraint.activate([
                
                shapeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
                shapeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 3),
                shapeView.heightAnchor.constraint(equalToConstant: 20),
                shapeView.widthAnchor.constraint(equalToConstant: 20),

                name.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
                name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                name.trailingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: -15),
                name.heightAnchor.constraint(equalToConstant: 30),

                mainStack.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
                mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)

            ])
            } else {

                NSLayoutConstraint.activate([
                
                shapeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
                shapeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 3),
                shapeView.heightAnchor.constraint(equalToConstant: 20),
                shapeView.widthAnchor.constraint(equalToConstant: 20),

                name.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
                name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                name.trailingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: -15),
                name.heightAnchor.constraint(equalToConstant: 30),

                mainStack.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
                mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
                mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
                mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
                ])
                }
            }
    }


