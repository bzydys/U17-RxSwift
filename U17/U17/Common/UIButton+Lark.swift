//
//  UIButton+Lark.swift
//  Lark
//
//  Created by ZengFanyi on 2019/1/15.
//  Copyright © 2019 曾凡怡. All rights reserved.
//

import UIKit

extension UIButton {
    
    enum LAButtonStyle {
        case Light
        case Dark
        case Third
    }
    
    convenience init(style:LAButtonStyle,font:UIFont = .PM14){
        self.init(frame: CGRect.zero)
        switch style {
        case .Light:
            set(font: font).set(color: .B0).layer.cornerRadius = 6
            backgroundColor = .B3
        case .Dark:
            set(font: font).set(color: .L0).maskToRound(width: 6)
            setTitleColor(.L0, for: UIControl.State.disabled)
            setBackgroundImage(UIImage.colorImage(.B0)!, for: UIControl.State.normal)
            setBackgroundImage(UIImage.colorImage(.B5)!, for: UIControl.State.disabled)
        case .Third:
            set(font: font).set(color: .T3).maskToRound(width: 6)
            backgroundColor = .L0
            layer.borderColor = UIColor.L3.cgColor
            layer.borderWidth = 1
        }
    }
}
