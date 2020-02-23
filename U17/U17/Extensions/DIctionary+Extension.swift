//
//  DIctionary+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit
import SwiftyJSON

extension Dictionary{
    /// 交换 key : name 到 key : toName
    mutating func exchange(_ name : Key , to toName : Key){
        self[toName] = self.removeValue(forKey: name)
    }
    
    /// 设置的 key 如果为 nil 则赋值 value
    mutating func setDefaultValue(_ data : [Key:Value]){
        data.zf_enumerate { (key, value) in
            // 必须有值 且不为 Null
            guard let v = self[key] , !(v is NSNull) else{
                // 填充默认值
                self[key] = value
                return
            }
        }
    }
    
}


extension JSON {
    /// 交换 key : name 到 key : toName
    mutating func exchange(_ name : JSONSubscriptType , to toName : JSONSubscriptType...){
        self[toName] = self[name]
        self[name] = JSON.null
    }
    mutating func mergedAllSubJSON(){
        var newValue = JSON([:])
        array?.zf_enumerate({ (_, json) in
            guard let newObj = try? newValue.merged(with: json) else {return}
            newValue = newObj
        })
        self = newValue
        
    }
}
