//
//  LAAmination+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit

extension UIButton {
    func la_addLoading(){
        la_removeLoading()
        let loading = UIImageView(image: _I("btn_loading"))
        addSubview(loading)
        loading.tag = -999
        loading.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel!.snp.right).offset(5¡)
        }
        
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        let round : Double = 60
        let byValue = Double.pi * round * 2
        animation.byValue = NSNumber.init(value: byValue)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 60
        
        loading.layer.add(animation, forKey: "la_addLoading")
    }
    
    func la_removeLoading(){
        guard let loadingView = viewWithTag(-999) else {return}
        loadingView.layer.removeAnimation(forKey: "la_addLoading")
        loadingView.removeFromSuperview()
    }
}

extension UILabel {
    func la_addLoading(){
        la_removeLoading()
        let loading = UIImageView(image: _I("btn_loading"))
        addSubview(loading)
        loading.tag = -999
        loading.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(snp.right).offset(5¡)
        }
        
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        let round : Double = 60
        let byValue = Double.pi * round * 2
        animation.byValue = NSNumber.init(value: byValue)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 60
        
        loading.layer.add(animation, forKey: "la_addLoading")
    }
    
    func la_removeLoading(){
        guard let loadingView = viewWithTag(-999) else {return}
        loadingView.layer.removeAnimation(forKey: "la_addLoading")
        loadingView.removeFromSuperview()
    }
}
