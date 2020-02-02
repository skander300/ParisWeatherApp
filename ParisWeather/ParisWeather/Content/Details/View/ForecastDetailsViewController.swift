//
//  ForecastDetailsViewController.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 02/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import UIKit

class ForecastDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ForecastDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        populate()
    }
    
    func setupViews() {
        let nib = UINib(nibName: "ForecastDetailsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ForecastDetailsTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsSelection = false
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom {
                tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: bottomPadding, right: 0)
            }
        } else {
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
    
    func populate() {
        // title = viewModel.date
    }
}


extension ForecastDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell")
        if !(cell != nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ForecastCell")
        }
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Sunrise"
            cell?.detailTextLabel?.text = viewModel.sunrise
        case 1:
            cell?.textLabel?.text = "Sunset"
            cell?.detailTextLabel?.text = viewModel.sunset
        case 2:
            cell?.textLabel?.text = "Chance of rain"
            cell?.detailTextLabel?.text = viewModel.chanceOfRain
        case 3:
            cell?.textLabel?.text = "Wind"
            cell?.detailTextLabel?.text = viewModel.wind
        case 4:
            cell?.textLabel?.text = "Humidity"
            cell?.detailTextLabel?.text = viewModel.humidity
        case 5:
            cell?.textLabel?.text = "Feels like"
            cell?.detailTextLabel?.text = viewModel.feelsLike
        case 6:
            cell?.textLabel?.text = "Pressure"
            cell?.detailTextLabel?.text = viewModel.pressure
        default: break
        }
        return cell!
    }
    
    
    
}
