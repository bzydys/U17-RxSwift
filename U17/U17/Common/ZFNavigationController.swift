//
//  ZFNavigationController.swift
//  bss
//
//  Created by 曾凡怡 on 2017/3/9.
//  Copyright © 2017年 EParty. All rights reserved.
//



import UIKit

protocol ZFCustomBackgroundable {
    var bgColor : UIColor {get}
}

protocol ZFNavigationProcotol : class{
    func shouldPop(to viewController : UIViewController?)->Bool
    func didPop(to viewController : UIViewController?)->()
}

private extension UIStatusBarStyle {
    var navBarBackImage : UIImage {
        switch self {
        case .default: return _I("Back White")
        default: return _I("Back").render(tintColor: .T3)!
        }
    }
}

class ZFNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupDarkUI()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupDarkUI()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch viewControllers.last?.preferredStatusBarStyle ?? .default {
        case .default: return .lightContent
        default: return .default
        }
    }
    
    func setupLightUI(){
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.PS16,
                                             NSAttributedString.Key.foregroundColor:UIColor.T1]
        navigationBar.setBackgroundImage(UIImage.colorImage(.L0), for: .default)
        navigationBar.shadowImage = UIImage.colorImage(.clear)
    }
    
    func setupDarkUI(){
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.PS16,
                                             NSAttributedString.Key.foregroundColor:UIColor.L0]
        navigationBar.setBackgroundImage(UIImage.colorImage(.B0), for: .default)
        navigationBar.shadowImage = UIImage.colorImage(.clear)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /// 每次push pop 都重置代理. 代理只需要在 viewWillAppear 中设置
    weak var backDelegate : ZFNavigationProcotol?
    
    /// 设置返回按钮样式
    private func setBackItem(with viewController:UIViewController){
        
        //判断当前的栈内有几个视图.为0的话是根控制器,根控制器不需要设置返回按钮以及返回手势
        if self.children.count > 0 , viewControllers.first != viewController {
            //设置隐藏tab
            viewController.hidesBottomBarWhenPushed = true
            
            //设置返回按钮,这里使用的分类中自定义的创建方法.
            let style = viewController.preferredStatusBarStyle
            
            viewController.la_setBar(style: style)
            
            if let navView = viewController.view as? ZFCustomNavView {
                navView.navBar.leftItem.setImage(style.navBarBackImage, for: .normal)
                navView.navBar.leftItem.addTarget(self, action: #selector(popAction), for: UIControl.Event.touchUpInside)
            }else{
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.leftItem(with: style.navBarBackImage, target: self, action: #selector(popAction))
            }
            
            //获取返回手势的代理
            let target = interactivePopGestureRecognizer?.delegate
            
            //自定义手势添加到返回手势的代理上
            let pan = UIScreenEdgePanGestureRecognizer(target: target, action: NSSelectorFromString("handleNavigationTransition:"))
            pan.edges = UIRectEdge.left
            
            //如果需要使用全屏侧滑返回,可以直接使用pan手势,并且很奇妙的是也只能从左往右滑动生效
            //let pan =  UIPanGestureRecognizer(target: target, action: NSSelectorFromString("handleNavigationTransition:"))
            //将自定义手势添加到控制器的View上
            viewController.view.addGestureRecognizer(pan)
            
            //设置代理,控制手势是否开启,以及滑动的方向距离等.若不需要可以不设置
            pan.delegate = self
            
            // 设置返回手势
            interactivePopGestureRecognizer?.isEnabled = true
        }

    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        // 除了 first 其他的都设置返回按钮
        viewControllers.filter({viewControllers.first != $0}).zf_enumerate({
            // 设置返回按钮
            setBackItem(with: $1)
            // 设置背景色
            $1.view.backgroundColor = ($1 as? ZFCustomBackgroundable)?.bgColor ?? .L0
        })
        //调用父类方法
        super.setViewControllers(viewControllers, animated: animated)
        //清空代理
        backDelegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewController?.view.backgroundColor = (topViewController as? ZFCustomBackgroundable)?.bgColor ?? .L2
    }
    
    
    /// 重写push方法,每次push都为下一个控制器修改统一的返回按钮以及手势.
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 设置返回按钮
        setBackItem(with: viewController)
//        // 设置背景色
//        viewController.view.backgroundColor = (viewController as? ZFCustomBackgroundable)?.bgColor ?? .L2
        //清空代理
        backDelegate = nil
        //调用父类方法
        super.pushViewController(viewController, animated: animated)
    }
    
    // 清空代理
    @discardableResult override func popViewController(animated: Bool) -> UIViewController? {
        if let top = viewControllers.bwy_obj(last: 1) {
            setBackItem(with: top)
        }
        let vc = super.popViewController(animated: animated)
        backDelegate?.didPop(to: viewControllers.last)
        backDelegate = nil
        return vc
    }
    
    /// 返回按钮绑定的点击事件
    @objc func popAction() {
        // 每次 pop 控制器 取消所有网络请求
        defer{
//            IBAPIClient.shared.cancelAll()
        }
        // 没有代理直接 pop
        guard let backDelegate = backDelegate else {
            popViewController(animated: true)
            return
        }
        
        // 子控制器大于1个 不为根控制器 防止数组越界
        guard viewControllers.count > 1 else{
            assert(true, "根控制器 pop")
            return
        }
        
        // 返回yes pop
        if  backDelegate.shouldPop(to: viewControllers[viewControllers.count - 2]) {
            popViewController(animated: true)
        }
    }
    
    /// 手势的代理,开启手势识别.弱不需要额外的控制可以不设置
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 没有代理直接 true
        return backDelegate == nil
    }
}


extension UINavigationController {
    
    /// 连续返回几个控制器
    ///
    /// - Parameters:
    ///   - animated: 是否需要动画效果
    ///   - Times: 返回几次 0 为不返回
    func pop(animated:Bool = true,times:Int){
        let targetIndex = viewControllers.count - times - 1
        if targetIndex < 0 {
            popToRootViewController(animated: animated)
        }else{
            let _ = popToViewController(viewControllers[targetIndex], animated: animated)
        }
    }
    
    /// 向前 push 之前 先 popToRoot
    func zf_popToRoot_push(viewController:UIViewController){
        push(to: viewController, popTimes: viewControllers.count - 1)
    }
    
    /// 向前 push 之前 先 pop 几次
    ///
    /// - Parameters:
    ///   - viewController: push 的目标
    ///   - popTimes: push 之前 先无动画的 pop 几个控制器出栈
    ///   - animated: push 是否需要动画 默认需要
    func push(to viewController : UIViewController,popTimes:Int,animated:Bool = true){
        var maxTime = popTimes
        if viewControllers.count - popTimes <= 0 {
            maxTime = viewControllers.count - 1
        }
        var vcs = Array(viewControllers[0..<viewControllers.count - maxTime])
        vcs.append(viewController)
        setViewControllers(vcs, animated: animated)
    }
}
