//
//  RingView.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit

class RingView: UIView {
    
    // MARK: - properties
    
    @IBInspectable var ringColor: UIColor = .white {
        didSet {
            ringLayer.strokeColor = ringColor.cgColor
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 27.0
    private var radius: CGFloat?
    private var ringLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - draw
    
    override func draw(_ rect: CGRect) {
        radius = layer.frame.height / 2
        
        let centerView = CGPoint(x: radius!,
                                 y: radius!)
        
        radius! -= lineWidth / 2
        
        let ringPath = UIBezierPath(arcCenter: centerView,
                                    radius: radius!,
                                    startAngle: CGFloat(-Double.pi / 2),
                                    endAngle: CGFloat(3 * Double.pi / 2),
                                    clockwise: true)
        
        let ringLayer = CAShapeLayer()
        ringLayer.path = ringPath.cgPath
        
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = ringColor.cgColor
        ringLayer.lineWidth = lineWidth
        
        ringLayer.strokeEnd = 0.0
        self.ringLayer = ringLayer
        
        layer.addSublayer(ringLayer)
    }
    
    // MARK: - Animations
    
    func animateRing(duration: TimeInterval, delay: TimeInterval = 0) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        if delay > 0 {
            let currentLayerTime = ringLayer.convertTime(CACurrentMediaTime(), from: nil)
            animation.fillMode = .backwards
            animation.beginTime = currentLayerTime + delay
        }
            
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        ringLayer.strokeEnd = 1.0
        ringLayer.add(animation, forKey: "animateCircle")
    }
}
