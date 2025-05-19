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
}

protocol SettingsDataStore {
    var selectedSwitchIndex: Int { get set }
    var modes: [String] { get }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
    
    var presenter: SettingsPresentationLogic?
    var worker: SettingsWorkerProtocol
    var modes: [String] = ["System Mode", "Dark Mode", "Light Mode"]
    private let userDefaultsKey = "selectedSwitchIndex"
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
    
    init(worker: SettingsWorkerProtocol) {
        self.worker = worker
    }
    
    func fetchData(request: SettingsModel.FetchData.Request) {
        let response = SettingsModel.FetchData.Response(modes: modes, selectedIndex: selectedSwitchIndex)
        presenter?.presentData(response: response)
    }
    
    func selectSwitch(request: SettingsModel.SwitchSelection.Request) {
        selectedSwitchIndex = request.selectedIndex
        let response = SettingsModel.SwitchSelection.Response(selectedIndex: selectedSwitchIndex, total: modes.count)
        presenter?.presentSwitchSelection(response: response)
    }
}
