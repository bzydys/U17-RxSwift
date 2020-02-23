
//
//  UIColor+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit
// MARK: - 代码规范
extension UIColor {
    /// #5829DB -> B0
    public static let B0 = #colorLiteral(red: 0.3450980392, green: 0.1607843137, blue: 0.8588235294, alpha: 1)
    /// #3C2DC3 -> B1
    public static let B1 = #colorLiteral(red: 0.2352941176, green: 0.1764705882, blue: 0.7647058824, alpha: 1)
    /// #221A70 -> B2
    public static let B2 = #colorLiteral(red: 0.1333333333, green: 0.1019607843, blue: 0.4392156863, alpha: 1)
    /// #E3D9FF -> B3
    public static let B3 = #colorLiteral(red: 0.8901960784, green: 0.8509803922, blue: 1, alpha: 1)
    /// #6B46D0 -> B4
    public static let B4 = #colorLiteral(red: 0.4196078431, green: 0.2745098039, blue: 0.8156862745, alpha: 1)
    /// #C5C3D6 -> B5
    public static let B5 = #colorLiteral(red: 0.7725490196, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
    /// #C9C5EB -> B6
    public static let B6 = #colorLiteral(red: 0.7882352941, green: 0.7725490196, blue: 0.9215686275, alpha: 1)
    /// #5829DB -> B7
    public static let B7 = #colorLiteral(red: 0.3450980392, green: 0.1607843137, blue: 0.8588235294, alpha: 0.06)
    /// #3920BA -> B8
    public static let B8 = #colorLiteral(red: 0.2235294118, green: 0.1254901961, blue: 0.7294117647, alpha: 1)
    
    /// #1C1C21 -> T0
    public static let T0 = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1294117647, alpha: 1)
    /// #34333D -> T1
    public static let T1 = #colorLiteral(red: 0.2039215686, green: 0.2, blue: 0.2392156863, alpha: 1)
    /// #4C4B59 -> T2
    public static let T2 = #colorLiteral(red: 0.2980392157, green: 0.2941176471, blue: 0.3490196078, alpha: 1)
    /// #7F7C94 -> T3
    public static let T3 = #colorLiteral(red: 0.4980392157, green: 0.4862745098, blue: 0.5803921569, alpha: 1)
    /// #A8A5C4 -> T4
    public static let T4 = #colorLiteral(red: 0.6588235294, green: 0.6470588235, blue: 0.768627451, alpha: 1)
    
    /// #FFFFFF -> L0
    public static let L0 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    /// #FAFAFF -> L1
    public static let L1 = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
    /// #F5F5FA -> L2
    public static let L2 = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9803921569, alpha: 1)
    /// #E9E9F0 -> L3
    public static let L3 = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9411764706, alpha: 1)
    /// #F7F7FC -> L4 tableView 分割线
    public static let L4 = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9882352941, alpha: 1)
    
    /// #04C291 -> C0
    public static let C0 = #colorLiteral(red: 0.01568627451, green: 0.7607843137, blue: 0.568627451, alpha: 1)
    /// #FE3F22 -> C1
    public static let C1 = #colorLiteral(red: 0.9960784314, green: 0.2470588235, blue: 0.1333333333, alpha: 1)
    /// #FF3D1F -> C2
    public static let C2 = #colorLiteral(red: 1, green: 0.2392156863, blue: 0.1215686275, alpha: 1)
    /// #03D49E -> C3
    public static let C3 = #colorLiteral(red: 0.01176470588, green: 0.831372549, blue: 0.6196078431, alpha: 1)
    /// #E54E40
    public static let C4 = #colorLiteral(red: 0.8980392157, green: 0.3058823529, blue: 0.2509803922, alpha: 1)
    
    public static func hex(_ hexString : String) -> UIColor{
        return _HexColor(hexString)
    }
}

// MARK: - 渐变色
extension UIColor{
    
    /// 从一个颜色渐变到另一个颜色
    ///
    /// - Parameters:
    ///   - from: 原始色
    ///   - to: 最终色
    ///   - distance: 举例原始色百分比 0.0 - 1.0
    /// - Returns:目标色
    class func gradientColor(from:UIColor,to:UIColor,distance:CGFloat)->UIColor{
        
        let left = from.cgColor.components
        let right = to.cgColor.components
        
        let leftComponents = left!.count == 4 ? left! : [left![0],left![0],left![0],left![1]]
        
        let rightComponents = right!.count == 4 ? right! : [right![0],right![0],right![0],right![1]]
        
        var newComponents = [CGFloat]()
        for i in 0..<4{
            newComponents.append((rightComponents[i] - leftComponents[i]) * distance + leftComponents[i])
        }
        return UIColor.init(red: newComponents[0], green: newComponents[1], blue: newComponents[2], alpha: newComponents[3])
    }
    
}

// MARK: - 十六进制字符串转UIColor
// 16->Color
public func _HexColor(_ hexString : String) -> UIColor{
    
    let colorSet : [String] = hexString.components(separatedBy: " ")
    let color = NSString(string: (colorSet.first?.replacingOccurrences(of: "#", with: ""))!)
    let alpha = NSString(string: (colorSet.last!.replacingOccurrences(of: "%", with: "")))
    let rStr = color.substring(with: NSRange(location: 0, length: 2))
    let gStr = color.substring(with: NSRange(location: 2, length: 2))
    let bStr = color.substring(with: NSRange(location: 4, length: 2))
    
    var r : UInt32 = 0
    var g : UInt32 = 0
    var b : UInt32 = 0
    var a : Int32 = 100
    Scanner(string: rStr).scanHexInt32(&r)
    Scanner(string: gStr).scanHexInt32(&g)
    Scanner(string: bStr).scanHexInt32(&b)
    Scanner(string: alpha as String).scanInt32(&a)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
}
