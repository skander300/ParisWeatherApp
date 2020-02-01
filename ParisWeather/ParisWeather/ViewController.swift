//
//  ViewController.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 01/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let session = URLSession.shared
        let task = session.forecastTask(with: "Paris,fr") { (result) in
            switch (result) {
                case .success(let forecast):
                    print(forecast)
                case .failure(let error):
                    print(error)
            }
        }
        task.resume()
    }


}

