//
//  UIView+AddLine.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

public struct UIRectSide : OptionSet, RawRepresentable {
    public var rawValue: Int
    
    
//    public let rawValue: Int
    
    public static let left = UIRectSide(rawValue: 1 << 0)
    
    public static let top = UIRectSide(rawValue: 1 << 1)
    
    public static let right = UIRectSide(rawValue: 1 << 2)
    
    public static let bottom = UIRectSide(rawValue: 1 << 3)
    
    public static let all: UIRectSide = [.top, .right, .left, .bottom]
    
    
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue;
        
    }
    
}

extension UIView{
    
    
    ///画虚线边框
    func drawDashLine(strokeColor: UIColor,
                      lineWidth: CGFloat = Margin.line,
                      lineLength: Int = 10,
                      lineSpacing: Int = 5,
                      corners: UIRectSide,
                      cornerWidth:CGFloat = 0) {
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = self.bounds
        
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = strokeColor.cgColor
        
        
        
        shapeLayer.lineWidth = lineWidth
        
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        
        
        //每一段虚线长度 和 每两段虚线之间的间隔
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        if corners == .all , cornerWidth > 0{
            let roundePath = CGPath.init(roundedRect: layer.bounds, cornerWidth: cornerWidth, cornerHeight: lineWidth, transform: nil)
            shapeLayer.path = roundePath
            self.layer.addSublayer(shapeLayer)
            return
        }
        
        let path = CGMutablePath()
        
        if corners.contains(.left) {
            
            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: 0))
            
        }
        
        if corners.contains(.top){
            
            path.move(to: CGPoint(x: 0, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
        }
        
        if corners.contains(.right){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
            
            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
        }
        
        if corners.contains(.bottom){
            
            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            
            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            
        }
        
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    ///画实线边框
    func drawLine(strokeColor: UIColor, lineWidth: CGFloat = Margin.line, _ corners: UIRectSide) {
        
        if corners == UIRectSide.all {
            
            self.layer.borderWidth = lineWidth
            
            self.layer.borderColor = strokeColor.cgColor
            
        }else{
            
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.fillColor = UIColor.clear.cgColor
            
            shapeLayer.strokeColor = strokeColor.cgColor
            
            shapeLayer.lineWidth = lineWidth
            
            let path = UIBezierPath()
            
            if corners.contains(.left) {
                
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                
                path.addLine(to: CGPoint(x: 0, y: 0))
                
            }
            
            if corners.contains(.top){
                
                path.move(to: CGPoint(x: 0, y: 0))
                
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
                
            }
            
            if corners.contains(.right){
                
                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                
            }
            
            if corners.contains(.bottom){
                
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
                
            }
            
            shapeLayer.path = path.cgPath
            
            self.layer.addSublayer(shapeLayer)
        }
        
    }
    
}

