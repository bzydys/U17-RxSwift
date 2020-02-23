//
//  TabBarController.swift
//  IB_iOS
//
//  Created by 曾凡怡 on 2018/9/1.
//  Copyright © 2018年 曾凡怡. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import SwiftyJSON


extension UIViewController: Navigatable {
    var navigator: Navigator! {
        get {
            return Navigator.default
        }
        
        set{
            
        }
        
    }
}


enum HomeTabBarItem: Int {
    case home, category, book, profile
    
    func controller(with viewModel: ViewModel) -> UIViewController {
        switch self {
        case .home:
            let vc = HomeViewController()
            return vc
            
        case .category:
            let vc = CategoryViewController()
            return vc
        case .book:
            let vc = BookShufferViewController()
            return vc
        case .profile:
            let vc = ProfileViewController()
            return vc
        }
    }
    
    var image: UIImage? {
        switch self {
        case .home: return _I("tab_home")
        case .category: return _I("tab_class")
        case .profile: return _I("tab_mine")
        case .book: return _I("tab_book")
        }
    }
    
    var selectImage: UIImage? {
        switch self {
        case .home: return _I("tab_home_S")
        case .category: return _I("tab_class_S")
        case .profile: return _I("tab_mine_S")
        case .book: return _I("tab_book_S")
        }
    }
    
    var title: String {
        return ""
    }
    
    
    func getController(with viewModel: ViewModel) -> UIViewController {
        let vc = controller(with: viewModel)
        let item = UITabBarItem(title: title, image: image, selectedImage: selectImage)
        if UIDevice.current.userInterfaceIdiom == .phone {
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        vc.tabBarItem = item
        return vc
    }
}


class TabBarController: UITabBarController{

    
    let bag = DisposeBag()
    let viewModel: HomeTabViewModel
    
    var tabBarButtoms : [UIButton] = []
    
    init(viewModel: HomeTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      
        super.viewDidLoad()

        // 背景色修改
        tabBar.backgroundImage = UIImage.colorImage(_HexColor("#FFFFFF 98%"))
        
        tabBar.isTranslucent = false
    
//        delegate = self
        
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = HomeTabViewModel.Input(trigger: rx.methodInvoked(#selector(viewDidAppear(_:))).mapToVoid())
        let output = viewModel.transform(input: input)
        
        output.tabBarItems.drive(onNext: { [weak self] (tabBarItems) in
            if let strongSelf = self {
                let controllers = tabBarItems.map { $0.getController(with: strongSelf.viewModel.viewModel(for: $0)) }
                strongSelf.setViewControllers(controllers, animated: false)
                strongSelf.navigator.injectTabBarControllers(in: strongSelf)
            }
        }).disposed(by: bag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        APIMgr.providerCache.removeAll()
    }
    
//    func tabViewController(_ viewController:UIViewController,title: String, image: String,index:Int)->UIViewController{
//        let vc = ZFNavigationController(rootViewController: viewController)
//        let btn = addBtn(title: title, image: image,index:index)
//
//        // 点击事件
//        btn.rx.controlEvent(.touchUpInside).subscribe(tapBlock(index: index)).disposed(by: bag)
//        btn.isSelected = index == 0
//        tabBarButtoms.append(btn)
//
//        return vc
//    }
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        viewControllers?.zf_enumerate({ index,vc in
//            guard vc == viewController else {return}
//            self.selectIndex(index: index)
//        })
//        return true
//    }
//
//    func selectIndex(index:Int) {
//        self.selectedIndex = index
//        self.tabBarButtoms.zf_enumerate({ (btnIndex, btn) in
//            btn.isSelected = btnIndex == self.selectedIndex
//        })
//    }
//
//    func tapBlock(index:Int)->((Event<()>)->Void) {
//        return {_ in
//            self.selectIndex(index: index)
//        }
//    }
//
//    func addBtn(title: String, image: String,index:Int,count:Int = 4)->UIButton{
//        // 创建
//        let btn = UIButton().set(title: title).set(font: .SM10).set(color: .T4)
//        btn.setTitleColor(.B0, for: .selected)
//        // 默认图片
//        btn.setImage(_I(image), for: .normal)
//        // 选中图片
//        btn.setImage(_I(image+"on"), for: .selected)
//        tabBar.addSubview(btn)
//        // 不要高亮效果
//        btn.rx.controlEvent(.allTouchEvents).asObservable().subscribeNext {
//            btn.isHighlighted = false
//            }.disposed(by: bag)
//        // 文字和图片的间隔
//        btn.layoutVertical(titleMargin: 5, topOffset: 0)
//        btn.frame = CGRect(x: CGFloat(index) / CGFloat(count) * tabBar.frame.width,
//                           y: 3.5,
//                           width: 1.0 / CGFloat(count) * tabBar.frame.width,
//                           height: tabBar.frame.height)
//        return btn
//    }
}
