//
//  FoodDetailsView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 24.04.2024.
//

import UIKit

class MyFoodDetailsPopupMenu: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var consumeUpIndicator: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var namePropertyStack: UIStackView!
    @IBOutlet weak var valuesPropertyStack: UIStackView!
    
    @IBOutlet weak var weightNameLabel: UILabel!
    @IBOutlet weak var productionDAteNameLabel: UILabel!
    @IBOutlet weak var expirationDateNameLabel: UILabel!
    @IBOutlet weak var consumeUpNameLabel: UILabel!
    @IBOutlet weak var weightValueLabel: UILabel!
    @IBOutlet weak var productionDateValueLabel: UILabel!
    @IBOutlet weak var expirationDateValueLabel: UILabel!
    @IBOutlet weak var consumeUpValueLabel: UILabel!
    
    private let arrowView = UIImageView()
    private let dimmingView = UIView()
    private let gestureForCloseMenu = UITapGestureRecognizer()
    
//    init(view: UIView, collectionView: UICollectionView, foodDetails: MyFood.showDetailFood.ViewModel.DiplayedDetails) {
//        super.init(frame: .zero)
//        setupUI()
//        configure(viewModel: foodDetails)
//        openPopUpMenu(for: view, with: collectionView)
//        gestureForCloseMenu.addTarget(self, action: #selector(tapToClose))
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        gestureForCloseMenu.addTarget(self, action: #selector(tapToClose))
    }
}

extension MyFoodDetailsPopupMenu {

    func openPopUpMenu(for view: UIView, with collectionView: UICollectionView) {
        
        dimmingView.frame = view.bounds
        
        guard let position = findPosition(for: view, and: arrowView, from: collectionView) else { return }
        arrowView.frame = position.startArrowPosition
        contentView.frame = position.startPostion
        
        UIView.animate(withDuration: 0.2) {
            self.dimmingView.alpha = 0.5
            self.contentView.frame = position.intermediatePosition
            self.arrowView.frame = position.endArrowPosition
            self.nameLabel.alpha = 1
            self.consumeUpIndicator.alpha = 1
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.1) {
                    
                    self.namePropertyStack.alpha = 1
                    self.valuesPropertyStack.alpha = 1
                    self.contentView.frame = position.endPosition
                }
            }
        }
        
        view.addSubview(dimmingView)
        view.addSubview(arrowView)
        view.addSubview(self)
        dimmingView.addGestureRecognizer(gestureForCloseMenu)
    }
    
    private func closePopUpMenu() {
                
        let positionX = self.contentView.frame.origin.x + 110
        let positionY = self.contentView.frame.origin.y + 55
        
        UIView.animate(withDuration: 0.1) {
            self.namePropertyStack.alpha = 0
            self.valuesPropertyStack.alpha = 0
            self.nameLabel.alpha = 0
            self.consumeUpIndicator.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2) {
            self.arrowView.frame = CGRect(x: positionX, y: positionY, width: 1, height: 1)
            self.contentView.frame = CGRect(x: positionX, y: positionY, width: 0, height: 0)
        } completion: { done in
            if done {
                self.dimmingView.alpha = 0
                self.dimmingView.removeFromSuperview()
                self.arrowView.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
    
    func configure(viewModel: MyFood.showDetailFood.ViewModel.DiplayedDetails) {
        nameLabel.text = viewModel.name
        weightValueLabel.text = viewModel.weight + " " + viewModel.unit.localized()
        productionDateValueLabel.text = viewModel.productionDate
        expirationDateValueLabel.text = viewModel.expirationDate
        consumeUpValueLabel.text = viewModel.daysLeft
        setupCircleView(indicator: viewModel.distaceIndicator)
    }
    
    private func setupUI() {
        nameLabel.alpha = 0
        consumeUpIndicator.alpha = 0
        namePropertyStack.alpha = 0
        valuesPropertyStack.alpha = 0
        arrowView.tintColor = .white
        dimmingView.alpha = 0.5
        dimmingView.backgroundColor = .black
        contentView.layer.cornerRadius = 8
        weightNameLabel.text = "Weight:".localized()
        productionDAteNameLabel.text = "Manufacturing Date:".localized()
        expirationDateNameLabel.text = "Expires on:".localized()
        consumeUpNameLabel.text = "Remaining:".localized()
        nameLabel.font = UIFont(name: "Inter", size: nameLabel.font.pointSize)
        setupFonts(labels: [weightNameLabel,
                           productionDAteNameLabel,
                           expirationDateNameLabel,
                           consumeUpNameLabel,
                           weightValueLabel,
                           productionDateValueLabel,
                           expirationDateValueLabel,
                           consumeUpValueLabel],
                   fontName: "Inter-ExtraLight")
    }
    
    private func setupCircleView(indicator: CGFloat?) {
        
        guard let indicator = indicator else { return }
                
        let foreGroundLayer = CAShapeLayer()
        let backGroundLayer = CAShapeLayer()
                
        let center = CGPoint(x: consumeUpIndicator.frame.height / 2, y: consumeUpIndicator.frame.width / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: 10, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        backGroundLayer.path = circularPath.cgPath
        backGroundLayer.lineWidth = 3
        backGroundLayer.strokeEnd = indicator
        backGroundLayer.fillColor = .none
        backGroundLayer.strokeColor = UIColor.systemGray5.cgColor
        backGroundLayer.strokeEnd = 1
        
        foreGroundLayer.path = circularPath.cgPath
        foreGroundLayer.lineWidth = 3
        foreGroundLayer.strokeEnd = indicator
        foreGroundLayer.fillColor = .none
        foreGroundLayer.lineCap = .round

        
        consumeUpIndicator.layer.addSublayer(backGroundLayer)
        consumeUpIndicator.layer.addSublayer(foreGroundLayer)
        
        if indicator > 0.5 {
            foreGroundLayer.strokeColor = UIColor.green.cgColor
        } else if indicator > 0.2 && indicator <= 0.5 {
            foreGroundLayer.strokeColor = UIColor.orange.cgColor
        } else if indicator > 0.0 && indicator <= 0.2 {
            foreGroundLayer.strokeColor = UIColor.red.cgColor
        } else {
            let exclamationMark = UILabel()
            exclamationMark.text = "!"
            exclamationMark.font = UIFont(name: "Inter-bold", size: exclamationMark.font.pointSize)
            exclamationMark.textColor = .white
            exclamationMark.textAlignment = .center
            backGroundLayer.removeFromSuperlayer()
            foreGroundLayer.removeFromSuperlayer()
            consumeUpIndicator.layer.cornerRadius = consumeUpIndicator.frame.height / 2
            consumeUpIndicator.backgroundColor = .red
            exclamationMark.frame = consumeUpIndicator.bounds
            consumeUpIndicator.addSubview(exclamationMark)
        }
        

    }

    @objc func tapToClose() {
        closePopUpMenu()
    }
}

extension MyFoodDetailsPopupMenu {
    private func setupFonts(labels: [UILabel], fontName: String) {
        labels.forEach { label in
            label.font = UIFont(name: fontName, size: label.font.pointSize)
        }
    }
}
