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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        gestureForCloseMenu.addTarget(self, action: #selector(tapToClose))
    }
}

extension MyFoodDetailsPopupMenu {
    
    private func setupUI() {
        nameLabel.alpha = 0
        consumeUpIndicator.alpha = 0
        namePropertyStack.alpha = 0
        valuesPropertyStack.alpha = 0
        arrowView.tintColor = .white
        dimmingView.alpha = 0.5
        dimmingView.backgroundColor = .black
        contentView.layer.cornerRadius = 8
        weightNameLabel.text = "Weight: "
        productionDAteNameLabel.text = "Production Date: "
        expirationDateNameLabel.text = "Expiration Date: "
        consumeUpNameLabel.text = "Consume Up: "
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
    
    func configure(viewModel: [MyFood.showDetailFood.ViewModel.DiplayedDetails], at indexPath: IndexPath) {
        let viewModel = viewModel[indexPath.row]
        nameLabel.text = viewModel.name
        weightValueLabel.text = viewModel.weight
        productionDateValueLabel.text = viewModel.productionDate
        expirationDateValueLabel.text = viewModel.expirationDate
        consumeUpValueLabel.text = viewModel.consumeUp
        setupCircleView(indicator: viewModel.distaceIndicator)
    }
    
    func setupPopUpMenu(for view: UIView, with collectionView: UICollectionView, at indexPath: IndexPath) {
        
        dimmingView.frame = view.bounds
        
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let touchPointInCollectionView = collectionView.panGestureRecognizer.location(in: collectionView)
        let touchPointInCell = collectionView.convert(touchPointInCollectionView, to: cell)
        let positionCellY = cell.frame.height - touchPointInCell.y + 20
        var positionX = touchPointInCollectionView.x  - (touchPointInCell.x - cell.frame.width / 2)
        var positionY = (touchPointInCollectionView.y  - collectionView.contentOffset.y + (view.frame.height - collectionView.frame.height)) + positionCellY
        let arrowPositionX = positionX
        var arrowPositionY = positionY
        if positionX - 110 < 10 {
            positionX = 120
        } else if positionX + 110 > view.frame.width {
            positionX = view.frame.width - 120
        }
        
        //
        //Wheh here will tabBar:
        //        guard let tabBarFrame = tabBarController?.tabBar.frame else { return }
        //        let tabBarBorder = view.frame.height + tabBarFrame
        //
        
        let tabBarBorder = view.frame.height

        if positionY + 110 > tabBarBorder - 10 {
            positionY -= cell.frame.height + 150
            arrowPositionY = positionY + 126
            arrowView.image = UIImage(systemName: "arrowtriangle.down.fill")
        } else {
            arrowView.image = UIImage(systemName: "arrowtriangle.up.fill")
        }
        let width: CGFloat = 220
        let height: CGFloat = 110
        let startPosition = CGRect(x: positionX , y: positionY + height / 2, width: 0, height: 0)
        let endPosition = CGRect(x: positionX - width / 2, y: positionY, width: width, height: height)
        let startArrowPosition = CGRect(x: positionX, y: positionY + height / 2, width: 0, height: 0)
        let endArrowPosition = CGRect(x: arrowPositionX - 10, y: arrowPositionY - 18, width: 20, height: 20)
        arrowView.frame = startArrowPosition
        contentView.frame = startPosition
        
        UIView.animate(withDuration: 0.2) {
            self.dimmingView.alpha = 0.5
            self.contentView.frame = CGRect(x: positionX - width / 2, y: positionY, width: width + 10, height: height + 10)
            self.arrowView.frame = endArrowPosition
            self.nameLabel.alpha = 1
            self.consumeUpIndicator.alpha = 1
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.1) {
                    
                    self.namePropertyStack.alpha = 1
                    self.valuesPropertyStack.alpha = 1
                    self.contentView.frame = endPosition
                }
            }
        }
        
        view.addSubview(dimmingView)
        view.addSubview(arrowView)
        view.addSubview(self)
        dimmingView.addGestureRecognizer(gestureForCloseMenu)
    }
    
    private func closeMenu() {
                
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
        closeMenu()
    }
}

extension MyFoodDetailsPopupMenu {
    private func setupFonts(labels: [UILabel], fontName: String) {
        labels.forEach { label in
            label.font = UIFont(name: fontName, size: label.font.pointSize)
        }
    }
}
