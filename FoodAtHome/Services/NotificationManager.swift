//
//  NotificationManeger.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.06.2025.
//

import NotificationCenter

protocol NotificationManagerProtocol {
    func scheduleExpiredNotification(timeInterval: Double)
    func scheduleEndingNotification(timeInterval: Double)
}

class NotificationManager: NotificationManagerProtocol {
    
    static let shared = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, error in
            self.notificationSettings()
        }
    }
    
    private func notificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                
            }
        }
    }
    
    func scheduleExpiredNotification(timeInterval: Double) {
        let expiredContent = UNMutableNotificationContent()
        expiredContent.title = "Expired!".localized()
        expiredContent.body = "Some of your products have expired.".localized()
        expiredContent.sound = UNNotificationSound.default
        expiredContent.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let expiredRequest = UNNotificationRequest(identifier: "expired", content: expiredContent, trigger: trigger)
        notificationCenter.add(expiredRequest)
    }
    
    func scheduleEndingNotification(timeInterval: Double) {
        let endingContent = UNMutableNotificationContent()
        endingContent.title = "Nearing expiration.".localized()
        endingContent.body = "Some of your products are about to expire.".localized()
        endingContent.sound = UNNotificationSound.default
        endingContent.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let endingRequest = UNNotificationRequest(identifier: "ending", content: endingContent, trigger: trigger)
        notificationCenter.add(endingRequest)
    }
}
