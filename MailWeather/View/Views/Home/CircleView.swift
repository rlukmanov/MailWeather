//
//  RoundedView.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 21.11.2020.
//

import UIKit

class CircleView: UIView {
    
    // MARK: - properties
    
    @IBInspectable var roundColor: UIColor = .white {
        didSet {
            shapeLayer.fillColor = roundColor.cgColor
        }
    }
    
    private var radius: CGFloat?
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - draw
    
    override func draw(_ rect: CGRect) {
        radius = layer.frame.height / 2
        
        let centerView = CGPoint(x: radius!,
                                 y: radius!)
        
        let circlePath = UIBezierPath(arcCenter: centerView,
                                      radius: radius!,
                                      startAngle: CGFloat(-Double.pi / 2),
                                      endAngle: CGFloat(Double.pi * 1.5),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = roundColor.cgColor
        
        self.shapeLayer = shapeLayer
        
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Animations
    
    func animateScale(duration: TimeInterval, scaleFactor: CGFloat, scaleStart: CGFloat, delay: TimeInterval = 0) {
        let durationPart = duration / 2
        self.transform = CGAffineTransform(scaleX: scaleStart, y: scaleStart)
        
        UIView.animate(withDuration: durationPart, delay: delay, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }, completion: { _ in
            UIView.animate(withDuration: durationPart, delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
}
