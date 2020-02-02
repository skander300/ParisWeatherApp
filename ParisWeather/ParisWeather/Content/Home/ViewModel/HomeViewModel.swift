//
//  HomeViewModel.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 01/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import Foundation

protocol HomeDelegate {
    func didReceiveForecasts()
    func didFail(with error: Error)
}

class HomeViewModel {
    
    var homeCellViewModels: [HomeCellViewModel]
    var forecatDetailsViewModels: [ForecastDetailsViewModel]
    var delegate: HomeDelegate
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
        self.homeCellViewModels = []
        self.forecatDetailsViewModels = []
    }
    
    fileprivate func success(_ forecast: ForecastResponse) {
        var onedayList: [[Forecast]] = []
        let dictionary = Dictionary(grouping: forecast.list!) { $0.dateString }
        dictionary.forEach { (key, list) in
            onedayList.append(list)
        }
        self.homeCellViewModels = onedayList.map{ HomeCellViewModel(forecast: $0.first!) }
        self.forecatDetailsViewModels = onedayList.map{ ForecastDetailsViewModel(forecasts: $0, city: forecast.city!) }
        self.delegate.didReceiveForecasts()
    }
    
    func getForecasts(with city: String) {
        let session = URLSession.shared
        let task = session.forecastTask(with: city) { [unowned self] (result) in
            switch (result) {
            case .success(let forecast): 
                self.success(forecast)
            case .failure(let error):
                self.delegate.didFail(with: error)
                print(error)
            }
        }
        task.resume()
    }
    
}


extension HomeViewModel {
    func homeCellViewCell(at index: Int) -> HomeCellViewModel {
        self.homeCellViewModels[index]
    }
    
    func forecastDetailsViewCell(at index: Int) -> ForecastDetailsViewModel {
        self.forecatDetailsViewModels[index]
    }
}
