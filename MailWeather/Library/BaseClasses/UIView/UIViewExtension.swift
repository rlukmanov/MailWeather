//
//  UIViewExtension.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 23.11.2020.
//

import UIKit

extension UIView {
    
    func fade(toAlpha alpha: CGFloat, withDuration duration: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }) { _ in
            completion?()
        }
    }
}
