//
//  CAGradientLayer+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

extension CAGradientLayer {
    convenience init(colors:[UIColor],rect:CGRect){
        self.init()
        self.colors = colors.map({$0.cgColor})
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x:1.0,y: 1.0);
        frame = rect
    }
}
