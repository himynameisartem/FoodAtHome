//
//  PopupMenuView.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.07.2023.
//

import UIKit

protocol ShowPopupMenuProtocol: AnyObject {
    func showPopupMenu(from sourceCell: UICollectionViewCell?, at indexPath: IndexPath?, from viewController: UIViewController)
    func hidePopupMenu(from viewController: UIViewController, and tapGesture: UITapGestureRecognizer)
}

class PopupMenu: UIView, ShowPopupMenuProtocol {
    
    private var containerView: UIView!
    private var arrowView: UIImageView!
    private var menuView: UIView!
    private var dimmingView: UIView!
    private var gestureForCellSize: UITapGestureRecognizer!
    
    private let menuWidth: CGFloat = 220
    private let menuHeight: CGFloat = 110
    private var x: CGFloat!
    private var y: CGFloat!
    private var arrowY: CGFloat!
    private var arrowStartPointY: CGFloat!
    
    private var nameLabel: UILabel!
    
    private var circleView: UIView!
    
    private var weightLabel: UILabel!
    private var dateOfManufactureLabel: UILabel!
    private var sellByLabel: UILabel!
    private var leftLabel: UILabel!
    
    private var detailWeightLabel: UILabel!
    private var detailDateOfManufactureLabel: UILabel!
    private var detailSellByLabel: UILabel!
    private var detailLeftLabel: UILabel!
    
    private var labelsStackView: UIStackView!
    private var detailsLabelsStackView: UIStackView!
    private var mainStackView: UIStackView!
    
    private var expirationDateIndicator: UIView!
    private var expirationSign: UILabel!
    
    
    func showPopupMenu(from sourceCell: UICollectionViewCell?, at indexPath: IndexPath?, from viewController: UIViewController) {
        
        guard let view = viewController.tabBarController?.view else { return }
        guard let sourceCell = sourceCell else { return }
        
        setupUI(at: sourceCell, from: view)
        setupConstraints(view: containerView)
        
        
        UIView.animate(withDuration: 0.2) {
            self.dimmingView.alpha = 0.5
            self.containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.arrowView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.arrowView.center = CGPoint(x: sourceCell.center.x + 15, y: self.arrowY)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.2) {
                    self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.arrowView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    if self.arrowView.image == UIImage(systemName: "arrowtriangle.up.fill") {
                        self.arrowView.layer.position.y = self.arrowY + 5
                    } else {
                        self.arrowView.layer.position.y = self.arrowY - 5
                    }
                } completion: { done  in
                    if done {
                        UIView.animate(withDuration: 0.2) {
                            self.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.arrowView.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.arrowView.layer.position.y = self.arrowY
                            sourceCell.removeGestureRecognizer(self.gestureForCellSize)
                        }
                    }
                }
            }
        }
    }
    
    func hidePopupMenu(from viewController: UIViewController, and tapGesture: UITapGestureRecognizer) {
        
        guard let view = viewController.tabBarController?.view else { return }
        
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.arrowView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.2) {
                    self.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.arrowView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.arrowView.center = CGPoint(x: self.x , y: self.arrowStartPointY)
                    self.dimmingView.alpha = 0
                } completion: { done in
                    if done {
                        self.containerView.removeFromSuperview()
                        self.arrowView.removeFromSuperview()
                        self.dimmingView.removeFromSuperview()
                        view.removeGestureRecognizer(tapGesture)
                    }
                }
            }
        }
    }
}

//MARK: - Setup UI

extension PopupMenu {
    
    private func setupUI(at sourceCell: UICollectionViewCell, from view: UIView) {
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: menuWidth, height: menuHeight + 20))
        containerView.layer.cornerRadius = 8
        
        arrowView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        arrowView.tintColor = .white
        
        menuView = UIView()
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.backgroundColor = .white
        menuView.layer.cornerRadius = 8
        
        dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0
        dimmingView.isUserInteractionEnabled = true
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8
        
        circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        weightLabel = UILabel()
        dateOfManufactureLabel = UILabel()
        sellByLabel = UILabel()
        leftLabel = UILabel()
        detailWeightLabel = UILabel()
        detailWeightLabel.textAlignment = .right
        detailDateOfManufactureLabel = UILabel()
        detailDateOfManufactureLabel.textAlignment = .right
        detailSellByLabel = UILabel()
        detailSellByLabel.textAlignment = .right
        detailLeftLabel = UILabel()
        detailLeftLabel.textAlignment = .right
        
        setupLabels(at: [weightLabel, dateOfManufactureLabel, sellByLabel, leftLabel, detailWeightLabel, detailDateOfManufactureLabel, detailSellByLabel, detailLeftLabel])
        
        labelsStackView = UIStackView(arrangedSubviews: [weightLabel, dateOfManufactureLabel, sellByLabel, leftLabel])
        labelsStackView.axis = .vertical
        
        detailsLabelsStackView = UIStackView(arrangedSubviews: [detailWeightLabel, detailDateOfManufactureLabel, detailSellByLabel, detailLeftLabel])
        detailsLabelsStackView.axis = .vertical
        
        mainStackView = UIStackView(arrangedSubviews: [labelsStackView, detailsLabelsStackView])
        mainStackView.axis = .horizontal
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        gestureForCellSize = UITapGestureRecognizer()
        sourceCell.addGestureRecognizer(gestureForCellSize)
        let touch = gestureForCellSize.location(in: sourceCell)
        let cellHeight = (view.frame.width / 4 - 15) * 1.5
        
        if sourceCell.center.x < containerView.frame.width / 2 {
            x = containerView.frame.width / 2 + 5
        } else if sourceCell.center.x > view.frame.width - (containerView.frame.width / 2) {
            x = view.frame.width - containerView.frame.width / 2 - 5
        } else {
            x = sourceCell.center.x + 20
        }
        
        
        if touch.y * (-1) < view.frame.height - (view.frame.height / 3) {
            y = touch.y * (-1) + cellHeight + containerView.frame.height / 2 - 5
            arrowY = y - menuHeight / 2 + 5
            arrowView.image = UIImage(systemName: "arrowtriangle.up.fill")
            arrowStartPointY = y + 40
        } else {
            y = touch.y * (-1) - containerView.frame.height / 2 - 15
            arrowY = y + menuHeight / 2 + 15
            arrowView.image = UIImage(systemName: "arrowtriangle.down.fill")
            arrowStartPointY = y - 40
        }
        
        containerView.center = CGPoint(x: x, y: y)
        arrowView.center = CGPoint(x: x, y: arrowStartPointY)
        arrowView.transform = CGAffineTransform(scaleX: 0, y: 0)
        containerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        expirationDateIndicator = UIView()
        expirationDateIndicator.translatesAutoresizingMaskIntoConstraints = false
        expirationDateIndicator.layer.cornerRadius = 10
        
        expirationSign = UILabel()
        expirationSign.translatesAutoresizingMaskIntoConstraints = false
        expirationSign.text = "!"
        expirationSign.font = UIFont(name: "Inter-SemiBold", size: 18)
        expirationSign.textColor = .white
        expirationSign.textAlignment = .center
        
        view.addSubview(dimmingView)
        view.addSubview(containerView)
        view.addSubview(arrowView)
        containerView.addSubview(menuView)
        menuView.addSubview(expirationDateIndicator)
        menuView.addSubview(nameLabel)
        menuView.addSubview(mainStackView)
        menuView.addSubview(circleView)
        expirationDateIndicator.addSubview(expirationSign)
    }
    
    private func circle(from shapeView: UIView, indicator: CGFloat?) {
        
        expirationSign.isHidden = true
        expirationDateIndicator.isHidden = true
        
        guard let indicator = indicator else { return }
                
        let foreGroundLayer = CAShapeLayer()
        let backGroundLayer = CAShapeLayer()
        
        let center = CGPoint(x: shapeView.frame.height / 2, y: shapeView.frame.width / 2)
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
        
        if foreGroundLayer.strokeEnd >= 0.5 {
            shapeView.layer.addSublayer(backGroundLayer)
            shapeView.layer.addSublayer(foreGroundLayer)
            shapeView.isHidden = true
            expirationSign.isHidden = true
            expirationDateIndicator.isHidden = true
            foreGroundLayer.strokeColor = UIColor.green.cgColor
        } else if foreGroundLayer.strokeEnd < 0.5 && foreGroundLayer.strokeEnd >= 0.2 {
            shapeView.layer.addSublayer(backGroundLayer)
            shapeView.layer.addSublayer(foreGroundLayer)
            shapeView.isHidden = true
            expirationSign.isHidden = true
            expirationDateIndicator.isHidden = true
            foreGroundLayer.strokeColor = UIColor.orange.cgColor
        } else if foreGroundLayer.strokeEnd < 0.2 && foreGroundLayer.strokeEnd > 0.0 {
            shapeView.layer.addSublayer(backGroundLayer)
            shapeView.layer.addSublayer(foreGroundLayer)
            shapeView.isHidden = true
            expirationSign.isHidden = true
            expirationDateIndicator.isHidden = true
            foreGroundLayer.strokeColor = UIColor.red.cgColor
        } else {
            expirationSign.isHidden = false
            expirationDateIndicator.isHidden = false
            expirationDateIndicator.backgroundColor = .red
            detailLeftLabel.text = "Overdue".localized()
        }
        
        foreGroundLayer.lineCap = .round
        
        if sellByLabel.text != "-" {
            shapeView.isHidden = false
        }
    }
    
    private func setupConstraints(view: UIView) {
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            menuView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            menuView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            circleView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 20),
            circleView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -10),
            circleView.heightAnchor.constraint(equalToConstant: 10),
            circleView.widthAnchor.constraint(equalToConstant: 10),
            
            nameLabel.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: -5),
            
            mainStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -10),
            
            expirationDateIndicator.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 10),
            expirationDateIndicator.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -10),
            expirationDateIndicator.heightAnchor.constraint(equalToConstant: 20),
            expirationDateIndicator.widthAnchor.constraint(equalToConstant: 20),
            
            expirationSign.topAnchor.constraint(equalTo: expirationDateIndicator.topAnchor),
            expirationSign.leadingAnchor.constraint(equalTo: expirationDateIndicator.leadingAnchor),
            expirationSign.trailingAnchor.constraint(equalTo: expirationDateIndicator.trailingAnchor),
            expirationSign.bottomAnchor.constraint(equalTo: expirationDateIndicator.bottomAnchor)
            
        ])
    }
    
    func configure(food: FoodRealm) {
        nameLabel.text = food.name.localized()
        weightLabel.text = "Weight:".localized()
        dateOfManufactureLabel.text = "Manufacturing Date:".localized()
        sellByLabel.text = "Expires on:".localized()
        leftLabel.text = "Remaining:".localized()
        detailWeightLabel.text = "\(food.weight) \(food.unit.localized())"
        
        
        if food.productionDate == nil {
            detailDateOfManufactureLabel.text = "-"
        } else {
            detailDateOfManufactureLabel.text = food.productionDateString()
        }
        if food.expirationDate == nil {
            detailSellByLabel.text = "-"
        } else {
            detailSellByLabel.text = food.expirationDateString()
        }
        if detailDateOfManufactureLabel.text == "-" || detailSellByLabel.text == "-" {
            detailLeftLabel.text = "-"
        } else {
            detailLeftLabel.text = food.daysLeftString()
        }
        
        circle(from: circleView, indicator: food.distanceBetweenProductionAndExpiration())
    }
}

//MARK: - Support Methods

extension PopupMenu {
    func setupLabels(at labels: [UILabel]) {
        for i in labels {
            i.font = UIFont(name: "Inter-ExtraLight", size: 10)
        }
    }
}
