//
//  UIImage+Ext.swift
//
//  Created by Bloveocean on 2019/8/4.
//  Copyright © 2019年 Auth. All rights reserved.
//

import Foundation
import UIKit

public enum RGMarkType: Int {
    case leftBottom = 0
    case rightBottom
    case rightTop
    case leftTop
    case none
}

extension UIImage {
    
    public static func imageWithGraiendColor(colors: [CGColor], size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: size)
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public func addWaterMark(markImage: UIImage, position: RGMarkType)   -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        var markSize = markImage.size
        var markOri = CGPoint.zero
        switch position {
        case .leftTop:
            markOri = CGPoint.zero
        case .leftBottom:
            markOri = CGPoint(x: 0, y: self.size.height - markSize.height)
        case .rightTop:
            markOri = CGPoint(x: self.size.width - markSize.width, y: 0)
        case .rightBottom:
            markOri = CGPoint(x: self.size.width - markSize.width, y: self.size.height - markSize.height)
        case .none:
            markOri = CGPoint.zero
            markSize = CGSize.zero
        default:
            markOri = CGPoint.zero
        }
        markImage.draw(in: CGRect(origin: markOri, size: markSize))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
