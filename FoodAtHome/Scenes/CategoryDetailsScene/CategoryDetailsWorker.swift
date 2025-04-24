//
//  CategoryDetailsWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsWorkerProtocol {
    func getColor(_ expirationDate: Date?, _ productionDate: Date?) -> UIColor?
}

class CategoryDetailsWorker: CategoryDetailsWorkerProtocol {
    
    var dateCalculate: DateCalculatorManagerProtocol
    
    init(dateCalculate: DateCalculatorManagerProtocol) {
        self.dateCalculate = dateCalculate
    }
    
    func getColor(_ expirationDate: Date?, _ productionDate: Date?) -> UIColor? {
        guard let productionDate = productionDate, let expirationDate = expirationDate else { return nil }
        guard let indicator = dateCalculate.calculateExpirationDistance(productionDate: productionDate, expirationDate: expirationDate) else { return nil }
        if indicator < 1 && indicator > 0.4 {
            return nil
        } else if indicator <= 0.4 && indicator > 0.0 {
            return .orange
        } else if indicator <= 0.0 {
            return .red
        } else {
            return nil
        }
    }
}
