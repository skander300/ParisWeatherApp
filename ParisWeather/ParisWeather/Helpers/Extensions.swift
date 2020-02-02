//
//  Extensions.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 02/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import UIKit


extension UIViewController {
    
    var isLoading: Bool {
        get {
            view.viewWithTag(99999999) != nil
        }
        set {
            if newValue {
                stopLoading()
                startLoading()
            } else {
                stopLoading()
            }
        }
    }
    
    func startLoading() {
        let container = UIView()
        container.tag = 99999999
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = UIColor.black
        indicator.startAnimating()
        if #available(iOS 13.0, *) {
            indicator.color = UIColor.systemGray
        }
        container.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [indicator.centerYAnchor.constraint(equalTo: container.centerYAnchor),
             indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor)] )
        
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [container.leftAnchor.constraint(equalTo: view.leftAnchor),
             container.topAnchor.constraint(equalTo: view.topAnchor),
             container.rightAnchor.constraint(equalTo: view.rightAnchor),
             container.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    func stopLoading() {
        if let indicatorContainer = view.viewWithTag(99999999) {
            indicatorContainer.removeFromSuperview()
        }
    }
    
}


extension UIViewController {
    
    func showAlert(with title: String = "Alert", message: String) {
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func showAlert(with error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
}
