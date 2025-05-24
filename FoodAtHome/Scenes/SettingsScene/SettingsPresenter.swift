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
    func presentSetLanguage(response: SettingsModel.SetLanguage.Response)
    func presentConfirmSetLanguage(response: SettingsModel.ConfirmChangeLanguage.Response)
}

class SettingsPresenter: SettingsPresentationLogic {
    weak var viewController: SettingsDisplayLogic?
    
    func presentData(response: SettingsModel.FetchData.Response) {
        let states = (0..<response.modes.count).map { $0 == response.selectedIndex }
        let viewModel = SettingsModel.FetchData.ViewModel(modes: response.modes, states: states, language: response.language)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func presentSwitchSelection(response: SettingsModel.SwitchSelection.Response) {
        let states = (0..<response.total).map { $0 == response.selectedIndex }
        let viewModel = SettingsModel.SwitchSelection.ViewModel(switchesState: states)
        viewController?.displaySwitchSelection(viewModel: viewModel)
    }
    
    func presentSetLanguage(response: SettingsModel.SetLanguage.Response) {
        let viewModel = SettingsModel.SetLanguage.ViewModel(alertTitle: "Choise language",
                                                            cancelButtonTitle: "Cancel",
                                                            englishLanguageTitle: "English",
                                                            russianLanguageTitle: "Русский")
        viewController?.displaySetLanguage(viewModel: viewModel)
    }
    
    func presentConfirmSetLanguage(response: SettingsModel.ConfirmChangeLanguage.Response) {
        let viewModel = SettingsModel.ConfirmChangeLanguage.ViewModel(language: response.language)
        viewController?.displayChangedLanguage(viewModel: viewModel)
    }
}
