//
//  Rx+MJRefresh.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base : MJRefreshHeader {
    
    var refresh : Observable<Void> {
        let source = Observable<Void>.create { [weak refresh = self.base] (observer) -> Disposable in
            guard let refresh = refresh else {
                observer.on(.completed)
                return Disposables.create()
            }
            refresh.refreshingBlock = {
                observer.on(.next(()))
            }
            return Disposables.create {
                self.base.refreshingBlock = nil
            }
            }.takeUntil(deallocated)
        
        return source
            .share(replay: 1)
            .startWith(())
    }
    
    var endRefresh : Binder<Bool> {
        return Binder<Bool>(self.base){ header , end in
            if end {
                header.endRefreshing()
            }else{
                header.beginRefreshing()
            }
        }
    }
}


extension Reactive where Base : MJRefreshFooter {
    
    var refresh : Observable<Void> {
        let source = Observable<Void>.create { [weak refresh = self.base] (observer) -> Disposable in
            guard let refresh = refresh else {
                observer.on(.completed)
                return Disposables.create()
            }
            refresh.refreshingBlock = {
                observer.on(.next(()))
            }
            return Disposables.create {
                self.base.refreshingBlock = nil
            }
            }.takeUntil(deallocated)
        
        return source
            .share(replay: 1)
    }
    
    var endRefresh : Binder<Bool?> {
        return Binder<Bool?>(self.base){ footer , end in
            guard let end = end else {
                footer.endRefreshingWithNoMoreData()
                return
            }
            if end {
                footer.endRefreshing()
            }else{
                footer.beginRefreshing()
            }
        }
    }
}

