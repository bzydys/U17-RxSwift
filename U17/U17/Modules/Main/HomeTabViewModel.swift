//
//  HomeTabViewModel.swift
//  U17
//
//  Created by Lee on 2/23/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeTabViewModel: ViewModel, ViewModelType {
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Out {
        let tabBarItems: Driver<[HomeTabBarItem]>
        
    }
    
    func transform(input: HomeTabViewModel.Input) -> HomeTabViewModel.Out {
        let items = input.trigger.map{[HomeTabBarItem.home, HomeTabBarItem.category, HomeTabBarItem.book, HomeTabBarItem.profile]}.asDriver(onErrorJustReturn: [])
        let out = Out(tabBarItems: items)
        return out
    }
    
    func viewModel(for tabBarItem: HomeTabBarItem) -> ViewModel {
        switch tabBarItem {
        case .home:
            return MainViewModel()
        case .category:
            return CategoryViewModel()
        case .profile:
            return ProfileViewModel()
        case .book:
            return BookShufferViewModel()
        }
    }
    
}
