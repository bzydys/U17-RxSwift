//
//  Notification+Extension.swift
//  U17
//
//  Created by Lee on 2/22/20.
//  Copyright © 2020 Lee. All rights reserved.
//


import UIKit
import RxSwift

/// 登录通知
enum ZFNotiType : String{
    /// 清除首页钱包缓存,重新读取最新的钱包数量
    case ClearAssetsViewCache
    /// APP 进入后台
    case APPEnterBackgound
    /// APP 回到前台
    case APPComeBackForeground
    /// 是否隐藏资产金额
    case ReloadAssetsTableView
    /// 切换资产显示单位
    case ChangeMonyType
    /// 切换红绿涨跌模式
    case ChangeIsRedUp
    /// 选择了DAPP钱包 刷新任务
    case ChangeDappWallet
    /// 重新连接到网络
    case ConnectToNetwork
    /// 清空币币兑换数据
    case CleareCoinExchangeData
    /// 移除当前界面上的弹窗
    case RemoveAllBWYAlert
    
}

/// 获取name
extension ZFNotiType {
    var name : Notification.Name {
        return Notification.Name(rawValue: "LANotiTypeName." + self.rawValue)
    }
    var observer : Observable<Notification> {
        return NotificationCenter.default.rx.notification(self)
    }
    func post(){
        NotificationCenter.post(self)
    }
}

extension NotificationCenter {
    static func post(_ type: ZFNotiType, object: Any? = nil){
        NotificationCenter.default.post(name: type.name, object: object)
    }
}

extension Reactive where Base: NotificationCenter {
    func notification(_ type: ZFNotiType, object: AnyObject? = nil) -> Observable<Notification> {
        return notification(type.name, object: object)
    }
}


