//
//  UIView+Ext.swift
//
//  Created by Bloveocean on 2019/8/3.
//  Copyright © 2019年 Auth. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func screenShotImage() -> UIImage? {
        return screenShotImageWithSize(size: self.bounds.size)
    }
    
    private func screenShotImageWithSize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

// Shimmer
extension UIView {
    
    public func startShimmering() {
        backgroundColor = UIColor.groupTableViewBackground

        let light = UIColor(white: 0, alpha: 0.1).cgColor
        let dark = UIColor.black.cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.525)
        gradient.locations  = [0.4, 0.5, 0.6]
        
        layer.mask = gradient
        layer.addSublayer(gradient)
        
        let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue   = [0.8, 0.9, 1.0]
        
        animation.duration = 1.5
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        
        gradient.add(animation, forKey: "shimmer")
    }
    
    public func stopShimmering() {
        layer.mask = nil
    }
    
}
