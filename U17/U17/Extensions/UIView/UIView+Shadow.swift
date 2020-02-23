//
//  UIView+Shadow.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIView {
    func setGrayShadow(radius:CGFloat = 10,
                       shadowColor:CGColor,
                       opacity:Float = 0.35,
                       offset : CGSize = CGSize(width: 0, height: 3)) {
        layer.cornerRadius = radius
        layer.shadowColor = shadowColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = 3
        layer.masksToBounds = false
    }
}
