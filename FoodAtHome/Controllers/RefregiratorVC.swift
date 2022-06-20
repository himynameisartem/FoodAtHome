//
//  RefregiratorVC.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.05.2022.
//

import UIKit
import Popover

class RefregiratorVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "wallpapers")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.2
        return view
    }()
    
    var navView = UIView()
    var navTitle = UILabel()
    var refregiratorImage = UIImageView()
    var foodOnTheShelf: UICollectionView = {
        let layuot = UICollectionViewFlowLayout()
        layuot.scrollDirection = .vertical
        layuot.minimumLineSpacing = 30
        layuot.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layuot)
        return cv
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        foodOnTheShelf.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(refregiratorImage)
        
        foodOnTheShelf.delegate = self
        foodOnTheShelf.dataSource = self
        view.addSubview(backgroundImageView)
        makeFoodOnTheShelf()
        makeRefregiratorImage()
        foodOnTheShelf.register(FoodCell.self, forCellWithReuseIdentifier: "foodCell")
        foodOnTheShelf.register(AddCell.self, forCellWithReuseIdentifier: "addCell")
        createNavigationItem()
        
        navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.tintColor = .black

        
    }
    
    //MARK: - Create Views
    
    func createNavigationItem() {
        
        navView.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 300, height: 140))
        navView.addSubview(navTitle)
        navView.contentMode = .center
        navTitle.contentMode = .center
        navTitle.textAlignment = .center
        navTitle.text = "ЕдаДома"
        navTitle.font = UIFont(name: "pobeda-bold", size: 60)
        navTitle.textColor = .darkGray
        navTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            navTitle.topAnchor.constraint(equalTo: navView.topAnchor, constant: 5),
            navTitle.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 5),
            navTitle.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: -5),
            navTitle.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: 15)
            
        ])
        
        navigationItem.titleView = navView
        
        
    }
    
    func makeRefregiratorImage() {
        
        refregiratorImage.translatesAutoresizingMaskIntoConstraints = false
        refregiratorImage.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        
        NSLayoutConstraint.activate([
            
            refregiratorImage.topAnchor.constraint(equalTo: view.topAnchor),
            refregiratorImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            refregiratorImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            refregiratorImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    func makeFoodOnTheShelf() {
        
        view.addSubview(foodOnTheShelf)

        foodOnTheShelf.translatesAutoresizingMaskIntoConstraints = false
        foodOnTheShelf.backgroundColor = .clear
        foodOnTheShelf.layer.cornerRadius = 10
        foodOnTheShelf.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            foodOnTheShelf.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            foodOnTheShelf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            foodOnTheShelf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            foodOnTheShelf.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return test.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row != test.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCell
            
            cell.addSubview(cell.foodImage)
            cell.addSubview(cell.foodName)
            cell.foodName.translatesAutoresizingMaskIntoConstraints = false
            cell.foodImage.translatesAutoresizingMaskIntoConstraints = false
            cell.foodImage.contentMode = .scaleAspectFit
            cell.foodImage.backgroundColor = .white
            cell.backgroundColor = .white
            
            DispatchQueue.main.async {
                cell.foodImage.layer.cornerRadius = 10
                cell.foodImage.clipsToBounds = true
                cell.layer.cornerRadius = 10
            }
            
            cell.layer.borderWidth = 1.7
            cell.layer.borderColor = CGColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)
            
            cell.foodImage.image = UIImage(named: test[indexPath.row].name)
            cell.foodName.text = test[indexPath.row].name
            cell.foodName.font = UIFont(name: "pobeda-bold", size: 12)
            cell.foodName.textAlignment = .center
            cell.foodName.numberOfLines = 0
            
            NSLayoutConstraint.activate([
                
                cell.foodImage.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0),
                cell.foodImage.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0),
                cell.foodImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0),
                cell.foodName.topAnchor.constraint(equalTo: cell.foodImage.bottomAnchor, constant: 0),
                cell.foodName.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5),
                cell.foodName.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5),
                cell.foodName.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0),
                cell.foodName.heightAnchor.constraint(equalToConstant: 40)
                
                
            ])
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddCell

        cell.addSubview(cell.foodImage)
        cell.foodImage.translatesAutoresizingMaskIntoConstraints = false
        cell.foodImage.image = UIImage(systemName: "plus.viewfinder")
        cell.foodImage.tintColor = UIColor(red: 136 / 255, green: 136 / 255, blue: 136 / 255, alpha: 1)
        cell.foodImage.alpha = 1
        
        NSLayoutConstraint.activate([
            
            cell.foodImage.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15),
            cell.foodImage.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0),
            cell.foodImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0),
            cell.foodImage.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -15)
            
        ])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if view.frame.height < 700 && view.frame.height > 568 {
            return CGSize(width: 80, height: 110)
        }
        if view.frame.height == 568 {
            return CGSize(width: 65, height: 90)
        }
        return CGSize(width: 90, height: 120)
    }
    
    //MARK: Did Select
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != test.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCell
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
            let name = UILabel()
            
            popover.show(aView, point: startPoint)
            
            var daysInterval = DateComponents()
            let currentDate = Date()
            
            if  let toDate = test[indexPath.row].expirationDate {
             daysInterval = Calendar.current.dateComponents([.month, .day], from: currentDate, to: toDate)
            }
            
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
            
            aView.addSubview(name)
            aView.addSubview(mainStack)
            
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
            name.text = test[indexPath.row].name
            name.translatesAutoresizingMaskIntoConstraints = false
            name.font = UIFont(name: "pobeda-bold", size: 12)
            name.textAlignment = .center
            
            weight.translatesAutoresizingMaskIntoConstraints = false
            weight.font = .systemFont(ofSize: 10)
            weight.text = "Вес: "
            
            productionDateTitle.translatesAutoresizingMaskIntoConstraints = false
            productionDateTitle.font = .systemFont(ofSize: 10)
            productionDateTitle.text = "Дата изготовления: "
            
            expirationDateTitle.translatesAutoresizingMaskIntoConstraints = false
            expirationDateTitle.font = .systemFont(ofSize: 10)
            expirationDateTitle.text = "Годен до: "
            
            daysLeftTitle.translatesAutoresizingMaskIntoConstraints = false
            daysLeftTitle.font = .systemFont(ofSize: 10)
            daysLeftTitle.text = "Осталось: "
            
            weightData.translatesAutoresizingMaskIntoConstraints = false
            weightData.font = .systemFont(ofSize: 10)
            weightData.text = test[indexPath.row].weight + " " + test[indexPath.row].unit
            
            productionDate.translatesAutoresizingMaskIntoConstraints = false
            productionDate.font = .systemFont(ofSize: 10)
            if let productDate = test[indexPath.row].productionDate {
                productionDate.text = formatter.string(from: productDate)
            } else {
                productionDate.text = "-"
            }
            
            expirationDate.translatesAutoresizingMaskIntoConstraints = false
            expirationDate.font = .systemFont(ofSize: 10)
            if let expDate = test[indexPath.row].expirationDate {
                expirationDate.text = formatter.string(from: expDate)
            } else {
                expirationDate.text = "-"
            }
            
            daysLeft.translatesAutoresizingMaskIntoConstraints = false
            daysLeft.font = .systemFont(ofSize: 10)
            daysLeft.text = "\(daysInterval.month ?? 0) мес. и \(daysInterval.day ?? 0) д."
            
           
            if popover.popoverType == .down {
            
            NSLayoutConstraint.activate([
                
                name.topAnchor.constraint(equalTo: aView.topAnchor, constant: 15),
                name.leadingAnchor.constraint(equalTo: aView.leadingAnchor, constant: 5),
                name.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: -5),
                name.heightAnchor.constraint(equalToConstant: 30),
                
                mainStack.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
                mainStack.leadingAnchor.constraint(equalTo: aView.leadingAnchor, constant: 5),
                mainStack.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: -5),
                mainStack.bottomAnchor.constraint(equalTo: aView.bottomAnchor, constant: -5)
                
            ])
            } else {
                
                NSLayoutConstraint.activate([
                
                name.topAnchor.constraint(equalTo: aView.topAnchor, constant: 5),
                name.leadingAnchor.constraint(equalTo: aView.leadingAnchor, constant: 5),
                name.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: -5),
                name.heightAnchor.constraint(equalToConstant: 30),
                
                mainStack.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
                mainStack.leadingAnchor.constraint(equalTo: aView.leadingAnchor, constant: 5),
                mainStack.trailingAnchor.constraint(equalTo: aView.trailingAnchor, constant: -5),
                mainStack.bottomAnchor.constraint(equalTo: aView.bottomAnchor, constant: -15)
                ])
            }
        
            
            
        } else {
            let listVC = FoodListVC()
            listVC.modalPresentationStyle = .fullScreen
            self.viewDidAppear(true)
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    //MARK: - Context Menu
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.row != test.count {
            let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let edit = UIAction(title: "Изменить", image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, attributes: .disabled, state: .off) { _ in
                }
                let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    test.remove(at: indexPath.row)
                    self.viewDidAppear(true)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit, delete])
            }
            return config
        }
        return nil
    }
}


