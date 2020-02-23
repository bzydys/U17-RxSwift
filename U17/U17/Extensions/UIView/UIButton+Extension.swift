

//
//  UIButton+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//



import UIKit
extension UIButton {

    // MARK: - 链式语法设置button属性
    @discardableResult func set(font:UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult func set(color:UIColor,state:UIControl.State = .normal) -> Self {
        self.setTitleColor(color , for: state)
        return self
    }
    
    @discardableResult func set(title:String?) -> Self {
        self.setTitle(title, for: .normal)
        return self
    }
    
    /// 更改button字体样式
    func setTitleFont(str: String) {
        let strArray = str.components(separatedBy: " ")
        if strArray.count == 2 {
            let strNum = NSMutableAttributedString.init(string: strArray[0], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18, weight: .bold)])
            let strSuffix = NSMutableAttributedString.init(string: strArray[1], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15, weight: .regular)])
            strNum.append(NSMutableAttributedString.init(string: " "))
            strNum.append(strSuffix)
            self.titleLabel?.attributedText = strNum
        }
    }
    
    /// 设置正常和高亮下的图片,防止点击长按是自动渲染
    ///
    /// - Parameters:
    ///   - image: 给UIImageView设置值
    ///   - backgroundImage: 给background设置.不传则清空
    func zf_set(image:UIImage? = nil , backgroundImage:UIImage? = nil) {
        setImage(image, for: UIControl.State.normal)
        setImage(image, for: UIControl.State.highlighted)
        setBackgroundImage(backgroundImage, for: UIControl.State.normal)
        setBackgroundImage(backgroundImage, for: UIControl.State.highlighted)
    }
    
    /// 设置图片默认图片和渲染高亮图片
    func ib_set(tintImage:UIImage?,highlighted:UIColor = UIColor.black){
        setImage(tintImage, for: UIControl.State.normal)
        setImage(tintImage?.render(tintColor: highlighted), for: UIControl.State.highlighted)
        setImage(tintImage?.render(tintColor: highlighted), for: UIControl.State.selected)
    }
    
    func set(backgroundImage:UIImage)  {
        self.setBackgroundImage(backgroundImage, for: .normal)
    }
    
    func set(highlightedBackgroundImage:UIImage){
        self.setBackgroundImage(highlightedBackgroundImage, for: .highlighted)
    }
    
    func layoutVertical(titleMargin : CGFloat,topOffset:CGFloat){
        sizeToFit()
        self.titleLabel?.textAlignment = .center
        let imageSize:CGSize = self.imageView!.frame.size
        let titleSize:CGSize = self.titleLabel!.frame.size
        self.titleEdgeInsets = UIEdgeInsets(top: 0 + topOffset, left:-imageSize.width, bottom: -imageSize.height - titleMargin, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - titleMargin + topOffset, left: 0, bottom: 0, right: -titleSize.width)
    }
    
    func layoutHorizontal(titleMargin : CGFloat , topOffset : CGFloat = 0) {
        sizeToFit()
        let margin = titleMargin / 2.0
        let top = topOffset / 2.0
        titleEdgeInsets = UIEdgeInsets(top: top, left: margin, bottom: -top, right: -margin)
        imageEdgeInsets = UIEdgeInsets(top: top, left: -margin, bottom: -top, right: margin)
    }
    
}
