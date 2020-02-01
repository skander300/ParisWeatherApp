//
//  HomeViewModel.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 01/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import Foundation

protocol HomeDelegate {
    func didReceiveForecasts(_ forecast: ForecastResponse?)
    func didFail(with error: Error)
}

class HomeViewModel {
    
    var homeCellViewModels: [HomeCellViewModel]
    var delegate: HomeDelegate
    
    init(delegate: HomeDelegate) {
        self.delegate = delegate
        self.homeCellViewModels = []
    }
    
    fileprivate func success(_ forecast: ForecastResponse) {
        var onedayList: [Forecast] = []
        forecast.list?.forEach { forecast in
            if onedayList.filter({ Calendar.current.isDate($0.dt, inSameDayAs: forecast.dt) }).count == 0 {
                onedayList.append(forecast)
            }
        }
        self.homeCellViewModels = onedayList.compactMap{ HomeCellViewModel(forecast: $0) }
        self.delegate.didReceiveForecasts(forecast)
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
        return self.homeCellViewModels[index]
    }
}
