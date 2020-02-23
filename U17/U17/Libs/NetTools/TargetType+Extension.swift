//
//  TargetType+Extension.swift
//  NWDBusinessAssistant
//
//  Created by 曾凡怡 on 2018/1/15.
//  Copyright © 2018年 曾凡怡. All rights reserved.
//

import Moya
import SwiftyJSON

protocol AutoErrorTip {
    // 返回 false 的不需要自动弹出错误提示
    var autoErrorTips: Bool {get}
}

public extension TargetType {
    /// 接口返回的数据解析为 SwiftyJson 结构体
    var json : JSONHandler {
        return json()
    }
    
    func json(hud:Bool=false)->JSONHandler{
        return route.json(showHud: hud)
    }
    
    /// 上传
    var upload : UploadHandler {
        return route.upload
    }
    
    /// 返回的数据解析为 UIImage
    var image : ImageHandler {
        return route.image
    }
    
    /// 返回的数据解析为 Mapable 类型
    func model<T: Mapable>(_ type: T.Type,hud:Bool = false) -> ModelHandler<T>{
        return route.model(type, showHud: hud)
    }
    
    /// 返回的数据解析为 [Mapable] 类型
    func array<T: Mapable>(_ type: T.Type,hud:Bool = false) -> ModelHandler<[T]>{
        return route.array(type, showHud: hud)
    }
    
    /// 创建 Provider
    private var route : Route<Self> {
        return Route(self)
    }
    
    /// 返回的数据做适配,使字段适应本地使用
    func adaptation(json:inout JSON){
//        // 取出 jsonData 方便操作
//        let jsonData = json["data"]
//
//
//        // 将快捷操作改变后的值赋值回去
//        json["data"] = jsonData
    }
    
}
