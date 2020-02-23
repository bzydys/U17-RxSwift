//
//  RxCocoa+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//



import UIKit
import RxCocoa
import RxSwift


extension Reactive where Base : UIView {
    /// Bindable sink for `titleLabel?.font` property.
    public var backgroundColor: RxCocoa.Binder<UIColor> {
        return Binder<UIColor>(base, scheduler: MainScheduler.instance) { (view, color) in
            view.backgroundColor = color
        }
    }
    
}


extension Reactive where Base : UILabel {
    /// Bindable sink for `titleLabel?.font` property.
    public var textColor: RxCocoa.Binder<UIColor> {
        return Binder<UIColor>(base, scheduler: MainScheduler.instance) { (label, color) in
            label.textColor = color
        }
    }
}

extension Reactive where Base : UITextField {
    /// Bindable sink for `titleLabel?.font` property.
    public var textColor: RxCocoa.Binder<UIColor> {
        return Binder<UIColor>(base, scheduler: MainScheduler.instance) { (label, color) in
            label.textColor = color
        }
    }
}

extension Reactive where Base : UIButton {
    
    /// Bindable sink for `titleLabel?.font` property.
    public var font: RxCocoa.Binder<UIFont> {
        return Binder<UIFont>(base, scheduler: MainScheduler.instance) { (button, font) in
            button.titleLabel?.font = font
        }
    }
    
    func disableUntil(_ notifi:ZFNotiType) -> ControlEvent<()> {
        return disableUntil([notifi])
    }
    
    /// 点击后禁用按钮的交互,直到接收到指定的通知
    func disableUntil(_ notifis:[ZFNotiType]) -> ControlEvent<()> {
        // 获取点击事件
        let event = controlEvent(UIControl.Event.touchUpInside)
        // 点击事件禁用按钮
        let _ = event.takeUntil(base.rx.deallocated).subscribe(onNext: {[weak base] (_) in
            base?.isEnabled = false
            }, onError: { (err) in
                logerr(err)
        }, onCompleted: {
//            logg("disableUntil onCompleted")
        }) {
//            logg("disableUntil onDisposed")
        }
        // 监听通知
        for type in notifis {
            let _ = NotificationCenter.default.rx.notification(type).takeUntil(base.rx.deallocated)
                .subscribe {[weak base] (_) in
                    base?.isEnabled = true
            }
        }
        return event
    }
}

// MARK: - 倒计时
extension UIButton{
    // MARK:倒计时 count:多少秒 countDownBgColor:倒计时背景颜色
    /// 倒计时 count:多少秒 countDownBgColor:倒计时背景颜色
    public func countDown(count: Int,
                          countDownBgColor:UIColor = .gray,
                          countDownTitleColor : UIColor = .white,
                          configTitle :@escaping (Int)->()){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
        backgroundColor = countDownBgColor
        var remainingCount: Int = count {
            willSet {
                configTitle(newValue)
            }
        }
        // 在global队列里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
}

