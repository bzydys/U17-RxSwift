//
//  Dispatch+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//



import UIKit

typealias CancelableTask = (_ cancel: Bool) -> Void

func delay(_ delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

func cancel(_ cancelableTask: CancelableTask?) {
    cancelableTask?(true)
}

func Gsync(closure:@escaping () -> ()){
    DispatchQueue.global().async {
        closure()
    }
}

func mainAsync(closure: @escaping () -> ()) {
    DispatchQueue.main.async {
        closure()
    }
}

func synced(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

func currentMilliseconds() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

