//
//  MyFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

protocol MyFoodDisplayLogic: AnyObject {
    func displayCategories(viewModel: MyFood.ShowCategories.ViewModel)
    func displayMyFood(viewModel: MyFood.ShowMyFood.ViewModel)
    func displayFoodDetails(viewModel: MyFood.showDetailFood.ViewModel)
    func displayChangeFood(viewModel: MyFood.ChangeFood.ViewModel)
    func deleteFood()
    func removeAllFood()
}

class MyFoodViewController: UIViewController {
    
    @IBOutlet weak var titleBarLabel: UILabel!
    @IBOutlet weak var categoryMyFoodCollectionView: UICollectionView!
    @IBOutlet weak var myFoodCollectionView: UICollectionView!
    
    private var myFood: [MyFood.ShowMyFood.ViewModel.DisplayedMyFood] = []
    private var categories: [MyFood.ShowCategories.ViewModel.DiplayedCategories] = []
    private var foodDetails: MyFood.showDetailFood.ViewModel.DiplayedDetails?
    
    var interactor: MyFoodBusinessLogic?
    var router: (NSObjectProtocol & MyFoodRoutingLogic & MyFoodDataPassing)?
    
    private var addFoodMenu = AddFoodMenu()
    
    private var categoryMyFoodCollectionAnimationIsComlete = false
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        getMyFood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationBarSetup()
        setupCollectionViewCells()
        getCategories()
    }
    
    @IBAction func deleteFoodTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete All Products?".localized(), message: "This action will delete all your products, are you sure you want to continue?".localized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { _ in
            let request = MyFood.RemoveAllFood.Request()
            self.interactor?.removeAllFood(request: request)
        }
        let noAction = UIAlertAction(title: "No".localized(), style: .cancel)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func shareFoodTapped(_ sender: UIBarButtonItem) {
        print(#function)
    }
    
    // MARK: Setup
    
    private func navigationBarSetup() {
        let x = -(view.frame.width / 2) + 10
        let y = view.frame.origin.y - ((navigationController?.navigationBar.frame.height ?? 0) / 2)
        let height = navigationController?.navigationBar.frame.height ?? 0
        let width = view.frame.width / 2
        titleBarLabel.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func setup() {
        let viewController = self
        let interactor = MyFoodInteractor()
        let presenter = MyFoodPresenter()
        let router = MyFoodRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setupCollectionViewCells() {
        categoryMyFoodCollectionView.register(UINib(nibName: "CategoryMyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryMyFoodCell")
        myFoodCollectionView.register(UINib(nibName: "MyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myFoodCell")
        myFoodCollectionView.register(UINib(nibName: "AddMyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addMyFoodCell")
    }
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    private func getMyFood() {
        let request = MyFood.ShowMyFood.Request()
        interactor?.showMyFood(request: request)
    }
    
    private func getCategories() {
        let request = MyFood.ShowCategories.Request()
        interactor?.showCategories(request: request)
    }
    
    private func getDetailsFood(at index: Int) {
        let request = MyFood.showDetailFood.Request()
        interactor?.showDetailsFood(request: request, at: index)
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MyFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryMyFoodCollectionView {
            return categories.count
        } else {
            return myFood.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryMyFoodCollectionView {
            let categoryMyFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryMyFoodCell", for: indexPath) as! CategoryMyFoodCollectionViewCell
            let categoryMyFoodViewModel = categories[indexPath.row]
            categoryMyFoodCell.setData(viewModel: categoryMyFoodViewModel)
            return categoryMyFoodCell
        } else {
            if indexPath.row != myFood.count {
                let myFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myFoodCell", for: indexPath) as! MyFoodCollectionViewCell
                let myFoodViewModel = myFood[indexPath.row]
                myFoodCell.setData(viewModel: myFoodViewModel)
                return myFoodCell
            } else {
                let addMyFoodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addMyFoodCell", for: indexPath) as! AddMyFoodCollectionViewCell
                addMyFoodCell.buttonAction = { [weak self] in
                    addMyFoodCell.addFoodButton.showAnimation(for: .withColor) {
                        self?.performSegue(withIdentifier: "ChoiseFood", sender: nil)
                    }
                }
                return addMyFoodCell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryMyFoodCollectionView {
            let width = (view.frame.width - 10) / 2
            let height = width / 1.7
            collectionView.heightAnchor.constraint(equalToConstant: height + 10).isActive = true
            return CGSize(width: width, height: height)
        } else {
            let width = (view.frame.width - 50) / 4
            let height = width * 1.5
            return CGSize(width: width, height: height)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if collectionView == myFoodCollectionView {
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { action in
                let changeFood = UIAction(title: "Edit".localized()) { action in
                    let request = MyFood.ChangeFood.Request(indexPath: indexPath.row)
                    self.interactor?.showChangeFoodMenu(request: request)
                }
                let deleteFood = UIAction(title: "Delete".localized(), attributes: .destructive) { action in
                    let request = MyFood.DeleteFood.Request(indexPath: indexPath)
                    self.interactor?.deleteFood(request: request)
                }
                return UIMenu(title: "", children: [changeFood, deleteFood])
            }
            return configuration
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryMyFoodCollectionView {
            collectionView.cellForItem(at: indexPath)?.showAnimation(for: .withoutColor, {
                self.performSegue(withIdentifier: "CategoryDetails", sender: nil)
            })
        } else {
            if indexPath.row < myFood.count {
                getDetailsFood(at: indexPath.row)
            }
        }
    }
    
    // MARK: Animation
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !categoryMyFoodCollectionAnimationIsComlete {
            if collectionView == categoryMyFoodCollectionView {
                cell.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
                UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row)) {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }
            } else {
                cell.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    cell.alpha = 1
                } completion: { done in
                    self.categoryMyFoodCollectionAnimationIsComlete = true
                }
            }
        }
    }
}

// MARK: - MyFoodDisplayLogic

extension MyFoodViewController: MyFoodDisplayLogic {
    
    func displayCategories(viewModel: MyFood.ShowCategories.ViewModel) {
        categories = viewModel.displayedCategories
    }
    
    func displayMyFood(viewModel: MyFood.ShowMyFood.ViewModel) {
        myFood = viewModel.displayedMyFood
        myFoodCollectionView.reloadData()
    }
    
    func displayFoodDetails(viewModel: MyFood.showDetailFood.ViewModel) {
        let myFoodDetailsPopupMenu = Bundle.main.loadNibNamed("MyFoodDetailsPopupMenu",
                                                              owner: MyFoodViewController.self)?.first as! MyFoodDetailsPopupMenu
        myFoodDetailsPopupMenu.openPopUpMenu(for: self.view, with: myFoodCollectionView)
        myFoodDetailsPopupMenu.configure(viewModel: viewModel.DiplayedDetails)
    }
    
    func displayChangeFood(viewModel: MyFood.ChangeFood.ViewModel) {
        addFoodMenu = Bundle.main.loadNibNamed("AddFoodMenu", owner: ChoiseFoodViewController.self)?.first as! AddFoodMenu
        addFoodMenu.configure(from: viewModel.food)
        addFoodMenu.showAddFoodMenu()
        addFoodMenu.delegate = self
    }
    
    func deleteFood() {
        getMyFood()
    }
    
    func removeAllFood() {
        getMyFood()
    }
}

//MARK: - AddFoodMenuDelegate

extension MyFoodViewController: AddFoodMenuDelegate {
    func didCloseAddFood() {
        DispatchQueue.main.async{
            self.getMyFood()
        }
    }
}
