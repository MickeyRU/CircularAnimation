//
//  CircularLoaderView.swift
//  CircularAnimation
//
//  Created by Павел Афанасьев on 09.11.2022.
//

import UIKit

class CircularLoaderView: UIView {
    
    let circularPathLayer = CAShapeLayer()
    let circularRadius: CGFloat = 20
    
    var progress: CGFloat {
        get {
            circularPathLayer.strokeEnd
        }
        set {
            if newValue > 1 {
                circularPathLayer.strokeEnd = 1
            } else if newValue < 0 {
                circularPathLayer.strokeEnd = 0
            } else {
                circularPathLayer.strokeEnd = newValue
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circularPathLayer.frame = bounds
        circularPathLayer.path = circularPath().cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        progress = 0
        confgure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Графическая настройка
    func confgure() {
        circularPathLayer.frame = bounds //размер
        circularPathLayer.lineWidth = 5 // толщина линий
        circularPathLayer.fillColor = UIColor.clear.cgColor //заполнение при старте должно отсутствовать
        circularPathLayer.strokeColor = UIColor.orange.cgColor //заполнение при работе цветное
        layer.addSublayer(circularPathLayer) // добавляем на слой
    }
    
    func circularFrame() -> CGRect {
        var circularFrame = CGRect(x: 0, y: 0, width: 2 * circularRadius, height: 2 * circularRadius)
        let circularPathBounds = circularPathLayer.bounds
        circularFrame.origin.x = circularPathBounds.midX - circularFrame.midX
        circularFrame.origin.y = circularPathBounds.midY - circularFrame.midY
        return circularFrame
    }
    
    func circularPath() -> UIBezierPath {
        UIBezierPath.init(ovalIn: circularFrame())
    }
    
    func reveal() {
        backgroundColor = .clear
        progress = 1
        
        circularPathLayer.removeAnimation(forKey: "strokeEnd")
        circularPathLayer.removeFromSuperlayer()
        
        superview?.layer.mask = circularPathLayer
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let finalRadius = sqrt((center.x * center.x) + (center.y * center.y))
        let radiusInset = finalRadius - circularRadius
        let outerRect = circularFrame().insetBy(dx: -radiusInset, dy: -radiusInset)
        let toPaht = UIBezierPath(ovalIn: outerRect).cgPath
        
        let fromPath = circularPathLayer.path
        let fromLineWidth = circularPathLayer.lineWidth
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        circularPathLayer.lineWidth = 2 * finalRadius
        circularPathLayer.path = toPaht
        CATransaction.commit()
        
        let lineWidtAnimation = CABasicAnimation(keyPath: "likeWidth")
        lineWidtAnimation.fromValue = fromLineWidth
        lineWidtAnimation.toValue = 2 * finalRadius
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPaht
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        groupAnimation.animations = [pathAnimation, lineWidtAnimation]
        groupAnimation.delegate = self
        circularPathLayer.add(groupAnimation, forKey: "strokeWidth")
    }
}

extension CircularLoaderView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        superview?.layer.mask = nil
    }
}
