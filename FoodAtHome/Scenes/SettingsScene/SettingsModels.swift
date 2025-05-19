//
//  SettingsModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

enum SettingsModel {
    
    enum FetchData {
        struct Request {}
        struct Response {
            let modes: [String]
            let selectedIndex: Int
        }
        struct ViewModel {
            let modes: [String]
            let states: [Bool]
        }
    }
    
    enum SwitchSelection {
        struct Request {
            let selectedIndex: Int
        }
        struct Response {
            let selectedIndex: Int
            let total: Int
        }
        struct ViewModel {
            let switchesState: [Bool]
        }
    }
}
