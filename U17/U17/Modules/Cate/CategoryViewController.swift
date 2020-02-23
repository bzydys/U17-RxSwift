//
//  CategoryViewController.swift
//  U17
//
//  Created by Lee on 2/23/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import Foundation

class CategoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls: [String] = ["https://www.baidu.com/img/bd_logo1.png"]
        let banner = LBannerView(urls.map{URL(string: $0)!})
        view.addSubview(banner)
        banner.frame = CGRect(x: 10, y: 100, width: 300, height: 180)
    }
    
}
