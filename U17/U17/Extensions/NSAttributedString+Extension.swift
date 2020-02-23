//
//  NSAttributedString+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

extension NSAttributedString {
    class func title(_ title: String,color:UIColor,font:UIFont) -> NSAttributedString {
        return NSAttributedString.init(string: title, attributes: [NSAttributedString.Key.font : font
            ,NSAttributedString.Key.foregroundColor:color])
    }
    class func image(_ image: UIImage ,font:UIFont) -> NSAttributedString {
        let attach = NSTextAttachment.init()
        attach.image = image
        attach.bounds = CGRect.init(x: 0, y: font.lineHeight / 8, width: attach.image!.size.width, height: attach.image!.size.height)
        return NSAttributedString(attachment: attach)
    }
    
    class func mutable(string:[NSAttributedString]) -> NSAttributedString {
        let mutAtt = NSMutableAttributedString.init()
        for s in string {
            mutAtt.append(s)
        }
        return mutAtt.copy() as! NSAttributedString
    }
    
}
