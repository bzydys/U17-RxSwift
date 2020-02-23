//
//  Application.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

final class Application {
    static let shared = Application()
    
    var window: UIWindow?
    let navigator: Navigator
    
    private init() {
//        provider = Api.shared
//        authManager = AuthManager.shared
        navigator = Navigator.default
    }
    
    func presentInitialScreen(in window: UIWindow) {
        self.window = window
        
        let viewModel = HomeTabViewModel()
        navigator.show(segue: Scene.tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
    
//    func presentTestScreen(in window: UIWindow) {
//        let viewModel = UserViewModel(user: nil, provider: provider)
//        navigator.show(segue: .userDetails(viewModel: viewModel), sender: nil, transition: .root(in: window))
//    }
}

