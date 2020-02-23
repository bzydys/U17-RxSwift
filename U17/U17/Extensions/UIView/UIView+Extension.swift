//
//  UIView+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit
import SnapKit

extension UIView {

    var rootNavController : UINavigationController?
    {
        get
        {
            //取出下一响应者
            var responder = self.next
            //循环判断下一响应者的下一响应者
            while responder != nil
            {
                //判断是不是nav
                if let nav = (responder as? UIViewController)?.navigationController
                {
                    return nav
                }
                
                //不是的话就判断改变responder为下一响应者进入下一个循环
                responder = responder?.next
            }
            //如果没有的话,返回 keywindow 的控制器
            return (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.selectedViewController as? UINavigationController
        }
    }
    
    convenience public init(color:UIColor) {
        self.init()
        self.backgroundColor = color
    }
    
    func maskToRound(width : CGFloat){
        layer.cornerRadius = width
        layer.masksToBounds = true
    }
    
    func maskToRound(_ corners : UIRectCorner = .allCorners , width : CGFloat? = nil){
        layoutIfNeeded()
        let bezier = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: width == nil ? bounds.size : CGSize.init(width: width!, height: width!))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = bezier.cgPath
        layer.mask = mask
    }
    
    func ib_corner(radius:CGFloat = 5,color:UIColor){
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = radius
    }
    
    /// 截取UIView 为一个 UIImage
    func renderLayerToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
}

// MARK: - 快速改变frame

extension UIView {
    
    public var zf_x: CGFloat {
        
        get {
            return self.frame.origin.x
        }
        
        set(newVal) {
            var zf_frame: CGRect = self.frame
            zf_frame.origin.x = newVal
            self.frame = zf_frame
            
        }
        
    }
    
    
    public var zf_y: CGFloat {
        
        get {
            return self.frame.origin.y
        }
        
        set(newVal) {
            var zf_frame: CGRect = self.frame
            zf_frame.origin.y = newVal
            self.frame = zf_frame
            
        }
        
    }
    
    public var zf_width: CGFloat {
        
        get {
            return self.frame.size.width
        }
        
        set(newVal) {
            var zf_frame: CGRect = self.frame
            zf_frame.size.width = newVal
            self.frame = zf_frame
            
        }
        
    }
    
    public var zf_height: CGFloat {
        
        get {
            return self.frame.size.height
        }
        
        set(newVal) {
            var zf_frame: CGRect = self.frame
            zf_frame.size.height = newVal
            self.frame = zf_frame
            
        }
        
    }
    
    public var zf_size: CGSize {
        
        get {
            return self.frame.size
        }
        
        set(newVal) {
            var zf_frame: CGRect = self.frame
            zf_frame.size = newVal
            self.frame = zf_frame
            
        }
        
    }
    
    public var zf_centerX: CGFloat {
        
        get {
            return self.center.x
        }
        
        set(newVal) {
            var zf_center: CGPoint = self.center
            zf_center.x = newVal
            self.center = zf_center
            
        }
        
    }
    
    public var zf_centerY: CGFloat {
        
        get {
            return self.center.y
        }
        
        set(newVal) {
            var zf_center: CGPoint = self.center
            zf_center.y = newVal
            self.center = zf_center
            
        }
        
    }
    
}

extension UIView {
    func blur(style: UIBlurEffect.Style) {
        unBlur()
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        insertSubview(blurEffectView, at: 0)
        blurEffectView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    func unBlur() {
        subviews.filter { (view) -> Bool in
            view as? UIVisualEffectView != nil
            }.forEach { (view) in
                view.removeFromSuperview()
        }
    }
}
