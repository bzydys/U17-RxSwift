//
//  BarButtonItem+creat.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit


extension UIBarButtonItem {
    // MARK: -
    // MARK: 间距修正
    
    /// 用于navBar 增加一个间隔
    class var fixedNavBar : UIBarButtonItem
    {
        return UIBarButtonItem(customView: UIView(frame: CGRect.zero))
    }
    
    /// 用于toolBar的自动适应间隔
    class var flexibleSpace : UIBarButtonItem
    {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    }
    
    /// 给定宽度,用于toolBar
    class func fixedSpace(width:CGFloat) -> UIBarButtonItem{
        let fix = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fix.width = width
        return fix
    }
    
    convenience init(title : String? = nil , image : UIImage? = nil , highlightedImage : UIImage? = nil , target: Any?, action: Selector?) {
        let barButton = UIButton()
        //设置title
        barButton.setTitle(title, for: .normal)
        barButton.setTitleColor(UIColor.white, for: .normal)
//        barButton.setTitleColor(UIColor.init(red: 0.24, green: 0.24, blue: 0.24, alpha: 0.5), for: .highlighted)
        barButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        //设置图片
        if let image = image {
        barButton.setImage(image, for: .normal)
        }
        
        //高亮图片
        if let highlightedImage = highlightedImage {
        barButton.setImage(highlightedImage, for: .highlighted)
        }
        
        if let action = action {
            //添加target
            barButton.addTarget(target, action: action, for: .touchUpInside)
        }
        //尺寸适应
        barButton.sizeToFit()
        
        //构造.
        self.init()
        
        //添加到CustomView
        customView = barButton
    }
}
