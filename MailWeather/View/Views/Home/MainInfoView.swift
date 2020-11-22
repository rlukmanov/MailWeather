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
        fadeOut(toAlpha: 0.3)
    }
    
    func stopDownloadAnimation() {
        fadeIn()
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    private func fadeOut(toAlpha alpha: CGFloat) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }, completion: nil)
    }
}
