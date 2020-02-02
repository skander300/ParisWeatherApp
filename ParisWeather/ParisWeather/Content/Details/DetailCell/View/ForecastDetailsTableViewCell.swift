//
//  ForecastDetailTableViewCell.swift
//  ParisWeather
//
//  Created by Skander Fathallah on 02/02/2020.
//  Copyright © 2020 Skander. All rights reserved.
//

import UIKit

class ForecastDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var forecastDetailIconImageView: UIImageView!
    @IBOutlet weak var forecastDetailKeyLabel: UILabel!
    @IBOutlet weak var forecastDetailValueLabel: UILabel!
    
    var row : Int!
    
    var viewModel: ForecastDetailsViewModel! {
         didSet {
             populate()
         }
     }

    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.makeShadow()
        containerView.makeRoundCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        containerView.backgroundColor = selected ? UIColor.gray : UIColor
        .white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        containerView.backgroundColor = highlighted ? UIColor.gray : UIColor
        .white
    }
    
    func populate() {
        switch row {
        case 0:
            self.forecastDetailIconImageView.image = UIImage(named: "sunriseIcon")
            self.forecastDetailKeyLabel.text = "Sunrise"
            self.forecastDetailValueLabel.text =  viewModel.sunrise
        case 1:
            self.forecastDetailIconImageView.image = UIImage(named: "sunsetIcon")
            self.forecastDetailKeyLabel.text = "Sunset"
            self.forecastDetailValueLabel.text =  viewModel.sunset
        case 2:
            self.forecastDetailIconImageView.image = UIImage(named: "rainIcon")
            self.forecastDetailKeyLabel.text = "Chance of rain"
            self.forecastDetailValueLabel.text =  viewModel.chanceOfRain
        case 3:
            self.forecastDetailIconImageView.image = UIImage(named: "windIcon")
            self.forecastDetailKeyLabel.text = "Wind"
            self.forecastDetailValueLabel.text =  viewModel.wind
        case 4:
            self.forecastDetailIconImageView.image = UIImage(named: "humidityIcon")
            self.forecastDetailKeyLabel.text = "Humidity"
            self.forecastDetailValueLabel.text =  viewModel.humidity
        case 5:
            self.forecastDetailIconImageView.image = UIImage(named: "tempIcon")
            self.forecastDetailKeyLabel.text = "Feels like"
            self.forecastDetailValueLabel.text =  viewModel.feelsLike
        case 6:
            self.forecastDetailIconImageView.image = UIImage(named: "pressureIcon")
            self.forecastDetailKeyLabel.text = "Pressure"
            self.forecastDetailValueLabel.text =  viewModel.pressure
        default: break
        }
    }
    
}
