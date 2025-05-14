//
//  MyFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

protocol MyFoodDisplayLogic: AnyObject {
    func displayCategories(viewModel: MyFoodModel.FetchCategories.ViewModel)
    func displayFoodList(viewModel: MyFoodModel.FetchFoodList.ViewModel)
    func displayFoodDetails(viewModel: MyFoodModel.FetchFoodDetails.ViewModel)
    func displayEditingFood(viewModel: MyFoodModel.PrepareEditing.ViewModel)
    func displaySharedFood(viewModel: MyFoodModel.FetchSharedFood.ViewModel)
    func displayConfirmRemoveAllMyFood(viewModel: MyFoodModel.ConfirmRemoveAllMyFood.ViewModel)
    func didRemoveFoodItem(viewModel: MyFoodModel.DeleteFood.ViewModel)
    func didRemoveAllMyFood(viewModel: MyFoodModel.RemoveAllMyFood.ViewModel)
}

class MyFoodViewController: UIViewController {
    
    var interactor: MyFoodBusinessLogic?
    var router: (NSObjectProtocol & MyFoodRoutingLogic & MyFoodDataPassing)?
    
    
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MyFoodInteractor(worker: MyFoodWorker())
        let presenter = MyFoodPresenter(dateManager: DateManager())
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
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMyFood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureNavigationBar()
        setupCollectionViewCells()
        fetchCategories()
        setupActivitiIndicator()
        configureDimmingView()
    }
    
    @IBOutlet weak var titleBarLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var myFoodCollectionView: UICollectionView!
    
    private var myFood: [MyFoodModel.FetchFoodList.ViewModel.DisplayedMyFood] = []
    private var categories: [MyFoodModel.FetchCategories.ViewModel.DisplayedCategories] = []
    private var foodDetails: MyFoodModel.FetchFoodDetails.ViewModel.DisplayedDetails?
    private var dimmingView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    private var sharedActivitiIndicator: UIActivityIndicatorView!
    private var categoryMyFoodCollectionAnimationIsComlete = false
    
    
    @IBAction func didTapDeleteAllMyFoodButton(_ sender: Any) {
        let request = MyFoodModel.RemoveAllMyFood.Request()
        interactor?.removeAllMyFood(request: request)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let request = MyFoodModel.FetchSharedFood.Request()
        interactor?.fetchSharedFoodList(request: request)
    }
    
    private func fetchMyFood() {
        let request = MyFoodModel.FetchFoodList.Request()
        interactor?.fetchMyFood(request: request)
    }
    
    private func fetchCategories() {
        let request = MyFoodModel.FetchCategories.Request()
        interactor?.fetchCategories(request: request)
    }
    
    private func fetchDetailsFood(at indexPath: IndexPath) {
        let request = MyFoodModel.FetchFoodDetails.Request(indexPath: indexPath)
        interactor?.fetchFoodDetails(request: request)
    }
    
    private func handleEditAction(at indexPath: IndexPath) {
        let request = MyFoodModel.PrepareEditing.Request(indexPath: indexPath)
        interactor?.prepareEditingFood(request: request)
        router?.routeToAddFood(segue: nil)
    }
    
    private func handleDeleteAction(at indexPath: IndexPath) {
        let request = MyFoodModel.DeleteFood.Request(indexPath: indexPath)
        self.interactor?.deleteFood(request: request)
    }
    
    //MARK: Setup Views
    
    private func configureNavigationBar() {
        let x = -(view.frame.width / 2) + 10
        let y = view.frame.origin.y - ((navigationController?.navigationBar.frame.height ?? 0) / 2)
        let height = navigationController?.navigationBar.frame.height ?? 0
        let width = view.frame.width / 2
        titleBarLabel.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func configureDimmingView() {
        blurEffect = UIBlurEffect(style: .dark)
        dimmingView = UIVisualEffectView(frame: view.bounds)
        dimmingView.effect = blurEffect
        dimmingView.alpha = 0
    }
    
    func setupCollectionViewCells() {
        categoryCollectionView.register(UINib(nibName: "CategoryMyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryMyFoodCell")
        myFoodCollectionView.register(UINib(nibName: "MyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myFoodCell")
        myFoodCollectionView.register(UINib(nibName: "AddMyFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addMyFoodCell")
    }
    
    func setupActivitiIndicator() {
        sharedActivitiIndicator = UIActivityIndicatorView(frame: view.bounds)
        view.addSubview(sharedActivitiIndicator)
        sharedActivitiIndicator.center = view.center
        sharedActivitiIndicator.style = .large
        sharedActivitiIndicator.hidesWhenStopped = true
    }
}

//MARK: - UICollectionViewDelegate

extension MyFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else {
            return myFood.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
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
        if collectionView == categoryCollectionView {
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
                    self.handleEditAction(at: indexPath)
                }
                let deleteFood = UIAction(title: "Delete".localized(), attributes: .destructive) { action in
                    self.handleDeleteAction(at: indexPath)
                }
                return UIMenu(title: "", children: [changeFood, deleteFood])
            }
            return configuration
        } else {
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            collectionView.cellForItem(at: indexPath)?.showAnimation(for: .withoutColor, {
                self.performSegue(withIdentifier: "CategoryDetails", sender: nil)
            })
        } else {
            if indexPath.row < myFood.count {
                fetchDetailsFood(at: indexPath)
            }
        }
    }
    
    // MARK: CollectionView Will Display
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !categoryMyFoodCollectionAnimationIsComlete {
            if collectionView == categoryCollectionView {
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

//MARK: - UIViewControllerTransitioningDelegate

extension MyFoodViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension MyFoodViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let height: CGFloat = 350
        trasitionAnimationForAddFoodVC(for: self, height: height, using: transitionContext, and: dimmingView)
    }
}


// MARK: - MyFoodDisplayLogic

extension MyFoodViewController: MyFoodDisplayLogic {
    func displayCategories(viewModel: MyFoodModel.FetchCategories.ViewModel) {
        categories = viewModel.displayedCategories
    }
    
    func displayFoodList(viewModel: MyFoodModel.FetchFoodList.ViewModel) {
        myFood = viewModel.displayedMyFood
        myFoodCollectionView.reloadData()
    }
    
    func displayEditingFood(viewModel: MyFoodModel.PrepareEditing.ViewModel) {}
    
    func displayFoodDetails(viewModel: MyFoodModel.FetchFoodDetails.ViewModel) {
        guard let view = self.navigationController?.tabBarController?.view else { return }
        let myFoodDetailsPopupMenu = Bundle.main.loadNibNamed("MyFoodDetailsPopupMenu",
                                                              owner: MyFoodViewController.self)?.first as! MyFoodDetailsPopupMenu
        myFoodDetailsPopupMenu.openPopUpMenu(for: view, with: myFoodCollectionView)
        myFoodDetailsPopupMenu.configure(viewModel: viewModel.displayedDetails)
    }
    
    func didRemoveFoodItem(viewModel: MyFoodModel.DeleteFood.ViewModel) {
        fetchMyFood()
    }
    
    func didRemoveAllMyFood(viewModel: MyFoodModel.RemoveAllMyFood.ViewModel) {
        let alertController = UIAlertController(title: viewModel.alertTitle,
                                                message: viewModel.alertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: viewModel.confirmActionTitle, style: .destructive, handler: { _ in
            let request = MyFoodModel.ConfirmRemoveAllMyFood.Request()
            self.interactor?.confirmRemoveAllMyFood(request: request)
        }))
        alertController.addAction(UIAlertAction(title: viewModel.cancelActionTitle, style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func displayConfirmRemoveAllMyFood(viewModel: MyFoodModel.ConfirmRemoveAllMyFood.ViewModel) {
        if viewModel.isSuccess {
            self.fetchMyFood()
        }
    }
    
    func displaySharedFood(viewModel: MyFoodModel.FetchSharedFood.ViewModel) {
        sharedActivitiIndicator.startAnimating()
        let controller = UIActivityViewController(
            activityItems: [viewModel.foodList],
          applicationActivities: nil
        )
        DispatchQueue.main.async{
            self.present(controller, animated: true, completion: nil)
            if controller.isViewLoaded  {
                self.sharedActivitiIndicator.stopAnimating()
            }
        }
    }
}
