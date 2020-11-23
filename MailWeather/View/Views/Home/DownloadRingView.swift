//
//  RingView.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit

class DownloadRingView: UIView {
    
    // MARK: - Properties
    
    @IBInspectable var lineWidth: CGFloat = 27 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    @IBInspectable var duration: TimeInterval = 1
    
    private var startColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0) {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    private var endColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    private var startAngle: CGFloat = 0 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    private var endAngle: CGFloat = 270 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        alpha = 0

        let gradations = 250
        
        var startColorR: CGFloat = 0
        var startColorG: CGFloat = 0
        var startColorB: CGFloat = 0
        var startColorA: CGFloat = 0

        var endColorR: CGFloat = 0
        var endColorG: CGFloat = 0
        var endColorB: CGFloat = 0
        var endColorA: CGFloat = 0

        startColor.getRed(&startColorR,
                          green: &startColorG,
                          blue: &startColorB,
                          alpha: &startColorA)
        
        endColor.getRed(&endColorR,
                        green: &endColorG,
                        blue: &endColorB,
                        alpha: &endColorA)

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        var angle = startAngle

        for i in 1 ... gradations {
            let extraAngle = (endAngle - startAngle) / CGFloat(gradations)
            let currentStartAngle = angle
            let currentEndAngle = currentStartAngle + extraAngle

            let currentR = ((endColorR - startColorR) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorR
            let currentG = ((endColorG - startColorG) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorG
            let currentB = ((endColorB - startColorB) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorB
            let currentA = ((endColorA - startColorA) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorA

            let currentColor = UIColor(red: currentR, green: currentG, blue: currentB, alpha: currentA)

            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .butt
            path.addArc(withCenter: center,
                        radius: radius,
                        startAngle: currentStartAngle * CGFloat(Double.pi / 180.0),
                        endAngle: currentEndAngle * CGFloat(Double.pi / 180.0),
                        clockwise: true)
            currentColor.setStroke()
            path.stroke()
            angle = currentEndAngle
        }
    }
    
    // MARK: - Animations
    
    func startDownloadAnimation() {
        fade(toAlpha: 1.0, withDuration: 1.0)
        rotateAnimation(withDuration: duration)
    }
    
    func stopDownloadAnimation() {
        fade(toAlpha: 0.0, withDuration: 1.0) { [unowned self] in
            self.layer.removeAllAnimations()
        }
    }
    
    private func rotateAnimation(withDuration duration: TimeInterval) {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }
}
