//
//  Button.swift
//  Lark
//
//  Created by Lee on 2/1/20.
//  Copyright © 2020 曾凡怡. All rights reserved.
//

import UIKit

public class Button: UIButton {
    public enum ImagePosition {
        case left(spacing: CGFloat), right(spacing: CGFloat), top(spacing: CGFloat), bottom(spacing: CGFloat)
    }
    public var imagePosition: ImagePosition = .left(spacing: 5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var padding: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override var titleLabel: UILabel? {
        return titleView
    }
    
    public var subTitleLabel: UILabel? {
        return subTitleView
    }
    
    public override var imageView: UIImageView? {
        return buttonImageView
    }
    
    public var title: String? {
        didSet {
            self.titleView?.text = title
            setNeedsLayout()
        }
    }

    public var subTitle: String? {
        didSet {
            self.subTitleView?.text = subTitle
            setNeedsLayout()
        }
    }
    
    public var image: UIImage? {
        didSet {
            self.buttonImageView?.image = image
            setNeedsLayout()
        }
    }
    
    public var titleSpacing: CGFloat = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var titleAligment: UIStackView.Alignment = .center {
        didSet {
            titleContainer?.alignment = titleAligment
        }
    }
    
    public var imageAligment: UIStackView.Alignment = .center {
        didSet {
            container?.alignment = imageAligment
        }
    }
    private lazy var buttonImageView: UIImageView? = {
        var imageView = UIImageView()
        imageView.contentMode = .center
        self.container?.addArrangedSubview(imageView)
        return imageView
    }()
    private lazy var titleView: UILabel? = {
        let label = UILabel()
        self.titleContainer?.insertArrangedSubview(label, at: 0)
        return label
    }()
    private lazy var subTitleView: UILabel? = {
        let label = UILabel()
        self.titleContainer?.insertArrangedSubview(label, at: 1)
        return label
    }()
    private lazy var container: UIStackView? = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        return stack
    }()
    
    private lazy var titleContainer: UIStackView? = {
        let stack = UIStackView()
        container?.addArrangedSubview(stack)
        return stack
    }()
    
    private func layoutJustTitle() {
        container?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        container?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container?.axis = .horizontal
        container?.alignment = imageAligment
        container?.distribution = .fill
        
//        titleContainer?.axis = .vertical
//        titleContainer?.alignment = titleAligment
//        titleContainer?.distribution = .fill
    }
    
    private func layoutJustSubTitle() {
        layoutJustTitle()
    }
    
    private func layoutJustImage() {
        layoutJustTitle()
    }
    
    private func layoutTitleAndSubTitle() {
        container?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        container?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        container?.axis = .horizontal
        container?.alignment = imageAligment
        container?.distribution = .equalSpacing
        
        titleContainer?.axis = .vertical
        titleContainer?.spacing = titleSpacing
        titleContainer?.alignment = titleAligment
        titleContainer?.distribution = .equalSpacing
    }
    
    private func layoutTitleAndImage() {
        
        container?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        container?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleContainer?.axis = .vertical
        titleContainer?.alignment = titleAligment
        titleContainer?.distribution = .equalSpacing
        titleContainer?.spacing = titleSpacing
    
        container?.alignment = imageAligment
        container?.distribution = .equalSpacing
        let last = container?.arrangedSubviews.filter{$0 is UIImageView}.first
        let first = container?.arrangedSubviews.filter{$0 is UIStackView}.first
        container?.removeArrangedSubview(titleContainer!)
        container?.removeArrangedSubview(buttonImageView!)
        
        switch imagePosition {
        case .left(let spacing):
            container?.axis = .horizontal
            container?.spacing = spacing
            
            guard let l = last, let f = first else {return}
            
            container?.addArrangedSubview(l)
            container?.addArrangedSubview(f)
    
        case .right(let spacing):
            container?.axis = .horizontal
            container?.spacing = spacing
            guard let l = last, let f = first else {return}
            
            container?.addArrangedSubview(f)
            container?.addArrangedSubview(l)
            
        case .top(let spacing):
            container?.axis = .vertical
            container?.spacing = spacing
            guard let l = last, let f = first else {return}
            
            container?.addArrangedSubview(l)
            container?.addArrangedSubview(f)
            
        case .bottom(let spacing):
            container?.axis = .vertical
            container?.spacing = spacing
            guard let l = last, let f = first else {return}
            container?.addArrangedSubview(l)
            container?.addArrangedSubview(f)
        }
    }
    
    private func layoutSubTitleAndImage() {
        layoutTitleAndImage()
    }
    
    private func layoutAll() {
        layoutTitleAndImage()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        container?.isLayoutMarginsRelativeArrangement = true
        container?.layoutMargins = padding
        if (title != nil) && (subTitle != nil) && (image != nil) {
            layoutAll()
            return
        }
        
        if (title != nil) && (subTitle == nil) && (image != nil) {
            layoutTitleAndImage()
            return
        }
        
        if (title == nil) && (subTitle != nil) && (image != nil) {
            layoutSubTitleAndImage()
            return
        }
        
        if (title != nil) && (subTitle == nil) && (image == nil) {
            layoutJustTitle()
            return
        }
        
        if (title == nil) && (subTitle != nil) && (image == nil) {
            layoutJustSubTitle()
            return
        }
        
        if (title == nil) && (subTitle == nil) && (image != nil) {
            layoutJustImage()
            return
        }
        
        if (title != nil) && (subTitle != nil) && (image == nil) {
            layoutTitleAndSubTitle()
            return
        }
        
    }
}
