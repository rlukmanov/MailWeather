//
//  RoundedView.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 18.11.2020.
//

import UIKit

class CirlceView: UIView {
    
    private enum CircleType: Int {
        case onlyEdgeCircle = 0
        case fullCircle
    }
    
    // MARK: - properties
    
    @IBInspectable var roundColor: UIColor = .white
    @IBInspectable var lineWidth: CGFloat = 27.0
    @IBInspectable var circleTypeAdapter: Int {
        get {
            return self.circleType.rawValue
        }
        set(shapeIndex) {
            self.circleType = CircleType(rawValue: shapeIndex) ?? .fullCircle
        }
    }
    
    private var circleType: CircleType = .fullCircle
    private var radius: CGFloat?
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    
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
        drawCircle()
    }
    
    // MARK: - drawCircle
    
    func drawCircle() {
        guard var radius = radius else { return }
        let centerView = CGPoint(x: radius,
                                 y: radius)
        
        if circleType == .onlyEdgeCircle {
            radius -= lineWidth / 2
        }
        
        let circlePath = UIBezierPath(arcCenter: centerView,
                                      radius: radius,
                                      startAngle: CGFloat(-Double.pi / 2),
                                      endAngle: CGFloat(Double.pi * 1.5),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        if circleType == .fullCircle {
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.fillColor = roundColor.cgColor
        } else {
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = roundColor.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.strokeEnd = 0.0
        }
        
        self.shapeLayer = shapeLayer
        
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - animateCircle
    
    func animateCircle(duration: TimeInterval, delay: TimeInterval = 0) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        if delay > 0 {
            let currentLayerTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
            animation.fillMode = .backwards
            animation.beginTime = currentLayerTime + delay
        }
            
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        shapeLayer.strokeEnd = 1.0
        shapeLayer.add(animation, forKey: "animateCircle")
    }
}
