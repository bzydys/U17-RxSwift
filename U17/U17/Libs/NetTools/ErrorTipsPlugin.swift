//
//  ToastPlugin.swift
//  bss
//
//  Created by 曾凡怡 on 2017/3/15.
//  Copyright © 2017年 EParty. All rights reserved.
//


import Moya
import Result
import SwiftyJSON



/// 显示错误信息的接口
protocol ErrorDisplayable {
    func showFailText(_ failText : String?)
    
    func alert(_ message : String)
    
    var lastMessage : String? {get}
}

/// 错误显示者
class ZFDispalyer : ErrorDisplayable{
    
    var lastMessage : String?
    
    func showFailText(_ failText: String?) {
        guard let failText = failText , failText.count > 0 else {
            return
        }
        Alert.message(failText)
        logerr(failText)
        lastMessage = failText
    }
    
    func alert(_ message: String) {
        logg(message)
        guard message.count > 0 else {return}
        Alert.message(message)
        lastMessage = message
    }
}


enum BizStatus: Swift.Error {
    
    // 通用
    case NoORMCode                      //"没有映射的 code"
    case S200Success                    //"成功"
    case FAIL(msg:String)                           // 业务错误
}
extension BizStatus {
    static func fromCode(_ code: String , msg: String?) -> BizStatus?
    {
        switch code {
        case BizStatus.S200Success.code: return nil
        default:  return BizStatus.FAIL(msg: msg ?? "")
        }
        
    }
    
    
    var code : String {
        switch self {
        case .S200Success: return "200"
        case .NoORMCode: return ""
        case .FAIL: return "FAIL"
        }
    }
    
    private func errorORM(_ defaultTip : String,target:TargetType)->String {
        switch self {
        default : return defaultTip
        }
    }
    
    
    func errorTipStringWith(target:TargetType)->String{
        switch self {
        case .S200Success: return "成功"
        case .NoORMCode: return ""
        case .FAIL(let msg): return msg
        }

    }
}


public struct ErrorTipsPlugin: PluginType {
    
    /// 展示控件
    var dispalyer : ErrorDisplayable?
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        //先监听成功结果
        if case Result.success(_) = result{
            
            ///1. 判断response
            guard let response = result.value else {
                dispalyer?.showFailText("网络响应为空")
                logerr("错误:网络响应为空!")
                return
            }
            
            /// 判断 HTTP 码
            guard (200..<300) ~= response.statusCode else{
                if let msg = RESULT_MSG != nil ? JSON(response.data)[RESULT_MSG!].string : "错误:\(response.statusCode)!" {
                    dispalyer?.showFailText(msg)
                    logerr("错误:\(String(response.statusCode))!")
                }
                return
            }
            
            
            // 忽略的路径 在调用的地方处理
            if let path = response.request?.url?.path , API_IgnorePath.contains(path){return}
            
            // 判断 contentType
//            guard let mimeType = response.response?.mimeType , mimeType == "application/json" else {return}
            
            ///2. 判断数据
            let json = JSON( response.data)
            guard RESULT_CODE != nil , let code = json[RESULT_CODE!].string else {
                dispalyer?.showFailText(BizStatus.NoORMCode.errorTipStringWith(target: target))
                return
            }
            
            
            /// 3. 返回nil则不提示 代表请求成功
            // 根据状态码进行错误操作
            if let status = BizStatus.fromCode(code,msg: RESULT_MSG != nil ? json[RESULT_MSG!].string : nil){
                // 没有登录的直接弹出登录界面
                switch status {
                default:
                    dispalyer?.showFailText(status.errorTipStringWith(target:target))
                }
            }
            
        }else
            //Moya.Error
        {
            guard let error = result.error else { return }
            if error.isOffline {
                let message = "网络已断开!"
                guard dispalyer?.lastMessage != message else {return}
                dispalyer?.showFailText(message)
                return
            }
            let moyaError = error as MoyaError
            switch moyaError {
            case let .underlying(err, _):
                guard (err as NSError).code == 53 else {break}
                logerr("回到app后,未能完成之前的网络请求")
                return
            default:
                break
            }
            switch error {
            default:
                switch error.localizedDescription {
                case "cancelled","已取消":
                    logg("\(target)请求已经取消")
                default:
                    dispalyer?.showFailText(error.localizedDescription)
                }
            }
        }
    }
    
}

extension MoyaError {
    var isOffline : Bool {
        switch self {
        case let .underlying(error, _):
            return (error as NSError).code == -1009
        default:
            return false
        }
        
    }
}
