//
//  ChoiseFoodViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев
//

import UIKit

protocol ChoiseFoodDisplayLogic: AnyObject {
    func displayCategories(viewModel: ChoiseFoodModel.FetchCategories.ViewModel)
    func displayFood(viewModel: ChoiseFoodModel.FetchFood.ViewModel)
    func displayItem(viewModel: ChoiseFoodModel.FetchItem.ViewModel)
}

class ChoiseFoodViewController: UIViewController {
    
    var interactor: ChoiseFoodBusinessLogic?
    var router: (NSObjectProtocol & ChoiseFoodRoutingLogic & ChoiseFoodDataPassing)?
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let worker = ChoiseFoodWorker()
        let interactor = ChoiseFoodInteractor(worker: worker)
        let presenter = ChoiseFoodPresenter()
        let router = ChoiseFoodRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
        
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
        
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        configureNavigationView()
        configureCollectionView()
        getFoodList()
        configureTableView()
        configureDimmingView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    @IBOutlet weak var foodListTableView: UITableView!
    @IBOutlet weak var categoriesFoodCollectionView: UICollectionView!
    
    private let backButton = UIBarButtonItem()
    private let searchButton = UIBarButtonItem()
    private let searchController = UISearchController(searchResultsController: nil)
    private let hideSearchBarGesture = UITapGestureRecognizer()
    private var collectionViewHeightConstraint = NSLayoutConstraint()
    private var dimmingView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    private var isOpenAnimation = true
    private var categoriesName: [String] = []
    private var foodList: [ChoiseFoodModel.FetchFood.ViewModel.DispalyedFood] = []
    
    
    private func didTapAddFoodButtion(at indexPath: IndexPath) {
        let request = ChoiseFoodModel.FetchItem.Request(foodName: foodList[indexPath.row].name)
        interactor?.fetchItem(request: request)
        if self.tabBarController?.selectedIndex == 0 {
            router?.routeToAddShoppingList()
        } else if self.tabBarController?.selectedIndex == 1 {
            router?.routeToAddFood()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    private func didSelectCategoryItem(at indexPath: IndexPath) {
        let request = ChoiseFoodModel.FetchFood.Request(category: FoodType.allCases[indexPath.row], name: nil)
        interactor?.fetchFoodList(request: request)
    }
    
    private func getCategories() {
        let request = ChoiseFoodModel.FetchCategories.Request()
        interactor?.fetchCategories(request: request)
    }
    
    private func getFoodList() {
        guard let indexPath = categoriesFoodCollectionView.indexPathsForSelectedItems?.first else { return }
        let request = ChoiseFoodModel.FetchFood.Request(category: FoodType.allCases[indexPath.row], name: nil)
        interactor?.fetchFoodList(request: request)
    }
    
    private func hideSearchBar() {
        navigationItem.titleView = .none
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = searchButton
        view.removeGestureRecognizer(hideSearchBarGesture)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.collectionViewHeightConstraint.constant += 50
            self.categoriesFoodCollectionView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { done in
            UIView.animate(withDuration: 0.1) {
                self.getFoodList()
            }
        }
    }
    
    @objc private func searchButtonTapped(sender: UIBarButtonItem) {
        navigationItem.titleView = searchController.searchBar
        navigationItem.leftBarButtonItem = .none
        navigationItem.rightBarButtonItem = .none
        searchController.searchBar.becomeFirstResponder()
        hideSearchBarGesture.addTarget(self, action: #selector(tapForCloseSearchBar))
        view.addGestureRecognizer(hideSearchBarGesture)
        
        UIView.animate(withDuration: 0.1) {
            self.categoriesFoodCollectionView.alpha = 0
        } completion: { done in
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
                self.collectionViewHeightConstraint.constant -= 50
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func backButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func tapForCloseSearchBar() {
        hideSearchBar()
    }
    
    //MARK: - Configure Views
    
    private func configureDimmingView() {
        blurEffect = UIBlurEffect(style: .dark)
        dimmingView = UIVisualEffectView(frame: view.bounds)
        dimmingView.effect = blurEffect
        dimmingView.alpha = 0
    }
    
    private func configureNavigationView() {
        backButton.tintColor = .black
        backButton.image = UIImage(systemName: "chevron.backward")
        searchButton.tintColor = .black
        searchButton.image = UIImage(systemName: "magnifyingglass")
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = searchButton
        backButton.target = self
        backButton.action = #selector(backButtonTapped(sender:))
        searchButton.target = self
        searchButton.action = #selector(searchButtonTapped(sender:))
        configureSearchBar()
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configureSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.resignFirstResponder()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "Search".localized()
        searchController.searchBar.setValue("Cancel".localized(), forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .black
    }
    
    private func configureCollectionView() {
        let layoutCategoriesCollectionView = UICollectionViewFlowLayout()
        layoutCategoriesCollectionView.scrollDirection = .horizontal
        layoutCategoriesCollectionView.minimumInteritemSpacing = 20
        categoriesFoodCollectionView.delegate = self
        categoriesFoodCollectionView.dataSource = self
        categoriesFoodCollectionView.collectionViewLayout = layoutCategoriesCollectionView
        categoriesFoodCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        categoriesFoodCollectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "CategoriesCell")
        categoriesFoodCollectionView.bounces = true
        categoriesFoodCollectionView.selectItem(at: [0,0], animated: true, scrollPosition: [])
        collectionViewHeightConstraint = categoriesFoodCollectionView.heightAnchor.constraint(equalToConstant: 50)
        collectionViewHeightConstraint.isActive = true
        categoriesFoodCollectionView.clipsToBounds = true
    }
    
    private func configureTableView() {
        foodListTableView.delegate = self
        foodListTableView.dataSource = self
        foodListTableView.register(UINib(nibName: "FoodListTableViewCell", bundle: nil), forCellReuseIdentifier: "foodListCell")
    }
}

//MARK: - UISearchBarDelegate

extension ChoiseFoodViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let request = ChoiseFoodModel.FetchFood.Request(category: nil, name: searchController.searchBar.text)
        interactor?.fetchFoodList(request: request)
        isOpenAnimation = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}

//MARK: - UICollectionViewDelegate

extension ChoiseFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoriesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.configure(categoryNamme: categoriesName[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let categoryFont = UIFont(name: "Inter-SemiBold", size: 24)
        let categoryAttributes = [NSAttributedString.Key.font : categoryFont as Any]
        let categoryWidth = FoodType.allCases[indexPath.item].rawValue.localized().size(withAttributes: categoryAttributes).width
        
        return CGSize(width: categoryWidth,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        foodListTableView.scrollToRow(at: [0, 0], at: .top, animated: false)
        didSelectCategoryItem(at: indexPath)
    }
}

//MARK: - UITableViewDelegate

extension ChoiseFoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodListCell", for: indexPath) as! FoodListTableViewCell
        cell.configure(from: foodList[indexPath.row])
        cell.buttonAction = { [weak self] in
            cell.addFoodButton.showAnimation(for: .withColor) {
                self?.didTapAddFoodButtion(at: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.width / 3.9
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isOpenAnimation {
            cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
            } completion: { done in
                if done {
                    self.isOpenAnimation = false
                }
            }
        }
    }
}

//MARK: - UIViewControllerTransitioningDelegate

extension ChoiseFoodViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ChoiseFoodViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        var height: CGFloat = 350
        if self.navigationController?.tabBarController?.selectedIndex == 0 {
            height = 200
        } else if self.navigationController?.tabBarController?.selectedIndex == 1 {
            height = 350
        }
        trasitionAnimationForAddFoodVC(for: self, height: height, using: transitionContext, and: dimmingView)
    }
}

//MARK: - ChoiseFoodDisplayLogic

extension ChoiseFoodViewController: ChoiseFoodDisplayLogic {
    
    func displayCategories(viewModel: ChoiseFoodModel.FetchCategories.ViewModel) {
        categoriesName = viewModel.categoriesName
    }
    
    func displayFood(viewModel: ChoiseFoodModel.FetchFood.ViewModel) {
        foodList = viewModel.displayedFood
        isOpenAnimation = true
        foodListTableView.reloadData()
    }
    
    func displayItem(viewModel: ChoiseFoodModel.FetchItem.ViewModel) {}
}
