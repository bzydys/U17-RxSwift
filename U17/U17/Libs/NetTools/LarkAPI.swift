//
//  LarkAPI.swift
//  Lark
//
//  Created by ZengFanyi on 2019/1/25.
//  Copyright © 2019 曾凡怡. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
//import BigInt
//
//enum LarkApi {
//    // MARK: - EOS
//    /// eos创建账号订单状态验证
//    case eos_check_order(order_hash:String)
//    /// 公钥获取账户信息
//    case eos_accounts(publicKey:String)
//    /// 查询eos账户信息
//    case eos_account_info(address:String,tokenId:Int)
//    /// 账户名检测
//    case check_eos_account(address:String)
//    /// 转账
//    case eos_serialize(from:String,to:String,value:String,memo:String?,token_Id:Int)
//    /// 广播
//    case eos_tx_push(from:String,sig:String,head_block_num:Int)
//    /// 抵押资源
//    case eos_delegatebw(from:String,net:String,cpu:String)
//    /// 赎回资产
//    case eos_undelegatebw(from:String,net:String,cpu:String)
//    /// 购买内存
//    case eos_buy_ram(from:String,ramValue:String)
//    /// 卖出内存
//    case eos_sell_ram(from:String,ramValue:String)
//    /// EOS交易列表
//    case eos_tx_list(from:String,page:Int,limit:Int,type:String)
//    /// EOS交易详情
//    case tx_details(token_id:Int,tx_id:String)
//    /// EOS创建账号
//    case eos_create(account:String,publicKey:String)
//    /// Dapp 交易序列化
//    case eos_dapp(data:String)
//    /// 创建eos信息展示与当前价格
//    case resource_info
//    /// EOS任意签名 data 必选  12位字符串 必须12位
//    case arbitrary_signature(data:String)
//    /// 下载JS注入代码
//    case downloadJSInject
//    ///EOS创建账户信息资源分配信息
//    case careate_eos_resources
//    ///EOS创建账号（新）
//    case create_eos_account(account: String?, pubKey: String, creator: String)
//
//    // MARK: - ETH
//    /// ETH转账广播
//    case eth_transaction(sig:String,tx_hash:String,from:String,to:String,value:String,token_id:Int)
//    /// ERC20转账广播
//    case eth_erc20Push(data:String,trx_id:String,from:String,to:String,value:String,token_id:Int,sig:String)
//    /// 以太坊交易列表
//    case eth_tx_list(from:String,page:Int,limit:Int,type:String,token_id:Int)
//
//
//
//    // MARK: - 币币兑换
//    /// 可兑换币种列表
//    case getCoinList
//    /// 查询汇率
//    case getInstantRate(depositCoinCode:String,receiveCoinCode:String)
//    /// 地址校验
//    case address_check(address:String,chain:ChainType)
//    /// 生成兑换订单
//    case exchange(device_id:String,
//        type:String,
//        depositCoinCode:String,
//        receiveCoinCode:String,
//        depositCoinAmt:String,
//        receiveCoinAmt:String,
//        instantRate:NSNumber,
//        paymentAddress:String,
//        receiveAddress:String)
//    /// 兑换记录详情
//    case getExchangeInfo(order_id:String)
//    /// 兑换记录列表
//    case getExchangeList(device_id:String,page:Int,limit:Int)
//    /// 通知后端兑换完成
//    case updateExchange(type:String,order_id:String,transaction_id:String)
//
//
//    case assetsList(name:String?,chain:AssetSearchChainType,page:Int,limit:Int,type:String?)
//    case quota_defaultList
//    case asset_defaultList
//    case coinsInfo(models:[AssetModel])
//    case gasAccountInfo(address:String,tokenId:Int)
//    case eos_random_name
//
//    case discover(type:String)
//    case quota(page:Int,limit:Int,token_id:[Int])
//    case discoverSearch(name:String?,page:Int,limit:Int,type:String)
//    case discoverType_list(page:Int,limit:Int,attribute_id:Int,type:String)
//}
//
//extension LarkApi : TargetType , AutoErrorTip {
//
//    var parameters : [String:Any]? {
//        switch self {
//        case let .updateExchange(type,order_id,transaction_id):
//            return ["type":type,"order_id":order_id,"transaction_id":transaction_id]
//        case let .getExchangeList(device_id,page,limit):
//            return ["device_id":device_id,"device_type":"IOS","page":page,"limit":limit]
//        case let .getExchangeInfo(order_id):
//            return ["order_id":order_id]
//        case let .exchange(device_id,
//                           type,
//                           depositCoinCode,
//                           receiveCoinCode,
//                           depositCoinAmt,
//                           receiveCoinAmt,
//                           instantRate,
//                           paymentAddress,
//                           receiveAddress):
//            return ["device_id":device_id,
//                    "type":type,
//                    "device_type":"IOS",
//                    "depositCoinCode":depositCoinCode,
//                    "receiveCoinCode":receiveCoinCode,
//                    "depositCoinAmt":depositCoinAmt,
//                    "receiveCoinAmt":receiveCoinAmt,
//                    "instantRate":instantRate,
//                    "paymentAddress":paymentAddress,
//                    "receiveAddress":receiveAddress,
//                    "refundAddress":paymentAddress]
//        case let .address_check(address,chain):
//            var chainName = ""
//            switch chain {
//            case .eth : chainName = "ETH"
//            case .eos: chainName = "EOS"
//            case .btc: chainName = "BTC"
//            }
//            return ["address":address,"chain":chainName]
//        case let .getInstantRate(depositCoinCode,receiveCoinCode):
//            return ["depositCoinCode":depositCoinCode,"receiveCoinCode":receiveCoinCode]
//        case let .eos_accounts(publicKey):
//            return ["publicKey":publicKey]
//        case let .assetsList(name, chain, page, limit,type):
//            var searchKey = name ?? ""
//            searchKey = searchKey.notAllow([".","。"]).la_removeWhiteSpaces
//            var para : [String : Any] = ["name":searchKey,
//                                         "chain":chain.rawValue,
//                                         "page":page,
//                                         "size":limit]
//            if let tyepName = type {
//                para["type"] = tyepName
//            }
//            return para
//        case let .discoverSearch(name,page,limit,type):
//            return ["name":name ?? "",
//                    "show_platform":1,
//                    "page":page,
//                    "limit":limit,
//                    "type":type]
//        case let .coinsInfo(models):
//            return ["currency":UserSetting.monetaryUnit.rawValue,
//                    "data":models.map{
//                    ["token_id":$0.coin.token_id,
//                        "address":$0.wallets.map{wallet -> [String:String] in
//                        if wallet.chainType == .eos {
//                            return ["address":wallet.address]
//                        }else if wallet.chainType == .eth{
//                            return ["address":wallet.address.add0xIfNeeded()]
//                        }else{
//                            return ["address":wallet.address]
//                        }
//                        }]}]
//        case let .gasAccountInfo(address,token_id):
//            return ["address":address,"token_id":token_id]
//        case let .eth_transaction(data,tx,from,to,value,token_id):
//            return ["sig":data,"trx_id":tx,"from":from,"to":to,"value":value,"token_id":token_id]
//        case let .eth_erc20Push(data,trx_id,from,to,value,token_id,sig):
//            return ["data":data,"trx_id":trx_id,"from":from,"to":to,"value":value,"token_id":token_id,"sig":sig]
//        case let .eos_account_info(address,tokenId):
//            return ["address":address,"token_id":tokenId]
//        case let .eos_serialize(from,to,value,memo,token_Id):
//            return ["from":from,"to":to,"value":value,"memo":memo ?? "","token_id":token_Id]
//        case let .eos_tx_push(from,sig,head_block_num):
//            return ["from":from,"sig":sig,"head_block_num":head_block_num]
//        case let .eos_delegatebw(from,net,cpu):
//            return ["from":from,"netValue":net,"cpuValue":cpu,"token_id":3]
//        case let .eos_undelegatebw(from,net,cpu):
//            return ["from":from,"netValue":net,"cpuValue":cpu,"token_id":3]
//        case let .eos_buy_ram(from,ramValue):
//            return ["from":from,"ramValue":ramValue]
//        case let .eos_sell_ram(from,ramValue):
//            return ["from":from,"ramValue":ramValue]
//        case let .eth_tx_list(from,page,limit,type,token_id):
//            return ["from":from.add0xIfNeeded(),"page":page,"limit":limit,"type":type,"token_id":token_id]
//        case let .eos_tx_list(from,page,limit,type):
//            return ["from":from,"page":page,"limit":limit,"type":type]
//        case let .tx_details(token_id,tx_id):
//            return ["token_id":token_id,"trx_id":tx_id]
//        case let .check_eos_account(address):
//            return ["address":address,"chain":"EOS"]
//        case let .eos_create(account,pubkey):
//            return [ "account":account ,"pubkey":pubkey,"from": "voterperson1"]
//        case let .eos_check_order(order_hash):
//            return ["order_hash":order_hash]
//        case let .eos_dapp(data):
//            return ["data":data]
//        case let .discover(type):
//            return ["show_platform":1,"type":type]
//        case let .quota(page,limit,token_id):
//            return ["page":page,"limit":limit,"token_id":token_id,
//                    "currency":UserSetting.monetaryUnit.rawValue]
//        case let .discoverType_list(page,limit,attribute_id,type):
//            return ["show_platform":1,"type":type,
//                    "page":page,"limit":limit,
//                    "attribute_id":attribute_id]
//        case let .arbitrary_signature(data):
//            return ["data":data]
//        case let .create_eos_account(account, pubKey, creator):
//            if let acc = account {
//                return ["account": acc, "pubkey": pubKey, "creator": creator]
//            }
//            return ["pubkey": pubKey, "creator": creator]
//
//        default:
//            return nil
//        }
//    }
//
//    var path: String {
//        switch self {
//        case .updateExchange: return "updateExchange"
//        case .exchange: return "exchange"
//        case .address_check: return "address_check"
//        case .getInstantRate: return "getInstantRate"
//        case .getCoinList: return "getCoinList"
//        case .eth_erc20Push: return "erc20_transaction"
//        case .downloadJSInject: return "https://tools.lpl.app/dapp/ttt.js"
//        case .arbitrary_signature: return "arbitrary_signature"
//        case .asset_defaultList: return "default-create"
//        case .quota_defaultList: return "default-quota"
//        case .eos_accounts: return "eos_accounts"
//        case .assetsList: return "coins/search"
//        case .coinsInfo: return "coins"
//        case .gasAccountInfo: return "gas_account_info"
//        case .eth_transaction: return "eth_transaction"
//        case .eos_account_info: return "get_eos_account"
//        case .eos_serialize: return "eos_serialize"
//        case .eos_tx_push: return "eos_tx_push"
//        case .eos_delegatebw: return "eos_delegatebw"
//        case .eos_undelegatebw: return "eos_undelegatebw"
//        case .eos_buy_ram: return "eos_buy_ram"
//        case .eos_sell_ram: return "eos_sell_ram"
//        case .eos_tx_list: return "eos_tx_list"
//        case .tx_details: return "tx_details"
//        case .eth_tx_list: return "eth_tx_list"
//        case .check_eos_account: return "check_eos_account"
//        case .eos_create: return "eos_create"
//        case .eos_random_name: return "eos_random_name"
//        case .eos_check_order: return "eos_check_order"
//        case .eos_dapp: return "eos_dapp"
//        case .discover: return "discover"
//        case .quota: return "quota"
//        case .resource_info: return "resource_info"
//        case .discoverSearch: return "discover/search"
//        case .discoverType_list: return "discover/type_list"
//        case .getExchangeInfo: return "getExchangeInfo"
//        case .getExchangeList: return "getExchangeList"
//        case .careate_eos_resources: return "create_eos_resources"
//        case .create_eos_account: return "create_eos_account"
//        }
//    }
//
//    var method: Moya.Method {
//        switch self {
//        case .eos_random_name,
//             .resource_info,
//             .quota_defaultList,
//             .asset_defaultList,
//             .careate_eos_resources,
//             .getCoinList:
//            return .get
//        default: return .post
//        }
//    }
//
//    var baseURL: URL {
//        switch self {
//        case .downloadJSInject:
//            return URL(string: path)!
//        default:
//            return URL(string: UserSetting.currentBaseURL.url)!
//        }
//    }
//
//    var headers: [String : String]? {
//        return ["Content-Type":"application/json"] // 美元 usd
//    }
//
//    var sampleData: Data {
//        switch self {
//        case .assetsList: return zf_jsonData(forResource: "assetsList.json")!
//        default:
//            return Data()
//        }
//    }
//
//    var task: Task {
//        guard let p = parameters else {return .requestPlain}
//        return .requestParameters(parameters: p, encoding: parameterEncoding)
//    }
//
//    /// Choice of parameter encoding. **
//    public var parameterEncoding: ParameterEncoding {
//        switch method {
//        case .delete,.head:
//            return URLEncoding.default
//        default:
//            return JSONEncoding.default
//        }
//    }
//
//    var autoErrorTips: Bool {
//        switch self {
//        case .eos_accounts:
//            return false
//        default:
//            return true
//        }
//
//    }
//
//
//}
