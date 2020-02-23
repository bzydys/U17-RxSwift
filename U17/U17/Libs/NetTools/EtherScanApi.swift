//
//  EtherScanApi.swift
//  IB_iOS
//
//  Created by 曾凡怡 on 2018/9/7.
//  Copyright © 2018年 曾凡怡. All rights reserved.
//

//import Moya
//import SwiftyJSON
//
//public enum EtherScanApi {
//    /// 交易记录 1.页数,2.每页多少个
//    case AccountTxlist(page:Int,offset:Int)
//    /// erc20交易记录 1.合约地址,2.页数,3.每页多少个
//    case AccountTokenTx(contract:String,page:Int,offset:Int)
//    /// 交易hash信息
//    case hashInfo(hash:String)
//}
//
//extension EtherScanApi: TargetType , AutoErrorTip {
//
//    private var apiKey : String {return "VSZTQV6ZV8MUB4S793F4YS72BM9D53DSF4"}
//
//    /// path  *****
//    public var path: String {
//        switch self {
//        case .AccountTxlist
//        ,.AccountTokenTx: return "/api"//用户信息
//        case .hashInfo: return "/api"//交易信息
//        }
//    }
//    /// parameters *****
//    var parameter : [String : Any]? {
//
//        switch self {
//        case let .AccountTxlist(page,offset): return
//            ["module":"account","action":"txlist","address":"IBClient.default.address","page":page,"offset":offset,"sort":"desc","apikey":apiKey]
//        case let .AccountTokenTx(contractaddress,page,offset): return ["module":"account","action":"tokentx","address":"IBClient.default.address","page":page,"offset":offset,"apikey":apiKey,"sort":"desc","contractaddress":contractaddress]
//        case let .hashInfo(hash): return
//            ["module":"proxy","action":"eth_getTransactionByHash","txhash":hash,"apikey":apiKey]
//        }
//    }
//
//    /// HTTP.Method ***
//    public var method: Moya.Method {
//        switch self {
//        default: return .get
//        }
//    }
//
//    public var headers: [String : String]? {
////        var header = [String:String]()
////        return header
//        return [String:String]()
//    }
//
//    /// task **
//    public var task: Task {
//        guard let p = parameters else {return .requestPlain}
//        return .requestParameters(parameters: p, encoding: parameterEncoding)
//    }
//
//    /// Choice of parameter encoding. **
//    public var parameterEncoding: ParameterEncoding {
//        switch method {
//        case .delete,.head,.get:
//            return URLEncoding.default
//        default:
//            return JSONEncoding.default
//        }
//    }
//
//
//    public var parameters: [String : Any]? {
//        return parameter
//    }
//
//
//    public var host : String {
//        get{
//            #if DIS
//                return "https://api.etherscan.io"
//            #else
//                return "https://api-ropsten.etherscan.io"
//            #endif
//        }
//    }
//
//    /// protocol :// hostname[:port]  *
//    public var baseURL: URL {
//        return URL(string: self.host)!
//    }
//
//
//    var autoErrorTips: Bool {
//        return true
//    }
//
//
//    /// 单元测试参数 *
//    public var sampleData: Data {
//        switch self {
//        default: return "[{\"os\": \"1\", \"appId\": \"2\", \"version\": \"2.0.0\"}]".data(using: String.Encoding.utf8)!
//        }
//    }
//
//}
