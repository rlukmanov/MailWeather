//
//  DetailTableViewCell.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconWeatherImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    weak var viewModel: TableViewCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            timeLabel.text = viewModel.dt
            descriptionLabel.text = viewModel.weatherDescription
            temperatureLabel.text = viewModel.temperature
            humidityLabel.text = viewModel.humidity
            precipitationLabel.text = viewModel.precipitation
            
            viewModel.loadImage.bind(listener: { [unowned self] in
                self.iconWeatherImageView.image = $0
            })
        }
    }
}
