//
//  UIImage+ QRcode .swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

//  生成二维码封装
extension UIImage {
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - text: 文字
    ///   - size: 尺寸（正方形边长）
    /// - Returns: UIimage
    class func setQRCode(_ text: String, size: CGFloat) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setHDUIImage(outputImage, size: size)
            return qrCodeImage
        }
        return UIImage()
    }
    
    //MARK: - 生成高清的UIImage
   private class func setHDUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion)
        bitmapRef.draw(bitmapImage, in: integral)
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    
    /// 将图片缩放到指定宽度
    func scaleImage(width: CGFloat) -> UIImage?{
        let imageW = self.size.width
        let imageH = self.size.height
        //需要判断 如果图片的宽度小于缩放的宽度 就不需要缩放
        //        if imageW < width {
        //            return self
        //        }
        
        let scaleH = imageH / imageW * width
        let imageBounds = CGRect(x: 0, y: 0, width: width, height: scaleH)
        //开启图片的上下文
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, 0)
        //将图片绘制上下文中
        self.draw(in: imageBounds)
        
        //从上下文中获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭图片的上下文
        UIGraphicsEndImageContext()
        return image
    }
    
}
