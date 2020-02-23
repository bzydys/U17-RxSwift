//
//  Observable+ObjectMapper.swift
//  AlamofireDemo
//
//  Created by 曾凡怡 on 2017/3/14.
//  Copyright © 2017年 曾凡怡. All rights reserved.
//
import UIKit
import RxSwift
import Moya
import SwiftyJSON

enum ORMError : Swift.Error {
    case ORMNoRepresentor
    case ORMNotSuccessfulHTTP(code:Int)
    case ORMNoData
    case ORMNoCode
}
extension ORMError {
    var code : Int? {
        switch self {
        case .ORMNoCode,.ORMNoData,.ORMNoRepresentor: return nil
        case .ORMNotSuccessfulHTTP(let code): return code
        }
    }
}


let RESULT_CODE :String? = "code"        //访问成功后,服务器返回状态码的字段
let RESULT_MSG :String? = "msg"      //传递的信息字段
let RESULT_DATA :String? = "data"       //服务器数据结果字段

let API_IgnorePath : [String] = []


extension ObservableType where Element == Moya.Response {
    var mapSwiftyJSON : Observable<JSON> {
        return mapJSON().map{
            let json = JSON($0)
            if UserSetting.printNetWork {
                logg(json.dictionaryObject)
            }
            return json
        }
    }
}

extension Observable {
    private func resultFromJSON<T: Mapable>(jsonData:JSON, classType: T.Type) -> T? {
        return T(jsonData: jsonData)
    }
    
    // 检查状态码  抛出异常 进入fail
    func checkStatus() -> Observable{
        return map({ representor in
            // get Moya.Response
            guard let response = representor as? Moya.Response else
            {
                let err = ORMError.ORMNoRepresentor
                logerr(err)
                throw err
            }

            // check http status
            guard ((200..<300) ~= response.statusCode) else
            {
                let err = ORMError.ORMNotSuccessfulHTTP(code: response.statusCode)
                logerr(err)
                throw err
            }
            
            
            // unwrap biz json shell
            let json = JSON(response.data)
            
            // wrap biz code
            if RESULT_CODE != nil , let code = json[RESULT_CODE!].string   {
                
                // throw NoSuccessCode
                guard code == BizStatus.S200Success.code else {
                    throw BizStatus.fromCode(code , msg: RESULT_MSG != nil ? json[RESULT_MSG!].string : nil)!
                }
            }
            
            return representor
        })
    }
    
    func mapObject<T: Mapable>(type: T.Type) -> Observable<T>
    {
        return checkStatus().map { representor in
            // get Moya.Response
            guard let response = representor as? Moya.Response else
            {
                let err = ORMError.ORMNoRepresentor
                logerr(err)
                throw err
            }
            
            // unwrap biz json shell
            let json = JSON( response.data)
            if UserSetting.printNetWork {
                logg(json.dictionaryObject)
            }
            
            if RESULT_DATA != nil ? (json[RESULT_DATA!] != JSON.null) : (json != JSON.null)
            {
                return self.resultFromJSON(jsonData: RESULT_DATA != nil ? json[RESULT_DATA!] : json, classType:type)!
            }
            
            // bizSuccess -> return biz obj
            return self.resultFromJSON(jsonData: json, classType:type)!
        }
    }
    
    
    func mapArray<T: Mapable>(type: T.Type) -> Observable<[T]>
    {
        return checkStatus().map
            { response in
                
                // get Moya.Response
                guard let response = response as? Moya.Response else
                {
                    let err = ORMError.ORMNoRepresentor
                    logerr(err)
                    throw err
                }
                
                // unwrap biz json shell
                let json = JSON(response.data)
                
                // bizSuccess -> wrap and return biz obj array
                var objects = [T]()
                let objectsArrays = RESULT_DATA != nil ? json[RESULT_DATA!].array : json.array
                if UserSetting.printNetWork {
                    logg(json.dictionaryObject)
                }
                if let array = objectsArrays
                {
                    for object in array
                    {
                        if let obj = self.resultFromJSON(jsonData: object, classType:type)
                        {
                            objects.append(obj)
                        }
                    }
                    return objects
                }else
                {
                    let err = ORMError.ORMNoData
                    logerr(err)
                    throw err
                }
        }
    }
    
}
