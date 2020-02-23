//
//  UIImage+creat.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

extension UIImage {
    
    /// color->UIImage
    class func colorImage(_ color : UIColor,size:CGSize? = nil)->UIImage?{
        let rect = CGRect(x: 0, y: 0, width: size?.width ?? 1.0, height: size?.height ?? 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func image(_ text:String,size:(CGFloat,CGFloat),backColor:UIColor=UIColor.orange,textColor:UIColor=UIColor.white,isCircle:Bool=false) -> UIImage?{
        // 过滤空""
        if text.isEmpty { return nil }
        // 取第一个字符(测试了,太长了的话,效果并不好)
        let letter = text// (text as NSString).substring(to: 1)
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        // 拿到上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide*0.5).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(backColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        let attr = [ NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 110)]
        // 写入文字
        (letter as NSString).draw(at: CGPoint(x: minSide*0.05, y: minSide*0.4), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    class func base64Image(base64String:String)->UIImage?{
        guard let data = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) else {return nil}
        let img = UIImage(data: data)
        return img
    }
    
    class var getLaunchImage : UIImage {
        let viewSize = CGSize(width: UIScreen.main.bounds.width,
                              height: UIScreen.main.bounds.height)
        // 垂直屏幕
        let viewOr = "Portrait"
        let launchImages = (Bundle.main.infoDictionary!["UILaunchImages"]) as! [[String:String]]
        for dic in launchImages {
            let sizeString = dic["UILaunchImageSize"]!
            let sizeStringArr = sizeString.notAllow(["{","}"," "]).components(separatedBy: ",")
            let imageSize = CGSize(width: sizeStringArr.first!.cgFloatValue, height: sizeStringArr.last!.cgFloatValue)
            guard imageSize == viewSize , viewOr == dic["UILaunchImageOrientation"]! else {continue}
            return UIImage(named: dic["UILaunchImageName"]!)!
        }
        return UIImage()
    }
//    //启动图
//    + (UIImage *)getLaunchImage{
//
//    CGSize viewSize = [UIScreen mainScreen].bounds.size;
//    NSString *viewOr = @"Portrait";//垂直
//    NSString *launchImage = nil;
//    NSArray *launchImages =  [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
//
//    for (NSDictionary *dict in launchImages) {
//    CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
//
//    if (CGSizeEqualToSize(viewSize, imageSize) && [viewOr isEqualToString:dict[@"UILaunchImageOrientation"]]) {
//    launchImage = dict[@"UILaunchImageName"];
//    }
//
//
//    }
//    return [UIImage imageNamed:launchImage];
//
//    }
}
