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
    }
    
    func setupViews() {
        self.title = "Forecast details"
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
}


extension ForecastDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastDetailsTableViewCell") as? ForecastDetailsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.row = indexPath.row
        cell.viewModel = viewModel

        return cell
    }
    
    
    
}
