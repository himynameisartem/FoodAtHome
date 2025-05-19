//
//  SettingsPresenter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol SettingsPresentationLogic {
    func presentData(response: SettingsModel.FetchData.Response)
    func presentSwitchSelection(response: SettingsModel.SwitchSelection.Response)
}

class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?
    
    func presentData(response: SettingsModel.FetchData.Response) {
        let states = (0..<response.modes.count).map { $0 == response.selectedIndex }
        let viewModel = SettingsModel.FetchData.ViewModel(modes: response.modes, states: states)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func presentSwitchSelection(response: SettingsModel.SwitchSelection.Response) {
        let states = (0..<response.total).map { $0 == response.selectedIndex }
        let viewModel = SettingsModel.SwitchSelection.ViewModel(switchesState: states)
        viewController?.displaySwitchSelection(viewModel: viewModel)
    }
}
