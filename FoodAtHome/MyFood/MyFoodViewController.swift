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
}

class MyFoodViewController: UIViewController {
    
    private var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    var myFood: [MyFood.ShowMyFood.ViewModel.DisplayedMyFood] = []
    var categories: [MyFood.ShowCategories.ViewModel.DiplayedCategories] = []
    
    var interactor: MyFoodBusinessLogic?
    var router: (NSObjectProtocol & MyFoodRoutingLogic & MyFoodDataPassing)?
    
    private var categoryMyFoodCollectionAnimationIsComlete = false
    //    private let myFoodDetailsPopupMenu = Bundle.main.loadNibNamed("MyFoodDetailsPopupMenu", owner: MyFoodViewController.self)?.first as! MyFoodDetailsPopupMenu
    //    private var closePopupMenuGesture = UITapGestureRecognizer()
    //    private let dimmingPopupMenuView = UIView()
    
    @IBOutlet weak var categoryMyFoodCollectionView: UICollectionView!
    @IBOutlet weak var myFoodCollectionView: UICollectionView!
    
    
    // MARK: Setup
    
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
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        getMyFood()
        getCategories()
        setNib()
        settings()
    }
    
    private func getMyFood() {
        let request = MyFood.ShowMyFood.Request()
        interactor?.showMyFood(request: request)
    }
    
    private func getCategories() {
        let request = MyFood.ShowCategories.Request()
        interactor?.showCategories(request: request)
    }
    
    private func setNib() {
        categoryMyFoodCollectionView.register(UINib(nibName: "CategoryMyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryMyFoodCell")
        myFoodCollectionView.register(UINib(nibName: "MyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myFoodCell")
        myFoodCollectionView.register(UINib(nibName: "AddMyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addMyFoodCell")
    }
    
    private func settings() {
        //        closePopupMenuGesture.addTarget(self, action: #selector(closeDetailView))
        //
        //        dimmingPopupMenuView.backgroundColor = .black
        //        dimmingPopupMenuView.alpha = 0
        //        dimmingPopupMenuView.isUserInteractionEnabled = true
        //        dimmingPopupMenuView.frame = view.bounds
    }
    
    
    
    @objc private func closeDetailView() {
        //        guard let window = window else { return }
        //        myFoodDetailsPopupMenu.removeFromSuperview()
        //        window.removeGestureRecognizer(closePopupMenuGesture)
        //        dimmingPopupMenuView.removeFromSuperview()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryMyFoodCollectionView {
            performSegue(withIdentifier: "CategoryDetails", sender: nil)
        }
        //        guard let window = window else { return }
        //        dimmingPopupMenuView.alpha = 0.5
        //        myFoodDetailsPopupMenu.setupPopUpMenu(for: view, tabBarController, with: collectionView, at: indexPath)
        //        window.addSubview(dimmingPopupMenuView)
        //        window.addSubview(myFoodDetailsPopupMenu)
        //        window.addGestureRecognizer(closePopupMenuGesture)
        
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


extension MyFoodViewController: MyFoodDisplayLogic {
    
    func displayCategories(viewModel: MyFood.ShowCategories.ViewModel) {
        categories = viewModel.displayedCategories
    }
    
    func displayMyFood(viewModel: MyFood.ShowMyFood.ViewModel) {
        myFood = viewModel.displayedMyFood
    }
}
