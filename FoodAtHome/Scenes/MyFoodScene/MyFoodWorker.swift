//
//  MyFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit
import RealmSwift

protocol MyFoodWorkerProtocol {
    func fetchMyFood() -> [FoodRealm]
    func prepareFoodForRouting(source: [FoodRealm], type: String) -> [FoodRealm]
    func scheduleNotificationForExpired()
    func scheduleNotificationForEnding()
    func deleteFood(at indexPath: IndexPath)
    func removeAllFood()
}

class MyFoodWorker: MyFoodWorkerProtocol {
    
    var notification: NotificationManagerProtocol
    
    init(notification: NotificationManagerProtocol) {
        self.notification = notification
    }
    
    func fetchMyFood() -> [FoodRealm] {
        return DataManager.shared.fetchMyFood()
    }
    
    func calculateTimeIntervalNotification(dateInterval: Double) -> Double {
        let dates = fetchMyFood().map { $0.expirationDate }
        let secondsArray = dates.compactMap { date -> TimeInterval? in
            guard let date = date else { return nil }
            let interval = date.timeIntervalSince(Date.now)
            return interval > dateInterval ? interval : nil
        }.sorted(by: <)
        return Double(Int(secondsArray.first ?? 0)) + 43200
    }
    
    func scheduleNotificationForExpired() {
        let timeInterval = calculateTimeIntervalNotification(dateInterval: 0) + 7200
        if timeInterval > 50400 {
            notification.scheduleExpiredNotification(timeInterval: timeInterval)
        }
    }
    
    func scheduleNotificationForEnding() {
        let timeInterval = calculateTimeIntervalNotification(dateInterval: 259200) - 259200
        if timeInterval > 43200 {
            notification.scheduleEndingNotification(timeInterval: timeInterval)
        }
    }
    
    func deleteFood(at indexPath: IndexPath) {
        let items = DataManager.shared.fetchMyFood()
        return DataManager.shared.delete(food: items[indexPath.row])
    }
    
    func prepareFoodForRouting(source: [FoodRealm], type: String) -> [FoodRealm] {
        source.filter { $0.type == type }
    }
    
    func removeAllFood() {
        DataManager.shared.reamoveAllMyFood()
    }
}
