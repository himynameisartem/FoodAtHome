//
//  AddFoodMenu.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 18.09.2024.
//

import UIKit

class AddFoodMenu: UIView {
    
    private var dimmingView: UIVisualEffectView!
    private var blurEffect: UIVisualEffect!
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var productionDateLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var consumeUpLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var weightTypePickerView: UIPickerView!
    @IBOutlet weak var productionDateTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var consumeUpTextField: UITextField!
    @IBOutlet weak var addFoodButton: UIButton!
    @IBOutlet weak var stackViewContainer: UIStackView!
    @IBOutlet weak var labelsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showAddFoodMenu(for view: UIViewController) {
        guard let view = view.view else { return }
        
        let width = view.frame.width - 40
        let height = width * 1.7
        
        self.frame = CGRect(x: view.center.x - width / 2, y: -900, width: width, height: height)
        
        blurEffect = UIBlurEffect(style: .dark)
        dimmingView = UIVisualEffectView(frame: view.bounds)
        dimmingView.effect = blurEffect
        dimmingView.alpha = 0
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        
        setupUI()
        
        view.addSubview(dimmingView)
        view.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
        } completion: { done in
            UIView.animate(withDuration: 0.3) {
                self.frame = CGRect(x: view.center.x - width / 2, y: view.center.y - height / 2, width: width, height: height)
            }
        }
    }
    
    func setupUI() {
        weightLabel.text = "Weight:".localized()
        productionDateLabel.text = "Manufacturing Date:".localized()
        expirationDateLabel.text = "Expires on:".localized()
        consumeUpLabel.text = "Shelf Life:".localized()
        addFoodButton.setTitle("Add".localized(), for: .normal)
        
        while productionDateLabel.intrinsicContentSize.width > (self.frame.width / 2 - 20) {
            weightLabel.font = UIFont.systemFont(ofSize: productionDateLabel.font.pointSize - 1)
            productionDateLabel.font = UIFont.systemFont(ofSize: productionDateLabel.font.pointSize - 1)
            expirationDateLabel.font = UIFont.systemFont(ofSize: productionDateLabel.font.pointSize - 1)
            consumeUpLabel.font = UIFont.systemFont(ofSize: productionDateLabel.font.pointSize - 1)
        }
    }
    
    func configure(from food: FoodRealm) {
        foodImageView.image = UIImage(named: food.name)
    }
    
    private func closeAddFoodMenu() {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = -900
        } completion: { done in
            UIView.animate(withDuration: 0.3) {
                self.dimmingView.alpha = 0
            } completion: { done in
                if done {
                    self.dimmingView.removeFromSuperview()
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closeAddFoodMenu()
    }
}
