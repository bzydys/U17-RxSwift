//
//  UIViewController+U17.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func la_setBar(style:UIStatusBarStyle){
        switch style {
        case .default:
            if let view = view as? ZFCustomNavView {
                view.setupDarkUI()
            }else{
                zf_Navgation?.setupDarkUI()
            }
        default:
            if let view = view as? ZFCustomNavView {
                view.setupLightUI()
            }else{
                zf_Navgation?.setupLightUI()
            }
        }
        
    }
}

