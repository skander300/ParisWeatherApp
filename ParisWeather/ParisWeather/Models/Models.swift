//
//  Models.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 01/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import Foundation

let OWAKey = "75b1739eabf0820a5e4d516a571fe387"

// MARK: - Forecast Response
struct ForecastResponse: Codable {
    let message: String?
    let cod: Int
    let cnt: Int?
    let list: [Forecast]?
    let city: City?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let messageString = try? values.decode(String.self, forKey: .message) {
            message = messageString
        } else if let messageInt = try? values.decode(Int.self, forKey: .message) {
            message = String(messageInt)
        } else {
            message = nil
        }
        if let codeInt = try? values.decode(Int.self, forKey: .cod) {
            cod = codeInt
        } else if let codeString = try? values.decode(String.self, forKey: .cod), let codeInt = Int(codeString) {
            cod = codeInt
        } else {
            cod = 200
        }
        cnt = try? values.decode(Int.self, forKey: .cnt)
        list = try? values.decode([Forecast].self, forKey: .list)
        city = try? values.decode(City.self, forKey: .city)
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
    let sunrise, sunset: Date
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - Forecast
struct Forecast: Codable {
    let dt: Date
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, rain, sys
        case dtTxt = "dt_txt"
    }
    
    
    var dateString: String {
        DateFormatter.dateFormatter.string(from: dt)
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}


// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: MainEnum
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .secondsSince1970
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .secondsSince1970
    }
    return encoder
}

// MARK: - URLSession response handlers

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

class BaseRequest {
    var appid: String = OWAKey
    var mode: String = "json"
    var units: String = "metric"
    var baseUrlString = "https://api.openweathermap.org/data/2.5/"
    var defaultQueries: String {
        "&mode=\(mode)&appid=\(appid)&units=\(units)"
    }
}

protocol Request {
    var url: URL? { get }
    var httpMethod : HttpMethod { get }
    var body : Data? { get }
}

class ForecastRequest: BaseRequest, Request {
    
    var url: URL? {
        URL(string: baseUrlString + "forecast" + "?q=" + city + defaultQueries)
    }
    
    var httpMethod: HttpMethod = .get
    
    var body: Data? = nil
    
    var city: String
    
    init(city: String = "Paris,fr") {
        self.city = city
    }
}

extension URLSession {
    fileprivate func codableTask<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.domainError))
                }
                return
            }
            
            let result = try? newJSONDecoder().decode(T.self, from: data)
            
            if let result = result, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }
    }

    
    fileprivate func codableTask<T: Codable>(with request: Request, completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        var urlRequest = URLRequest(url: request.url!)
        print("URl: \(String(describing: request.url))")
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.body
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return self.codableTask(with: urlRequest, completion: completion)
    }

    func forecastTask(with city: String, completionHandler: @escaping (Result<ForecastResponse, NetworkError>) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: ForecastRequest(city: city), completion: completionHandler)
    }
}
