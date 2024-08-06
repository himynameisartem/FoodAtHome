//
//  CategoryDetailsViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsDisplayLogic: AnyObject {
    func displayData(viewModel: CategoryDetails.ShowDetails.ViewModel)
}

class CategoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var foodListTableView: UITableView!
        
    var interactor: CategoryDetailsBusinessLogic?
    var router: (NSObjectProtocol & CategoryDetailsRoutingLogic)?
    
    var food: [CategoryDetails.ShowDetails.ViewModel.DisplayedDetails] = []
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let header = TestView(frame: CGRect(x: 0, y: 0,
                                            width: view.frame.size.width, height: view.frame.size.width))
        
        foodListTableView.tableHeaderView = header
        
        foodListTableView.register(UINib(nibName: "CategoryDetailsFoodCell", bundle: nil), forCellReuseIdentifier: "CategoryDetailsFoodCell")
  
        foodListTableView.delegate = self
        foodListTableView.dataSource = self
        foodListTableView.tintColor = .blue
        getFoodDetails()

    }
    
    private func getFoodDetails() {
        let request = CategoryDetails.ShowDetails.Request()
        interactor?.makeRequest(request: request)
    }
}

extension CategoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailsFoodCell", for: indexPath) as! CategoryDetailsFoodCell
        
        cell.foodImageView.image = UIImage(named: "Absinthe")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (view.frame.width - 30) / 3.55 + 20
    }
    
}

extension CategoryDetailsViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let header = foodListTableView.tableHeaderView as? CategoryDetailsHeaderView else { return }
//        header.scrollViewDidScroll(scrollView: foodListTableView)
//    }
    
}

extension CategoryDetailsViewController: CategoryDetailsDisplayLogic {
    
    func displayData(viewModel: CategoryDetails.ShowDetails.ViewModel) {
        food = viewModel.displayedDetails
    }
}
