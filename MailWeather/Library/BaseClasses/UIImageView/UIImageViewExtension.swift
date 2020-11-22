//
//  UIImgeViewExtension.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 22.11.2020.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else { return }
        
        DispatchQueue.global().async { [weak self] in
            
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
