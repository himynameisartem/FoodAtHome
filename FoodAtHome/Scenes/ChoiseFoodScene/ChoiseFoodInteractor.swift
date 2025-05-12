//
//  ChoiseFoodInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

protocol ChoiseFoodBusinessLogic {
    func fetchCategories(request: ChoiseFoodModel.FetchCategories.Request)
    func fetchFoodList(request: ChoiseFoodModel.FetchFood.Request)
    func fetchItem(request: ChoiseFoodModel.FetchItem.Request)
}

protocol ChoiseFoodDataStore {
    var food: [FoodItem] { get }
    var addFood: FoodRealm { get }
}

class ChoiseFoodInteractor: ChoiseFoodBusinessLogic, ChoiseFoodDataStore {
    
    var presenter: ChoiseFoodPresentationLogic?
    private let worker: ChoiseFoodWorkerProtocol
    
    init (worker: ChoiseFoodWorkerProtocol) {
        self.worker = worker
    }
    
    var food: [FoodItem] = []
    var addFood = FoodRealm()
    
    func fetchCategories(request: ChoiseFoodModel.FetchCategories.Request) {
        let categoriesName = FoodType.allCases.map {$0.rawValue.localized()}
        let response = ChoiseFoodModel.FetchCategories.Response(categoriesName: categoriesName)
        presenter?.presentCategories(response: response)
    }
    
    func fetchFoodList(request: ChoiseFoodModel.FetchFood.Request) {
        DataManager.shared.fetchFoodData { food in
            self.food = food
        }
        if request.category != nil  {
            guard let category = request.category?.rawValue else { return }
            let responce = ChoiseFoodModel.FetchFood.Response(food: food.filter {$0.type == category})
            presenter?.presentFood(response: responce)
        }  else if request.name != nil {
            guard let searchText = request.name else { return }
                let filteredFoodList = food.filter { (food: FoodItem) in
                if !searchText.isEmpty {
                    return food.name.localized().lowercased().contains(searchText.lowercased())
                } else {
                    return false
                }
            }
            let response = ChoiseFoodModel.FetchFood.Response(food: filteredFoodList)
            presenter?.presentFood(response: response)
        }
    }
    
    func fetchItem(request: ChoiseFoodModel.FetchItem.Request) {
        addFood = worker.fetchItemForAddFoodMenu(from: request.foodName)
        let response = ChoiseFoodModel.FetchItem.Response()
        presenter?.presentItem(response: response)
    }
}
