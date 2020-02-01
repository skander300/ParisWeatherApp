//
//  HomeCellViewModel.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 01/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import Foundation

struct HomeCellViewModel {
    let forecast: Forecast
}

extension HomeCellViewModel {
    var iconUrl: URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(self.forecast.weather.first?.icon ?? "")@2x.png")
    }
    
    var date: String? {
        if Calendar.current.isDateInToday(self.forecast.dt) {
            return "Today"
        } else {
            return DateFormatter.dateFormatter.string(from: self.forecast.dt)
        }
    }
    
    var comment: String? {
        return self.forecast.weather.first?.weatherDescription.capitalized
    }
    
    var secondComment: String? {
        return "Chance of rain: \(NumberFormatter.percentFormatter.string(from: NSNumber(value: self.forecast.rain?.the3H ?? 0)) ?? "0 %")"
    }
    
    var averageTemperature: String? {
        return MeasurementFormatter.temperatureFormatter.string(from: self.forecast.main.temp)
    }
    
    var rangeTemperature: String? {
        return "\(MeasurementFormatter.temperatureFormatter.string(from: self.forecast.main.tempMax))/\(MeasurementFormatter.temperatureFormatter.string(from: self.forecast.main.tempMin))"
    }
    
}

extension Locale {
    static let frFr = Locale(identifier: "fr_FR")
}


extension NumberFormatter {
    static var percentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.percentSymbol = "%"
        formatter.locale = Locale.frFr
        return formatter
    }
    
    static var temperatureFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        return formatter
    }
}

extension MeasurementFormatter {
    static var temperatureFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter = NumberFormatter.temperatureFormatter
        formatter.unitStyle = .medium
        formatter.unitOptions = .temperatureWithoutUnit
        formatter.locale = Locale.frFr
        return formatter
    }
    
    func string(from value: Double) -> String {
        let measurement = Measurement(value: floor(value), unit: UnitTemperature.celsius)
        return string(from: measurement)
    }
}

extension DateFormatter {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM"
        return formatter
    }
}
