//
//  CategoryDetailsViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsDisplayLogic: AnyObject {
    func displayCategoryData(viewModel: CategoryDetails.ShowCategory.ViewModel)
    func displayCellsData(viewModel: CategoryDetails.ShowFood.ViewModel)
}

class CategoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var foodListTableView: UITableView!
    
    var interactor: CategoryDetailsBusinessLogic?
    var router: (NSObjectProtocol & CategoryDetailsRoutingLogic & CategoryDetailsDataPassing)?
    
    var header = CategoryDetailsHeaderView()
    
    var foodCells: [CategoryDetails.ShowFood.ViewModel.DisplayedCells] = []
        
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
        setupUI()
        getFoodDetails()
        
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CategoryDetailsInteractor()
        let presenter = CategoryDetailsPresenter()
        let router = CategoryDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    private func getFoodDetails() {
        let requestCategory = CategoryDetails.ShowCategory.Request()
        interactor?.showCategory(request: requestCategory)
        let requestCells = CategoryDetails.ShowFood.Request()
        interactor?.showCells(request: requestCells)
    }
    
    private func setupUI() {
        header = CategoryDetailsHeaderView(frame: CGRect(x: 0, y: 0,
                                            width: view.frame.size.width, height: view.frame.size.width / 1.2))
        foodListTableView.tableHeaderView = header
        foodListTableView.register(UINib(nibName: "CategoryDetailsFoodCell", bundle: nil), forCellReuseIdentifier: "CategoryDetailsFoodCell")
        foodListTableView.delegate = self
        foodListTableView.dataSource = self
    }
}

extension CategoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailsFoodCell", for: indexPath) as! CategoryDetailsFoodCell
        let viewModel = foodCells[indexPath.row]
        cell.configure(viewModel: viewModel)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (view.frame.width - 30) / 3.55 + 20
    }
    
}

extension CategoryDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = foodListTableView.tableHeaderView as? CategoryDetailsHeaderView else { return }
        header.scrollViewDidScroll(scrollView: foodListTableView)
    }
}

extension CategoryDetailsViewController: CategoryDetailsDisplayLogic {
    
    func displayCategoryData(viewModel: CategoryDetails.ShowCategory.ViewModel) {
        header.categoryNameLabel.text = viewModel.displayedCategory.categoryName
        header.imageView.image = UIImage(named: viewModel.displayedCategory.categoryImage)
    }
    
    func displayCellsData(viewModel: CategoryDetails.ShowFood.ViewModel) {
        foodCells = viewModel.displayedCells
    }
}
