//
//  UIViewController+Extionson.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol CustomViewable {
    var initView : UIView {get}
}

class CustomViewController<CustomView: UIView>: UIViewController,CustomViewable {
    
    var zf_isViewFirstAppera : Bool = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zf_isViewFirstAppera = true
    }
    
    var initView: UIView {
        let view = CustomView(frame: UIScreen.main.bounds)
        return view
    }
    
    var bag : DisposeBag = DisposeBag()
    
    var cView: CustomView {
        return view as! CustomView // 因为我们正在重写 view，所以永远不会解析失败。
    }
    
    override func loadView() {
        view = initView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置背景色
        view.backgroundColor = (self as? ZFCustomBackgroundable)?.bgColor ?? .L2
        
    }
    
    
    override var title: String? {
        set{
            if let view = view as? ZFCustomNavView {
                view.navBar.titleLabel.text = newValue
            }else{
                navigationController?.navigationItem.title = newValue
            }
        }get{
            if let view = viewIfLoaded as? ZFCustomNavView {
                return view.navBar.titleLabel.text
            }else{
                return navigationController?.navigationItem.title
            }
        }
        
    }
    
    deinit {
        bag = DisposeBag()
        logg("\(NSStringFromClass(self.classForCoder)) 释放")
    }
}


///扩展提供便捷属性
extension UIViewController {
    
    var zf_Navgation : ZFNavigationController? {
        // 直接获取
        if let nav = navigationController as? ZFNavigationController{
            return nav
        }
        // view获取
        if let viewNav = view.rootNavController as? ZFNavigationController {
            return viewNav
        }
        // window 获取
        if let windowNav = (UIApplication.shared.keyWindow?.rootViewController as? TabBarController)?.selectedViewController as? ZFNavigationController{
            return windowNav
        }
        return nil
    }
    
    func zf_popWithAnimated(){
        // 如果对 navigation 使用 直接 pop
        if self is UINavigationController {
            let _ = (self as! UINavigationController).popViewController(animated: true)
        }
        // 对 vc 使用  判断是否在最上面
        guard navigationController?.viewControllers.last == self else {
            return
        }
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func zf_pushWithAnimated(to vc : UIViewController){
        if let nav = navigationController {
            nav.pushViewController(vc, animated: true)
        }else if self is UINavigationController {
            (self as! UINavigationController).pushViewController(vc, animated: true)
        }
    }
    
    @discardableResult func set(title:String)->Self{
        self.title = title
        return self
    }
}
