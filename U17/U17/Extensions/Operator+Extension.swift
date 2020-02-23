
//
//  Operator+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

/// 解包不出来就给空字符串
postfix operator ~!

postfix func ~! (left: Any?) -> String {
    return left != nil ? left as? String ?? "" : ""
}

postfix func ~! (left: String?) -> String {
    return left != nil ? left! : ""
}

postfix func ~! (left: NSNumber?) -> NSNumber {
    return left != nil ? left! : 0
}


/// 将UI给定的参数转换为当前屏幕适用的数据.
postfix operator ¡
postfix func ¡ ( origin : CGFloat) -> CGFloat {
    return ib_W(origin)
}

postfix operator ¡¡
postfix func ¡¡ ( origin : CGFloat) -> CGFloat {
    return ib_H(origin)
}

/// 国际化字符串
postfix operator ~
postfix func ~ ( origin : String) -> String {
    return _C(origin)
}


infix operator <
func < (lhs: String, rhs:String) -> Bool {
    let range = lhs.startIndex..<lhs.endIndex
    return lhs.compare(rhs, options: [.numeric,.caseInsensitive,.widthInsensitive,.forcedOrdering], range: range) == ComparisonResult.orderedDescending
}

infix operator >
func > (lhs: String, rhs:String) -> Bool {
    let range = lhs.startIndex..<lhs.endIndex
    return lhs.compare(rhs, options: [.numeric,.caseInsensitive,.widthInsensitive,.forcedOrdering], range: range) == ComparisonResult.orderedAscending
}



//
//  Operators.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//
import RxSwift
import RxCocoa
import UIKit

// Two way binding operator between control property and variable, that's all it takes {
infix operator <-> : DefaultPrecedence

func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument
    
    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }
    
    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }
    
    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }
    
    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

func <-> <Base>(textInput: TextInput<Base>, variable: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: textInput.text)
    let bindToVariable = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] n in
            guard let base = base else {
                return
            }
            
            let nonMarkedTextValue = nonMarkedText(base)
            
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }
             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
                variable.accept(nonMarkedTextValue)
            }
            }, onCompleted:  {
                bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
//    if T.self == String.self {
//        #if DEBUG
//        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to variable.\n" +
//            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
//            "REMEDY: Just use `textField <-> variable` instead of `textField.rx.text <-> variable`.\n" +
//            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
//        )
//        #endif
//    }
    
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

// }
