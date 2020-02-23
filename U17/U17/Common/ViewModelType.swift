//
//  ViewModelType.swift
//  U17
//
//  Created by Lee on 2/23/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation


protocol ViewModelType {
    associatedtype Input
    associatedtype Out
    func transform(input: Input) -> Out
}
class ViewModel {
    
}
