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
            let language: String
        }
        struct ViewModel {
            let modes: [String]
            let states: [Bool]
            let language: String
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
    
    enum SetLanguage {
        struct Request {}
        struct Response {}
        struct ViewModel {
            let alertTitle: String
            let cancelButtonTitle: String
            let englishLanguageTitle: String
            let russianLanguageTitle: String
        }
    }
    
    enum ConfirmChangeLanguage {
        struct Request {
            let languageCode: String
        }
        struct Response {
            let language: String
        }
        struct ViewModel {
            let language: String
        }
    }
}
