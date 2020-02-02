//
//  HomeViewController.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 01/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        populate()
    }

    func setupViews() {
        title = "Paris"
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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
        isLoading = true
        viewModel = HomeViewModel(delegate: self)
        viewModel.getForecasts(with: "Paris,fr")
    }
}

extension HomeViewController: HomeDelegate {
    
    func didReceiveForecasts() {
        isLoading = false
        tableView.reloadData()
    }
    
    func didFail(with error: Error) {
        isLoading = false
        showAlert(with: error)
        print(error)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.homeCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.viewModel = viewModel.homeCellViewCell(at: indexPath.row)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ForecastDetailsViewController") as? ForecastDetailsViewController else {
            return
        }
        viewController.viewModel = viewModel.forecastDetailsViewCell(at: indexPath.row)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
