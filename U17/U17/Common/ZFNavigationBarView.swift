//
//  ZFNavigationBarView.swift
//  Lark
//
//  Created by ZengFanyi on 2019/2/27.
//  Copyright © 2019 曾凡怡. All rights reserved.
//

import UIKit

class ZFNavigationBarView: UIView {
    
    var leftItem = InsetRectButton()
    
    var rightItem = InsetRectButton()
    
    let titleLabel = UILabel().set(font: .PS16).set(color: .L0)
    
    let separatorLine = UIView(color: .L4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 初始化
    func setupUI()  {
        addSubview(leftItem)
        addSubview(rightItem)
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        
        leftItem.setContentHuggingPriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        leftItem.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        
        rightItem.setContentHuggingPriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        rightItem.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        
    }
    
    func showSeperatorLine() {
        addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    
    /// 自动布局代码
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}

class ZFCustomNavView: UIView {
    
    let navBar = ZFNavigationBarView()
    
    var navBarHeight : CGFloat {return NAVHEIGHT}
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        navBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: navBarHeight)
        addSubview(navBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 自动布局代码
    override func layoutSubviews() {
        rightItem_layout()
        leftItem_layout()
        titleLabel_layout()
        
        super.layoutSubviews()
    }
    
    func setupLightUI(){
        navBar.titleLabel.set(font: .PS16).textColor = .T1
        navBar.backgroundColor = .L0
    }
    
    func setupDarkUI(){
        navBar.titleLabel.set(font: .PS16).textColor = .L0
        navBar.backgroundColor = .B0
    }
    
    
    func rightItem_layout(){
        navBar.rightItem.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(Margin.trailing).priority(1000)
            make.centerY.equalToSuperview().offset(statusBarHeight / 2)
        }
    }
    
    func titleLabel_layout(){
        navBar.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(statusBarHeight / 2)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    func leftItem_layout(){
        navBar.leftItem.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(Margin.leading).priority(1000)
            make.centerY.equalToSuperview().offset(statusBarHeight / 2)
        }
    }
}


