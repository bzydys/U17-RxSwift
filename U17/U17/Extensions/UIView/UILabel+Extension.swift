//
//  UILabel+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

extension UILabel {
    
    //
    func setEmpty(color:UIColor) {
        if text?.bwy_isEmpty ?? true {
            let att =
            NSAttributedString(string: text ?? "",
                               attributes: [NSAttributedString.Key.font : self.font!,
                                            NSAttributedString.Key.backgroundColor:color])
            attributedText = att
        }
    }
    
    // MARK: - 链式语法设置label属性
    @discardableResult func set(font:UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult func set(color:UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult func set(text:String?) -> Self {
        self.text = text
        return self
    }
    
    
    /// 首行缩进
    func change(firstLineSpace:CGFloat) {
        guard let text = text else {return}
        let range = text.ns_String.range(of: text)
        let attributedString = NSMutableAttributedString.init(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.firstLineHeadIndent = firstLineSpace
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        
        attributedText = attributedString
        sizeToFit()
    }
    
    /// 修改行/字间距
    func change(lineSpace: CGFloat? = nil,
                wordSpace: CGFloat? = nil){
        guard let text = text else {return}
        let range = text.ns_String.range(of: text)
        let attributedString = NSMutableAttributedString.init(string: text)
        
        // 添加行间距
        if let lineSpace = lineSpace {
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = lineSpace
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
        
        // 添加字间距
        if let wordSpace = wordSpace {
            attributedString.addAttribute(NSAttributedString.Key.kern, value: wordSpace, range: range)
        }
        
        attributedText = attributedString
        sizeToFit()
    }

}
