//
//  InsetRectButton.swift
//  Lark
//
//  Created by ZengFanyi on 2019/1/10.
//  Copyright © 2019 曾凡怡. All rights reserved.
//

import UIKit

/// 扩大点击区域的按钮
class InsetRectButton : UIButton {
    
    var isNeedInsetRect = true
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard isNeedInsetRect else {
            return super.point(inside: point, with: event)
        }
        let bounds = self.bounds
        let widthDelta = max(36, bounds.width)
        let heightDelta = max(36, bounds.height)
        let newBounds = bounds.insetBy(dx: -0.5 * widthDelta, dy: -0.5 * heightDelta)
        return newBounds.contains(point)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            return super.hitTest(CGPoint.zero, with: event)
        }else{
            return super.hitTest(point, with: event)
        }
    }
}


class LayoutButton: InsetRectButton {
    let margin : CGFloat
    init(margin:CGFloat,
         frame:CGRect = .zero) {
        self.margin = margin
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RightImageButton: LayoutButton {
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let origin = super.imageRect(forContentRect: contentRect)
        return CGRect(x: contentRect.width - origin.width + margin,
                      y: origin.origin.y,
                      width: origin.width,
                      height: origin.height)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let origin = super.titleRect(forContentRect: contentRect)
        return CGRect(x: -margin,
                      y: origin.origin.y,
                      width: origin.width,
                      height: origin.height)
    }
    
}

class TopImageButton: LayoutButton {
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let origin = super.imageRect(forContentRect: contentRect)
        return CGRect(x: (contentRect.width - origin.width) / 2 ,
                      y: -margin,
                      width: origin.width,
                      height: origin.width)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let origin = super.titleRect(forContentRect: contentRect)
        let imageOrigin = imageRect(forContentRect: contentRect)
        return CGRect(x: (contentRect.width - origin.width) / 2,
                      y: imageOrigin.origin.y + imageOrigin.height + margin,
                      width: origin.width,
                      height: origin.height)
    }
    
}

class ZFTopBottomButton : InsetRectButton {
    
    let zf_ImageView = UIImageView(image: _I("game占位"))
    
    let zf_TitleLabel = UILabel().set(font: .PR11).set(color: .T1).set(text: " ")
    
    let margin : CGFloat
    
    let iconWidth : CGFloat
    
    let titleWidht : CGFloat
    
    let iconCorner : CGFloat
    
    init(margin: CGFloat,
         iconWidth:CGFloat,
         titleWidht:CGFloat,
         corner:CGFloat = 0,
         frame: CGRect = .zero) {
        self.margin = margin
        self.iconWidth = iconWidth
        self.titleWidht = titleWidht
        self.iconCorner = corner
        super.init(frame: frame)
        
        addSubview(zf_ImageView)
        addSubview(zf_TitleLabel)
        zf_TitleLabel.textAlignment = .center
        zf_TitleLabel.lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        zf_ImageView.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(iconWidth).priority(750)
        }
        
        zf_TitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(zf_ImageView.snp.bottom).offset(margin)
            make.centerX.bottom.equalToSuperview()
            make.width.equalTo(titleWidht).priority(750)
        }
    }
    
    override func layoutSubviews() {
        setupLayout()
        super.layoutSubviews()
        if iconCorner == -1 {
            zf_ImageView.maskToRound()
        }else{
            zf_ImageView.maskToRound(width:iconCorner)
        }
    }
    
    
}
