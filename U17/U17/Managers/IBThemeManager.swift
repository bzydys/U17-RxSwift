//
//  IBThemeManager.swift
//  bss
//
//  Created by 曾凡怡 on 2017/3/9.
//  Copyright © 2017年 EParty. All rights reserved.
//

import UIKit

func _I(_ name : String,
         file: String = #file,
         method: String = #function,
         line: Int = #line)->UIImage{
    return imageWithName(name,file: file,method: method,line: line)
}

/// 国家化读取字符串
///
/// - Parameters:
///   - key: 需要读取的key
///   - comment: 字符串的注释
/// - Returns: 返回 value
func _C(_ key:String, comment:String = "default") -> (String){
    return LocalizationTool.shareInstance.valueWithKey(key: key)
}


fileprivate func imageWithName(_ name : String,
                   file: String,
                   method: String,
                   line: Int) -> UIImage {
    let image = UIImage(named: name)
    assert(image != nil, "❌ <\((file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: ""))>SEL(\(method))[\(line)]: 本地图片<\(name)>不存在 \nassert")
    return image!
}


extension UIImage {
    func render(tintColor:UIColor,blendMode:CGBlendMode = .destinationIn)->UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, false,0)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        
        // 图层混合模式中
        // 问题: 到底谁是源色 谁是目标色
        // 我的解决思路:使用 kCGBlendModeCopy(R = S) 方式混合,看看什么颜色来确定谁是源色谁是目标色
        // 思考一下: 遮罩是怎么实现的?
        // UIView mask
        
        // r g b a
        // S -> 代表图片 ,D -> tintColor
        // R 结果色
        // D 目标色
        // S 源色
        //kCGBlendModeSourceIn R = S*Da
        //kCGBlendModeSourceOut R = S*(1 - Da)
        //kCGBlendModeDestinationOut R = D*(1 - Sa)
        draw(in: bounds, blendMode: blendMode, alpha: 1)
        if blendMode != .destinationIn {
            draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        }
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }

}

