//
//  UIDevice+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit



/// 设备屏幕类型
public enum ib_DeviceType {
    case iPhone4 // 480*320
    case iPhone5 // 568*320
    case iPhone6 // 667*375
    case iPhone6Plus // 736*414
    case iPhoneX // 812*375
    case iPhoneXR
    case iPhoneXsMax
}

public extension ib_DeviceType {
    var ib_pixelScale : CGFloat {
        switch self {
        case .iPhone4: return 320 / 375
        case .iPhone5: return 320 / 375
        case .iPhone6,
             .iPhoneX: return 1
        case .iPhone6Plus,
             .iPhoneXR,
             .iPhoneXsMax: return 414 / 375
        }
    }
}

//MARK: - UIDevice延展
public extension UIDevice {

    /// 是否有刘海
    var isIphoneX : Bool {
        // topImage设置
        switch UIDevice.current.ib_DeviceScreenType {
        case .iPhoneX,
             .iPhoneXR,
             .iPhoneXsMax:
            return true
        default:
            return false
        }
    }
    
    var ib_DeviceScreenType : ib_DeviceType {
        let isIpad = UIDevice.current.userInterfaceIdiom == .unspecified
        if __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 640, height: 960)) && !isIpad {return .iPhone4}
        if __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 640, height: 1136)) && !isIpad {return .iPhone5}
        if __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 750, height: 1334)) && !isIpad {return .iPhone6}
        if __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 1242, height: 2208)) && !isIpad {return .iPhone6Plus}
        if __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 1125, height: 2436)) && !isIpad {return .iPhoneX}
        if __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 828, height: 1792)) && !isIpad {return .iPhoneXR}
        if __CGSizeEqualToSize(UIScreen.main.currentMode!.size, CGSize(width: 1242, height: 2688)) && !isIpad {return .iPhoneXsMax}
        return .iPhone6
    }
    
    var ib_DeviceModelType : ib_DeviceType {
        
        switch ib_deviceModel {
            //        case "iPod1,1":  return "iPod Touch 1"
            //        case "iPod2,1":  return "iPod Touch 2"
            //        case "iPod3,1":  return "iPod Touch 3"
            //        case "iPod4,1":  return "iPod Touch 4"
            //        case "iPod5,1":  return "iPod Touch (5 Gen)"
        //        case "iPod7,1":   return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return .iPhone4//"iPhone 4"
        case "iPhone4,1":  return .iPhone4//"iPhone 4s"
        case "iPhone5,1":   return .iPhone5//"iPhone 5"
        case  "iPhone5,2":  return .iPhone5//"iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return .iPhone5//"iPhone 5c (GSM)"
        case "iPhone5,4":  return .iPhone5//"iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return .iPhone5//"iPhone 5s (GSM)"
        case "iPhone6,2":  return .iPhone5//"iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return .iPhone6//"iPhone 6"
        case "iPhone7,1":  return .iPhone6Plus//"iPhone 6 Plus"
        case "iPhone8,1":  return .iPhone6//"iPhone 6s"
        case "iPhone8,2":  return .iPhone6Plus//"iPhone 6s Plus"
        case "iPhone8,4":  return .iPhone5//"iPhone SE"
        case "iPhone9,1":   return .iPhone6//"国行、日版、港行iPhone 7"
        case "iPhone9,2":  return .iPhone6Plus//"港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return .iPhone6//"美版、台版iPhone 7"
        case "iPhone9,4":  return .iPhone6Plus//"美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return .iPhone6//"iPhone 8"
        case "iPhone10,2","iPhone10,5":   return .iPhone6Plus//"iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6","iPhone11,2":   return .iPhoneX//"iPhone X"
        case "iPhone11,4", "iPhone11,6":  return .iPhoneXsMax
        case "iPhone11,8":  return .iPhoneXR
            //        case "iPad1,1":   return "iPad"
            //        case "iPad1,2":   return "iPad 3G"
            //        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
            //        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
            //        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
            //        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
            //        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
            //        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
            //        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
            //        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
            //        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
            //        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
            //        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
            //        case "AppleTV2,1":  return "Apple TV 2"
            //        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
            //        case "AppleTV5,3":   return "Apple TV 4"
//                case "i386", "x86_64":   return .iPhone6
        default:  return .iPhone6
        }
    }
}

