//
//  Array+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
extension Array {
    
    
    /// 使用下标取数组元素 防止越界 自动判断是否
    func bwy_obj(in idx:Int?) -> Element?{
        // 是否传入了 idx
        guard let idx = idx else {return nil}
        // 是否越界
        guard count > idx else {return nil}
        // 是否小于0
        guard idx >= 0 else {return nil}
        return self[idx]
    }
    
    /// 安全的设置一个下标的元素,如果越界,则 append 到数组最后
    ///
    /// - Parameters:
    ///   - index: 下标
    ///   - obj: 对象
    mutating func bwy_set(index : Int , obj : Element){
        guard index >= 0 else {return}
        if index >= count {
            append(obj)
        }else{
            self[index] = obj
        }
    }
    
    /// 从 last 开始去下标 , 防止越界
    ///
    /// - Parameter offset: 0为 last, 1 取 last - 1
    func bwy_obj(last offset:Int?) -> Element?{
        guard let offset = offset else {return nil}
        let idx = count - 1 - offset
        return self.bwy_obj(in: idx)
    }
    
    func bwy_mergeAllDictionary()->[String:Any]?{
        var json = [String:Any]()
        guard let dicArr = self as? [[String : Any?]] else {return nil}
        dicArr.zf_enumerate { (_, dic) in
            dic.zf_enumerate({ (key, value) in
                json[key] = value
            })
        }
        guard json.count > 0 else {return nil}
        return json
    }
    
    func bwy_mergeAllArray()->[Any]?{
        var allArray : [Any] = []
        (self as? [[Any]])?.zf_enumerate({allArray = allArray + $1})
        return allArray.isEmpty ? nil : allArray
    }
    
    /// 给一个数组如[2,1,0,4] 来取出多维数组内的元素
    func objIn(indexs : [Int])->Any?{
        var obj : Any = self
        for i in 0..<indexs.count{
            // 判断是否是数组
            guard let objArr = obj as? [Any] else{
                return nil
            }
            // 防止越界
            if objArr.count == 0 || indexs[i] >= objArr.count {
                return nil
            }
            obj = objArr[indexs[i]]
        }
        // 判断是否是数组
        if let objArr = obj as? [Any]{
            // 返回数组
            return objArr
        }else{
            // 不是,返回目标 obj
            return obj
        }
    }
    
    
    func mapObj(indexs : [Int])->[Element]?{
        var returnValue : [Element] = []
        indexs.zf_enumerate { (_, idx) in
            guard let v = self.bwy_obj(in: idx) else{return}
            returnValue.append(v)
        }
        guard returnValue.count == indexs.count else {return nil}
        return returnValue
    }
    
    
    
}

public func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

public func shuffleArray<T:Any>(arr:[T]) -> [T] {
    var data:[T] = arr
    for i in 1..<arr.count {
        let index:Int = Int(arc4random()) % i
        if index != i {
            data.swapAt(i, index)
        }
    }
    return data
}
