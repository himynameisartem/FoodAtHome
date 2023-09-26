//
//  CategoryListViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 17.07.2022.
//


import UIKit

class CategoryListViewController: UIViewController {
    
    private var openAnimation = true

    private var categoryListTableView: UITableView!
    private var wallpapers: UIImageView!
    private var backButton: UIButton!
    private var headerView = StretchyTableHeaderView()
    
    var presenter: CategoryFoodPresenterProtocol!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupUI()
        setupConstraint()
    }
    
    override func viewWillLayoutSubviews() {
        headerView.gradientLayer.frame = headerView.gradientView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
}

//MARK: - Setup UI

extension CategoryListViewController {
    
    private func setupUI() {
                
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .systemGray5
        
        wallpapers = UIImageView(image: UIImage(named: "wallpapers"))
        wallpapers.contentMode = .scaleAspectFill
        wallpapers.alpha = 0.2
        wallpapers.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wallpapers)
        
        backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        backButton.layer.cornerRadius = 20
        backButton.backgroundColor = .systemGray4
        backButton.tintColor = .systemGray
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: view.frame.height / 3)
        
        categoryListTableView = UITableView()
        categoryListTableView.backgroundColor = .clear
        categoryListTableView.contentInsetAdjustmentBehavior = .never
        categoryListTableView.frame = view.bounds
        categoryListTableView.delegate = self
        categoryListTableView.dataSource = self
        categoryListTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        categoryListTableView.register(CategoryListTableViewCell.self, forCellReuseIdentifier: "categoryListCell")
        categoryListTableView.separatorStyle = .none
        categoryListTableView.showsVerticalScrollIndicator = false
        view.addSubview(categoryListTableView)
        categoryListTableView.tableHeaderView = headerView
        view.addSubview(backButton)

    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            
            wallpapers.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5),
            wallpapers.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wallpapers.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wallpapers.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),

            
        ])

    }
}

//MARK: - TableView DataSource

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.foodCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath) as! CategoryListTableViewCell
        
        guard let food = presenter.getFood(at: indexPath) else { return cell }
        cell.configure(food)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if openAnimation {
            cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row)) {
                cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
            } completion: { done in
                if done {
                    self.openAnimation = false
                }
            }
        }
    }
    
}

//MARK: - UIScrollViewDelegate

extension CategoryListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView = self.categoryListTableView.tableHeaderView as! StretchyTableHeaderView
        headerView.scrollViewDidScroll(scrollView: scrollView)
    }
}

//MARK: - CategoryFoodProtocol

extension CategoryListViewController: CategoryFoodViewProtocol {
    func setImage(_ imageName: String) {
        headerView.imageView.image = UIImage(named: imageName)
    }
    
    func setName(_ categoryName: String) {
        headerView.categoryName.text = categoryName
    }
}

//MARK: - BackButton Action

extension CategoryListViewController {
    
    @objc func backButtonTapped(sender: UIButton) {
        sender.showAnimation(for: .withoutColor) {
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.navigationBar.isHidden = false
        }
    }
}

