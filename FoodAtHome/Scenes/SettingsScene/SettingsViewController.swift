//
//  SettingsViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
  func displayData(viewModel: Settings.Model.ViewModel)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tabBarTitle: UILabel!
    
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic)?

  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = SettingsInteractor()
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
      setup()
      navigationBarSetup()
  }
    
    private func navigationBarSetup() {
        let x = -(view.frame.width / 2) + 10
        let y = view.frame.origin.y - ((navigationController?.navigationBar.frame.height ?? 0) / 2)
        let height = navigationController?.navigationBar.frame.height ?? 0
        let width = view.frame.width / 2
        tabBarTitle.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}

extension SettingsViewController: SettingsDisplayLogic {
    func displayData(viewModel: Settings.Model.ViewModel) {

    }
}
