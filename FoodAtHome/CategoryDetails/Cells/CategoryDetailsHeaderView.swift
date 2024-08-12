//
//  TestView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.07.2024.
//

import UIKit

class CategoryDetailsHeaderView: UIView {
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupUI()
    }
}

extension CategoryDetailsHeaderView {
    
    private func commonInit() {
        let bundle = Bundle.init(for: CategoryDetailsHeaderView.self)
        if let viewToAdd = bundle.loadNibNamed("CategoryDetailsHeaderView", owner: self),
           let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    private func setupUI() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func configure(viewModel: CategoryDetails.ShowCategory.ViewModel) {
        imageView.image = UIImage(named: viewModel.displayedCategory.categoryImage)
        categoryNameLabel.text = viewModel.displayedCategory.categoryName
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        heightAnchor.constraint(equalTo: heightAnchor).constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
