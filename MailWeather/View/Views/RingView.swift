//
//  RingView.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit

class RingView: UIView {
    
    // MARK: - properties
    
    @IBInspectable var ringColor: UIColor = .white
    @IBInspectable var lineWidth: CGFloat = 27.0
    private var radius: CGFloat?
    private var ringLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = .none
    }
    
    // MARK: - layoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        radius = layer.frame.height / 2
        
        let shapeLayer = drawRing(startAngle: CGFloat(-Double.pi / 2),
                                  endAngle: CGFloat(Double.pi * 1.5),
                                  ringColor: ringColor)
        
        guard let ringLayer = shapeLayer else { return }
        
        ringLayer.strokeEnd = 0.0
        self.ringLayer = ringLayer
        
        layer.addSublayer(ringLayer)
    }
    
    // MARK: - drawRing
    
    func drawRing(startAngle: CGFloat, endAngle: CGFloat, ringColor: UIColor) -> CAShapeLayer? {
        guard var radius = radius else { return nil }
        let centerView = CGPoint(x: radius,
                                 y: radius)
        
        radius -= lineWidth / 2
        
        let ringPath = UIBezierPath(arcCenter: centerView,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = ringPath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = ringColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        return shapeLayer
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
