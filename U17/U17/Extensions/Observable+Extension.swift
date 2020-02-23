//
//  Observable+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

extension Single {
    /// 后台构建序列 主线程监听并处理序列结果
    func async()->Observable<Element>{
        return subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance).asObservable()
    }
}

extension Observable {
    /// 后台构建序列 主线程监听并处理序列结果
    func async()->Observable{
        return subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
    }
    
    func subscribeNext(_ block : ((Element)->Void)?) -> Disposable {
        return subscribe(onNext: block, onError: {logerr($0)}, onCompleted: {}, onDisposed: {})
    }
    
    func subscribeCatchError(_ block : ((Element)->Void)?) -> Disposable {
        return subscribe(onNext: block, onError: {Alert.catchError($0)}, onCompleted: {}, onDisposed: {})
    }
    
    func showHUD(text:String? = nil,view:UIView? = nil,isDisableActive:Bool = false) -> Observable {
        var hud : MBProgressHUD? = nil
        let toView = view ?? keywindow?.rootNavController?.viewControllers.last?.view
        if let realView = toView {
            hud = MBProgressHUD.showAdded(to: realView, animated: true)
            hud?.contentColor = .B1
            hud?.bezelView.backgroundColor = .B3
            if let text = text {
                hud?.label.set(color: .B1).set(font: .PR11).text = text
            }
            hud?.isUserInteractionEnabled = isDisableActive
        }
        let ob = share()
        _ = ob.take(1).subscribe { (_) in
            hud?.hide(animated: true)
        }
        return ob
    }
    
    func hideHUD() -> Observable {
        if let view = keywindow?.rootNavController?.viewControllers.last?.view {
            MBProgressHUD.hide(for: view, animated: true)
        }
        return self
    }
}

extension ControlEvent {
    func subscribeNext(_ block : ((Element)->Void)?) -> Disposable {
        return subscribe(onNext: block, onError: nil, onCompleted: nil, onDisposed: nil)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}



