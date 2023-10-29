//
//  NotificationManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.10.2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    private let currentDate = Date()
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
    }
    
    func addedNotification() {
        
        let allFood = FoodManager.shared.fetchMyFoodList()
        var foodForNotification = [Date]()
        
        for i in allFood {
            if i.expirationDate != nil {
                foodForNotification.append(i.expirationDate!)
            }
        }
        
        let lessThanTwoDaysLeft = DateManager.shared.currentDateFromTimaZone(date: foodForNotification, notification: .daysLeft) ?? 0.0
        let expired = DateManager.shared.currentDateFromTimaZone(date: foodForNotification, notification: .expire) ?? 0.0

        let lessThanTwoDaysContent = UNMutableNotificationContent()
        lessThanTwoDaysContent.title = "Food At Home".localized()
        lessThanTwoDaysContent.body = "The expiration date of some products is almost expired.".localized()
        lessThanTwoDaysContent.sound = .default
        
        let expiredContent = UNMutableNotificationContent()
        expiredContent.title = "Food At Home".localized()
        expiredContent.body = "Some of your products have expired!".localized()
        expiredContent.sound = .default

        if lessThanTwoDaysLeft != 0.0 {
            let lessThanTwoDaysTrigger = UNTimeIntervalNotificationTrigger(timeInterval: lessThanTwoDaysLeft, repeats: false)
            let lessThanTwoDaysRequest = UNNotificationRequest(identifier: "lessThanTwoDays", content: lessThanTwoDaysContent, trigger: lessThanTwoDaysTrigger)
            notificationCenter.add(lessThanTwoDaysRequest)
        }
        if expired != 0.0 {
            let expiredTrigger = UNTimeIntervalNotificationTrigger(timeInterval: expired, repeats: false)
            let expiredRequest = UNNotificationRequest(identifier: "expire", content: expiredContent, trigger: expiredTrigger)
            notificationCenter.add(expiredRequest)
        } else {
            let expiredInterval = lessThanTwoDaysLeft + Double(50 * 3600)
            let expiredTrigger = UNTimeIntervalNotificationTrigger(timeInterval: expiredInterval, repeats: false)
            let expiredRequest = UNNotificationRequest(identifier: "expire", content: expiredContent, trigger: expiredTrigger)
            notificationCenter.add(expiredRequest)
        }
    }
}
