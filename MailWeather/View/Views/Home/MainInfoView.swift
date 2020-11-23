//
//  MainInfoView.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit

class MainInfoView: UIView {
    
    private var duration: TimeInterval = 0.5
    
    // MARK: - Animations
    
    func startDownloadAnimation() {
        fade(toAlpha: 0.3, withDuration: duration)
    }
    
    func stopDownloadAnimation() {
        fade(toAlpha: 1.0, withDuration: duration)
    }
}
