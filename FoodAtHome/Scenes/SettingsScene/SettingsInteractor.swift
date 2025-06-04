//
//  SettingsInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol SettingsBusinessLogic {
    func fetchData(request: SettingsModel.FetchData.Request)
    func selectSwitch(request: SettingsModel.SwitchSelection.Request)
    func setLanguage(request: SettingsModel.SetLanguage.Request)
    func confirmChangeLanguage(request: SettingsModel.ConfirmChangeLanguage.Request)
}

protocol SettingsDataStore {
    var selectedSwitchIndex: Int { get set }
    var selectedLangage: String { get set }
    var modes: [String] { get }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
    
    var presenter: SettingsPresentationLogic?
    var worker: SettingsWorkerProtocol
    var modes: [String] = ["System mode".localized(), "Dark mode".localized(), "Light mode".localized()]
    private let userDefaultsKey = "selectedSwitchIndex"
    private let languageKey = "selectedLanguageCode"
    var selectedSwitchIndex: Int {
        get {
            if UserDefaults.standard.object(forKey: userDefaultsKey) == nil {
                return 0
            }
            return UserDefaults.standard.integer(forKey: userDefaultsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
        }
    }
    var selectedLangage: String {
        get {
            if UserDefaults.standard.object(forKey: languageKey) == nil {
                let preferredLanguage = Locale.preferredLanguages.first ?? "unknown"
                var languageCode = preferredLanguage.components(separatedBy: "-").first ?? "unknown"
                if languageCode != "en" && languageCode != "ru" {
                    languageCode = "en"
                }
                return languageCode
            } else {
                return UserDefaults.standard.string(forKey: languageKey) ?? "unknown"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: languageKey)
        }
    }
    
    init(worker: SettingsWorkerProtocol) {
        self.worker = worker
    }
    
    func fetchData(request: SettingsModel.FetchData.Request) {
        let response = SettingsModel.FetchData.Response(modes: modes, selectedIndex: selectedSwitchIndex, language: worker.fetchLanguage(from: selectedLangage))
        presenter?.presentData(response: response)
    }
    
    func selectSwitch(request: SettingsModel.SwitchSelection.Request) {
        selectedSwitchIndex = request.selectedIndex
        switch selectedSwitchIndex {
        case 0:
            worker.setTheme(style: .unspecified)
        case 1:
            worker.setTheme(style: .dark)
        case 2:
            worker.setTheme(style: .light)
        default:
            break
        }
        let response = SettingsModel.SwitchSelection.Response(selectedIndex: selectedSwitchIndex, total: modes.count)
        presenter?.presentSwitchSelection(response: response)
    }
    
    func setLanguage(request: SettingsModel.SetLanguage.Request) {
        let response = SettingsModel.SetLanguage.Response()
        presenter?.presentSetLanguage(response: response)
    }
    
    func confirmChangeLanguage(request: SettingsModel.ConfirmChangeLanguage.Request) {
        selectedLangage = request.languageCode
        worker.setLanguage(code: selectedLangage)
        let response = SettingsModel.ConfirmChangeLanguage.Response(language: worker.fetchLanguage(from: selectedLangage))
        presenter?.presentConfirmSetLanguage(response: response)
    }
}
