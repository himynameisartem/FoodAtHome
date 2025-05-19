//
//  SettingsViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
    func displayData(viewModel: SettingsModel.FetchData.ViewModel)
    func displaySwitchSelection(viewModel: SettingsModel.SwitchSelection.ViewModel)
}

class SettingsViewController: UIViewController {
    
    //временно
    private var modes: [String] = []
    private var switchStates: [Bool] = []
    
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic)?
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let worker = SettingsWorker()
        let interactor = SettingsInteractor(worker: worker)
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setup()
        navigationBarSetup()
        fetchData()
    }
    
    @IBOutlet weak var tabBarTitle: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    
    private func fetchData() {
        let request = SettingsModel.FetchData.Request()
        interactor?.fetchData(request: request)
    }
    
    private func switchSelection(at indexPath: IndexPath) {
        let request = SettingsModel.SwitchSelection.Request(selectedIndex: indexPath.row)
        interactor?.selectSwitch(request: request)
    }
    
    private func navigationBarSetup() {
        let x = -(view.frame.width / 2) + 10
        let y = view.frame.origin.y - ((navigationController?.navigationBar.frame.height ?? 0) / 2)
        let height = navigationController?.navigationBar.frame.height ?? 0
        let width = view.frame.width / 2
        tabBarTitle.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func configureTableView() {
        settingsTableView.register(SetLanguageCell.self, forCellReuseIdentifier: "SetLanguageCell")
        settingsTableView.register(SetAppearanceCell.self, forCellReuseIdentifier: "SetAppearanceCell")
        settingsTableView.register(InformationCell.self, forCellReuseIdentifier: "InformationCell")
    }
    
    
}

//MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Language"
        } else if section == 1 {
            return "Appearance"
        } else {
            return "Information"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return modes.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let setLanguageCell = tableView.dequeueReusableCell(withIdentifier: "SetLanguageCell", for: indexPath) as! SetLanguageCell
            let viewModel = SetLanguageCellViewModel(title: "Set Language", language: "Русский")
            setLanguageCell.configure(with: viewModel)
            setLanguageCell.awakeFromNib()
            return setLanguageCell
        case 1:
            let setAppearanceCell = tableView.dequeueReusableCell(withIdentifier: "SetAppearanceCell", for: indexPath) as! SetAppearanceCell
            let isOn = switchStates[indexPath.row]
            let viewModel = SetAppearanceCellViewModel(title: modes[indexPath.row], isOn: isOn)
            setAppearanceCell.configure(with: viewModel)
            setAppearanceCell.selectionStyle = .none
            setAppearanceCell.switchAction = { [weak self] isOn in
                self?.switchSelection(at: indexPath)
//                if indexPath.row == 0 && setAppearanceCell.switchMode.isOn {
//                    guard let windowScene = UIApplication.shared.connectedScenes
//                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
//                        return
//                    }
//                    guard let window = windowScene.windows.first else {
//                        return
//                    }
//                    window.overrideUserInterfaceStyle = .unspecified
//                    print("systemMode")
//                } else if indexPath.row == 1 && setAppearanceCell.switchMode.isOn {
//                    guard let windowScene = UIApplication.shared.connectedScenes
//                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
//                        return
//                    }
//                    guard let window = windowScene.windows.first else {
//                        return
//                    }
//                    window.overrideUserInterfaceStyle = .dark
//                    print("darkMode")
//                } else if indexPath.row == 2 && setAppearanceCell.switchMode.isOn {
//                    guard let windowScene = UIApplication.shared.connectedScenes
//                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
//                        return
//                    }
//                    guard let window = windowScene.windows.first else {
//                        return
//                    }
//                    window.overrideUserInterfaceStyle = .light
//                    print("lightMode")
//                }
            }
            return setAppearanceCell
        case 2 :
            let informationCell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as! InformationCell
            let viewModel = InformationCellViewModel(title: "About Us")
            informationCell.configure(with: viewModel)
            informationCell.awakeFromNib()
            return informationCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("select language")
        case 2:
            print("information about us")
        default :
            break
        }
    }
}

extension SettingsViewController: SettingsDisplayLogic {
    
    func displayData(viewModel: SettingsModel.FetchData.ViewModel) {
        self.modes = viewModel.modes
        self.switchStates = viewModel.states
        settingsTableView.reloadData()
    }
    
    func displaySwitchSelection(viewModel: SettingsModel.SwitchSelection.ViewModel) {
        self.switchStates = viewModel.switchesState
        for cell in settingsTableView.visibleCells {
            if let cell = cell as? SetAppearanceCell,
               let indexPath = settingsTableView.indexPath(for: cell) {
                cell.switchMode.setOn(switchStates[indexPath.row], animated: true)
            }
        }
    }
}
