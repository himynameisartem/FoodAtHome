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
    
    
    func showPopupMenu(from sourceCell: UICollectionViewCell?, at indexPath: IndexPath?, from viewController: UIViewController) {
        
        guard let view = viewController.tabBarController?.view else { return }
        guard let sourceCell = sourceCell else { return }
        
        setupUI(at: sourceCell, from: view)
        setupConstraints(view: containerView)
        
        
        UIView.animate(withDuration: 0.2) {
            self.dimmingView.alpha = 0.5
            self.containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.arrowView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.arrowView.center = CGPoint(x: sourceCell.center.x + 15, y: self.y - self.menuHeight / 2 + 5)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.2) {
                    self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.arrowView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.arrowView.layer.position.y = self.y - self.menuHeight / 2 + 10
                } completion: { done  in
                    if done {
                        UIView.animate(withDuration: 0.2) {
                            self.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.arrowView.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.arrowView.layer.position.y = self.y - self.menuHeight / 2 + 5
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
                    self.arrowView.center = CGPoint(x: self.x , y: self.y + 40)
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

extension PopupMenu {
    
    func configure(food: FoodRealm) {
        nameLabel.text = food.name
        weightLabel.text = "Вес:"
        detailWeightLabel.text = "\(food.weight) \(food.unit)"
        dateOfManufactureLabel.text = "Дата изготовления:"
        detailDateOfManufactureLabel.text = DateManager.shared.dateFromString(with: food.productionDate)
        sellByLabel.text = "Годен до:"
        detailSellByLabel.text = DateManager.shared.dateFromString(with: food.expirationDate)
        leftLabel.text = "Осталось:"
        detailLeftLabel.text = DateManager.shared.intervalDate(from: food.productionDate, to: food.expirationDate, type: .left)
        circle(from: circleView, from: food.productionDate, to: food.expirationDate)
    }
    
}

extension PopupMenu {
    
    private func setupUI(at sourceCell: UICollectionViewCell, from view: UIView) {
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: menuWidth, height: menuHeight + 20))
        containerView.layer.cornerRadius = 8
        
        arrowView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        arrowView.image = UIImage(systemName: "arrowtriangle.up.fill")
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
        let touchPoint: CGFloat
        let centerX: Double
        
        if sourceCell.center.x < containerView.frame.width / 2 {
            let x = (containerView.frame.width / 2)
            centerX = x + 5
        } else if sourceCell.center.x > view.frame.width - (containerView.frame.width / 2) {
            centerX = view.frame.width - containerView.frame.width / 2 - 5
        } else {
            centerX = sourceCell.center.x + 20
        }
        
        if touch.y * (-1) < view.frame.height - (view.frame.height / 3) {
            touchPoint = touch.y * (-1) + sourceCell.frame.height
        } else {
            touchPoint = touch.y * (-1)
        }
        
        x = centerX
        y = touchPoint + sourceCell.frame.height / 2
        
        containerView.center = CGPoint(x: x, y: y)
        arrowView.center = CGPoint(x: x, y: y + 40)
        arrowView.transform = CGAffineTransform(scaleX: 0, y: 0)
        containerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        view.addSubview(dimmingView)
        view.addSubview(containerView)
        view.addSubview(arrowView)
        containerView.addSubview(menuView)
        menuView.addSubview(nameLabel)
        menuView.addSubview(mainStackView)
        menuView.addSubview(circleView)
    }
    
    private func circle(from shapeView: UIView, from date1: Date?, to date2: Date?) {
        
        guard let date1 = date1, let date2 = date2 else { return }
        let differenceOfDays = DateManager.shared.differenceDays(from: date1, to: date2)
        
        let foreGroundLayer = CAShapeLayer()
        let backGroundLayer = CAShapeLayer()
        
        let center = CGPoint(x: shapeView.frame.height / 2, y: shapeView.frame.width / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(arcCenter: center, radius: 10, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        backGroundLayer.path = circularPath.cgPath
        backGroundLayer.lineWidth = 3
        backGroundLayer.strokeEnd = CGFloat(differenceOfDays)
        backGroundLayer.fillColor = .none
        backGroundLayer.strokeColor = UIColor.systemGray5.cgColor
        backGroundLayer.strokeEnd = 1
        
        foreGroundLayer.path = circularPath.cgPath
        foreGroundLayer.lineWidth = 3
        foreGroundLayer.strokeEnd = CGFloat(differenceOfDays)
        foreGroundLayer.fillColor = .none
        
        if foreGroundLayer.strokeEnd >= 0.5 {
            foreGroundLayer.strokeColor = UIColor.green.cgColor
        } else if foreGroundLayer.strokeEnd < 0.5 && foreGroundLayer.strokeEnd >= 0.2 {
            foreGroundLayer.strokeColor = UIColor.orange.cgColor
        } else {
            foreGroundLayer.strokeColor = UIColor.red.cgColor
        }
        
        foreGroundLayer.lineCap = .round
        
        shapeView.layer.addSublayer(backGroundLayer)
        shapeView.layer.addSublayer(foreGroundLayer)
        shapeView.isHidden = true
                
        if sellByLabel.text != "-" {
            shapeView.isHidden = false
        }
    }
    
}

extension PopupMenu {
    
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
            
        ])
    }
}

extension PopupMenu {
    func setupLabels(at labels: [UILabel]) {
        for i in labels {
            i.font = UIFont(name: "Inter-ExtraLight", size: 10)
        }
    }
}
