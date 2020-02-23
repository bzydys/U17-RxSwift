
//
//  view.swift
//  IB_iOS
//
//  Created by 曾凡怡 on 2018/9/17.
//  Copyright © 2018年 曾凡怡. All rights reserved.
//

import UIKit

protocol IBShadowViewType {
    /// 设置圆角和阴影
    func setShadow(color:UIColor,size:CGSize)
    /// 隐藏圆角和阴影
    func hideShadow()
}

extension IBShadowViewType where Self : UIView{
    
    func setShadow(color:UIColor,size:CGSize = CGSize(width: 0, height: 3))
    {
        /// 设置阴影
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 8
        layer.shadowOffset = size
        layer.shadowOpacity = 1
    }
    
    func hideShadow(){
        /// 设置阴影
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
    }
    
}

class IBShadowView : UIView , IBShadowViewType{
    var shadowColor : UIColor = .black
    var corner  :CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class CornerShadowView: UIView {
    
    private var corner  :CGFloat = 0
    
    var shadowColor : UIColor = .black
    
    var opacity : Float = 0.35
    
    var offset : CGSize = CGSize(width: 0, height: 3)
    
    lazy var shadowBoard : IBShadowView = {
        let board = IBShadowView()
        board.corner = corner
        board.shadowColor = shadowColor
        board.backgroundColor = backgroundColor
        board.layer.cornerRadius = corner
        board.setGrayShadow(radius: corner,
                            shadowColor: shadowColor.cgColor,
                            opacity: opacity,
                            offset: offset)
        return board
    }()
    
    init(corner: CGFloat,
         color : UIColor = .B7,
         frame: CGRect = .zero) {
        self.corner = corner
        self.shadowColor = color
        super.init(frame: frame)
        layer.cornerRadius = corner
        layer.masksToBounds = true
        setupUI()
    }
    
    func setupUI(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            superview?.insertSubview(shadowBoard, belowSubview: self)
            shadowBoard.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
        
    }
    
    override func removeFromSuperview() {
        shadowBoard.snp.remakeConstraints { (_) in
        }
        snp.remakeConstraints { (_) in
        }
        shadowBoard.removeFromSuperview()
        super.removeFromSuperview()
    }
    
}


class CornerShadowButton: UIButton {
    
    private var corner  :CGFloat = 0
    
    var shadowColor : UIColor = .black
    
    var opacity : Float = 0.35
    
    var offset : CGSize = CGSize(width: 0, height: 3)
    
    lazy var shadowBoard : IBShadowView = {
        let board = IBShadowView()
        board.corner = corner
        board.shadowColor = shadowColor
        board.backgroundColor = backgroundColor
        board.layer.cornerRadius = corner
        board.setGrayShadow(radius: corner,
                            shadowColor: shadowColor.cgColor,
                            opacity: opacity,
                            offset: offset)
        return board
    }()
    
    init(corner: CGFloat,
         color : UIColor = .B7,
         frame: CGRect = .zero) {
        self.corner = corner
        self.shadowColor = color
        super.init(frame: frame)
        layer.cornerRadius = corner
        layer.masksToBounds = true
        setupUI()
    }
    
    func setupUI(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            superview?.insertSubview(shadowBoard, belowSubview: self)
            shadowBoard.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
        
    }
    
    override func removeFromSuperview() {
        shadowBoard.snp.remakeConstraints { (_) in
        }
        snp.remakeConstraints { (_) in
        }
        shadowBoard.removeFromSuperview()
        super.removeFromSuperview()
    }
    
}

