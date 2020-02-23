//
//  IBAlert.swift
//  IB_iOS
//
//  Created by 曾凡怡 on 2018/9/3.
//  Copyright © 2018年 曾凡怡. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

struct Alert {
    
    /// Alert点击类型
    ///
    /// - Left: 左边
    /// - Right: 右边
    /// - Middle: 中间
    enum AlertType {
        case Left
        case Right
        case Middle
    }
    
    /// 输入密码
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - complete: 输入完成
    static func inputPassword(
        title: String = "Password.Input.Placeholder"~,
        complete:@escaping (String)->())
    {
        let alert = UIAlertController.init(title: "Password.Input.Placeholder"~, message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Password.Input.Password"~
            tf.isSecureTextEntry = true
            tf.clearButtonMode = .whileEditing
        }
        alert.addAction(UIAlertAction(title: "Button.Cancel"~, style: UIAlertAction.Style.default, handler: { (_) in
            return
        }))
        alert.addAction(UIAlertAction(title: "Button.OK"~, style: UIAlertAction.Style.destructive, handler: {[weak alert] _ in
            guard let alert = alert else {return}
            guard let password = alert.textFields?.first?.text else {return}
            complete(password)
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func inputPassword(title: String = "Password.Input.Placeholder"~) -> Single<String>{
        return Single<String>.create { (ob) -> Disposable in
            inputPassword(title: title, complete: { (pass) in
                ob(.success(pass))
            })
            return Disposables.create{}
        }
    }
    
    /// 输入密码
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 说明
    ///   - complete: 输入完成
    static func input_Password(
        title: String = "Password.Input.Placeholder"~,
        message:String?,
        complete:@escaping (String)->())
    {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (tf) in
            tf.placeholder = "BackWallet.Alert.Title"~
            tf.isSecureTextEntry = true
            tf.clearButtonMode = .whileEditing
        }
        alert.addAction(UIAlertAction(title: "Button.Cancel"~, style: UIAlertAction.Style.default, handler: { (_) in
            return
        }))
        alert.addAction(UIAlertAction(title: "Button.OK"~, style: UIAlertAction.Style.destructive, handler: {[weak alert] _ in
            guard let alert = alert else {return}
            guard let password = alert.textFields?.first?.text else {return}
            complete(password)
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    /// 弹出提示
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - detail: 详细描述
    ///   - left: 左边按钮
    ///   - right: 右边按钮
    ///   - tapAction: 点击事件
    static func alert(
        title: String,
        detail: String,
        left: (String,UIAlertAction.Style),
        leftColor: UIColor? = nil,
        right: (String,UIAlertAction.Style)? = nil,
        tapAction: ((AlertType)->())?)
    {
        let alert = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        let leftAction = UIAlertAction(title: left.0, style: left.1) { (_) in
            let type : AlertType = (right?.0.count ?? 0) > 0 ? .Left : .Middle
            tapAction?(type)
        }
        leftColor == nil ? nil : leftAction.setValue(leftColor, forKey: "titleTextColor")
        alert.addAction(leftAction)
        
        if let right = right {
            alert.addAction(UIAlertAction(title: right.0, style: right.1, handler: { (_) in
                tapAction?(.Right)
            }))
        }
        (UIApplication.shared.keyWindow?.currentViewController())?.present(alert, animated: true, completion: nil)
    }
    /// 弹出提示带图片
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - imageName: 图片地址
    ///   - detail: 详细描述
    ///   - left: 左边按钮
    ///   - right: 右边按钮
    ///   - tapAction: 点击事件
    static func alertWithImage(
        title: String,
        imageName: String,
        detail: String,
        left: String,
        right: String? = nil,
        tapAction: ((AlertType)->())?)
    {
        
        let alert = UIAlertController(title: title, message: detail, preferredStyle: .alert)
        
        let image = _I(imageName)
        let imageView = UIImageView(image: image)
        
        alert.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.width.height.equalTo(90¡)
            make.centerX.equalToSuperview()
        }
        
        alert.addAction(UIAlertAction(title: left, style: (right != nil) ? UIAlertAction.Style.cancel : UIAlertAction.Style.default) { (_) in
            let type : AlertType = (right?.count ?? 0) > 0 ? .Left : .Middle
            tapAction?(type)
        })
        if let right = right {
            alert.addAction(UIAlertAction(title: right, style: .default, handler: { (_) in
                tapAction?(.Right)
            }))
        }
        (UIApplication.shared.keyWindow?.currentViewController())?.present(alert, animated: true, completion: nil)
    }
    
    @discardableResult static func message(_ msg : String,delay:CGFloat = 1.5) -> ZFToast{
        let toast = ZFToast(hideDelay: 1.5)
        toast.titleLabel.text = msg
        toast.backgroundColor = .T0
        toast.alpha = 0.9
        toast.show(addTo: keywindow!)
        logobj(msg)
        return toast
    }
    
    static func catchError(_ error : Error){
    
    }
    
    static func showProgress() -> MBProgressHUD {
        return MBProgressHUD.zf_show()
    }
    
    static func hideProgress() {
        MBProgressHUD.hide()
    }
}


extension MBProgressHUD {
    
    static func zf_show(_ to:UIView? = nil) -> MBProgressHUD {
        var view = to
        if view == nil {
            view = keywindow?.rootNavController?.viewControllers.last?.view ?? keywindow!
        }
        if let present = keywindow?.rootNavController?.viewControllers.last?.presentedViewController {
            view = present.view
        }
        let hud = MBProgressHUD
            .showAdded(to: view!, animated: true)
        hud.contentColor = .B1
        hud.bezelView.backgroundColor = .B3
        return hud
    }
    
    static func showUntilTask(task:@escaping ()->()){
        let hud = MBProgressHUD.zf_show()
        Gsync {
            task()
            mainAsync {
                hud.hide(animated: true)
            }
        }
    }
}

extension MBProgressHUD {
    static func hide() {
        mainAsync {
            if let view = keywindow?.rootNavController?.viewControllers.last?.view {
                if MBProgressHUD.hide(for: view, animated: true) {
                    logg("移除HUD成功")
                }
            }
        }
        
    }
}

class ZFToast: UIView {
    
    let titleLabel : UILabel = UILabel().set(font: .PM12).set(color: .white)
    
    var showComplete : (()->())?
    
    var hideDelay : Double = 1.5
    
    var animationDuration : Double = 0.2
    
    init(hideDelay : Double = 1.5) {
        self.hideDelay = hideDelay
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// UI 初始化
    func setupUI()  {
        titleLabel.numberOfLines = 5
    }
    
    func show(addTo:UIView){
        // remove old view
        for subView in addTo.subviews {
            if subView is ZFToast {
                subView.removeFromSuperview()
                (subView as? ZFToast)?.titleLabel.removeFromSuperview()
            }
        }
        
        addTo.addSubview(self)
        addTo.addSubview(titleLabel)
        
        snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(titleLabel).offset(Margin.leading*2)
            make.height.equalTo(titleLabel).offset(17¡ * 2)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.66)
        }
        
        delay(hideDelay - 2*animationDuration) {[weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: self.animationDuration, animations: {[weak self] in
                self?.alpha = 0
                }, completion: {[weak self] (_) in
                    self?.removeFromSuperview()
                    self?.titleLabel.removeFromSuperview()
                    self?.showComplete?()
            })
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let alpha = self.alpha
        self.alpha = 0
        UIView.animate(withDuration: animationDuration) {
            self.alpha = alpha
        }
    }
    
    /// 自动布局代码
    override func layoutSubviews() {
        
        super.layoutSubviews()
        maskToRound(width:4)
    }
    
}
