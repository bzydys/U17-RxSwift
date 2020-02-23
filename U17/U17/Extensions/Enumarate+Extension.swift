//
//  Array+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit
extension Array{
    @discardableResult func zf_enumerate(_ function : (_ offset: Int, _ element: Element)->())->Array{
        for aug in self.enumerated(){
            function(aug.offset, aug.element)
        }
        return self
    }
}
extension Dictionary {
    @discardableResult func zf_enumerate(_ function : (_ key: Key, _ value: Value)->())->Dictionary{
        for aug in self{
            function(aug.key, aug.value)
        }
        return self
    }
}
