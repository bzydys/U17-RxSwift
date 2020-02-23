//
//  ZFAPIClient.swift
//  AlamofireDemo
//
//  Created by 曾凡怡 on 2017/3/8.
//  Copyright © 2017年 曾凡怡. All rights reserved.
//

import Alamofire
import Moya
import RxSwift
import SwiftyJSON
import Result
import UIKit

// MARK: -
// MARK: 接口与自定义类型


/// 宏定义快速访问
let APIMgr = ZFAPIClient.shared

/// token存储字段
let accessTokenKey = "accessTokenKey"

/// 返回值类型
enum ResponseType {
    case String
    case JSON
    case Data
    case Image
}

/// 回调闭包类型
public typealias SuccessClosure = (_ result: Any?) -> Void
public typealias FailClosure = (_ error: Swift.Error) -> Void
public typealias FinishClosure = (_ target : TargetType) -> Void


// MARK: -
// MARK: 核心网络访问管理对象.
class ZFAPIClient {
    
    /// 单例对象
    static let shared = { () -> ZFAPIClient in
        let mgr = ZFAPIClient()
        return mgr
    }()
    init(){
        rech.listener = {status in
            switch status {
            case .notReachable: //无法连接
                logerr("网络无法连接 notReachable")
            case .reachable(.ethernetOrWiFi): //wifi
                logurl("切换到WIFI网络 reachable.ethernetOrWiFi")
                ZFNotiType.ConnectToNetwork.post()
            case .reachable(.wwan): //蜂窝
                logurl("切换到移动网络 reachable.wwan")
                ZFNotiType.ConnectToNetwork.post()
            case .unknown: //未知
                logerr("未知的网络状态")
            }
        }
        rech.startListening()
    }
    /// 网络状态监听
    let rech : NetworkReachabilityManager = NetworkReachabilityManager(host: "http://www.apple.com")!
    
    /// RX  垃圾袋
    var disposeBag = DisposeBag()
    
    /// 存储 provider 的缓存 , 可以通过将cache的某一value置为nil,来重新创建 provider.
    var providerCache = [String : Any]()
        
    /// subscribe缓存
    var subscribeCache = [String : Disposable]()
    
    /// 取消请求
    ///
    /// - Parameter target: 要取消的API
    func cancel(_ target : TargetType){
        subscribeCache[target.cacheKey]?.dispose()
    }
    
    /// 取消所有请求
    func cancelAll(){
        disposeBag = DisposeBag()
    }
    
    // MARK: -
    // MARK: 插件定义
    
    /// token插件
    func tokenPlugin(token : String?) -> ZFAccessTokenPlugin{
        return ZFAccessTokenPlugin(token: accessToken ?? "")
    }
    
    var accessToken : String? { return UserDefaults.standard.value(forKey: accessTokenKey) as? String}
    
    /// 网络连接数量
    var requestCount : Int = 0
    
    /// 网络连接状态指示器插件
    lazy var activityPlugin : NetworkActivityPlugin = {
        return NetworkActivityPlugin(networkActivityClosure: {[unowned self] type,_ in
            switch type {
            case .began:
                self.requestCount = self.requestCount + 1
            case .ended:
                self.requestCount = self.requestCount - 1
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.requestCount > 0 //根据条件显示网络指示器
            }
        })
    }()
    
    
    // MARK: -
    // MARK: HTTP请求配置信息
    /// 请求头信息
    var headerFields: [String: String] = [
        "Content-Type": "application/json"
    ]
    
    
    /// 额外参数
    var appendedParams: Dictionary<String, Any>? = nil//["access_token": "2.00bfi1PGUX1EgB40b13dd5095a164B"]
    
    /// 信任的域名
    let signedHosts : [String] = ["wallet.lpl.app","w.lark.one"]
    
    /// 自定义请求.添加头信息和额外参数.
    func getEndpointClosure<A : TargetType>()->(_ target: A) -> Endpoint{
        return { (target: A) -> Endpoint in
            var url = target.baseURL.absoluteString + target.path
            /// 转义URL
            url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            logurl("\(target)->\(url)")
            return Endpoint(
                url: url,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
                ).adding(newHTTPHeaderFields: self.headerFields)
        }
    }
    
    
    /// 信任 https
    var trustChallenge : (URLSession, URLSessionTask, URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition, URLCredential?) {return { session, sessionTask, challenge in
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        
        if self.signedHosts.contains(challenge.protectionSpace.host) {
            
            disposition = URLSession.AuthChallengeDisposition.useCredential
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
        }
        
        return (disposition, credential)
        }
    }
}

extension TargetType {
    var cacheKey : String {
        return method.rawValue + baseURL.absoluteString + path
    }
}

extension ZFAPIClient {
    
    /// 根据类型取出 provider,并发出请求
    func route<A : TargetType>(_ target : A) -> Observable<Response> {
        return cacheProvider(target).rx.request(target)
            .retryWhen({ (errorOb) -> Observable<Response> in
                return errorOb.flatMap({ err -> Observable<Response> in
                    if let err = err as? Moya.MoyaError , err.isOffline {
                        // 断网情况下等待连网通知
                        return ZFNotiType.ConnectToNetwork.observer.take(1).flatMap{ _ -> Observable<Response> in
                            // 重试网络
                            return self.cacheProvider(target).rx.request(target).asObservable()
                        }
                    }
                    throw err
                })
            })
            .asObservable()
            .async()
    }
    
    /// 根据类型取出 请求参数模型对象
    func cacheProvider<A : TargetType>(_ target : A)->MoyaProvider<A>{
        // 尝试取出缓存,否则创建
        guard let provider = providerCache[target.cacheKey] as? MoyaProvider<A> else{
            var errorTipsPlugin = ErrorTipsPlugin()
            // 当前 target 需要自动错误解析就添加提示插件
            if (target as? AutoErrorTip)?.autoErrorTips ?? false {
                errorTipsPlugin.dispalyer = ZFDispalyer()
            }
            // 插件
            let plugins : [PluginType] = [tokenPlugin(token : accessToken),activityPlugin,errorTipsPlugin]
            // 请求回调
            let myRequestClosure = {(endpoint: Endpoint, closure: MoyaProvider<A>.RequestResultClosure) -> Void in
                if var pureUrlRequest = try? endpoint.urlRequest() {
                    pureUrlRequest.timeoutInterval = 60 // 超时时长
                    closure(.success(pureUrlRequest))
                }else{
                    closure(.failure(MoyaError.requestMapping(endpoint.url)))
                }
            }
            // 获取 provider
            let provider = MoyaProvider<A>(endpointClosure : getEndpointClosure(), requestClosure:myRequestClosure,plugins: plugins)
            // 设置信任 host 的 https 请求 让 charles 抓包
            provider.manager.delegate.taskDidReceiveChallenge = trustChallenge
            // 缓存起来
            providerCache[target.cacheKey] = provider
            // 返回 provider
            return provider
        }
        // 使用缓存对象发出请求 并可以对 http的Response.statusCode进行过滤,不符合的抛出异常
        return provider//.filterSuccessfulStatusCodes()
    }
}


// MARK: -
// MARK: 链式语法封装
public class Route<A:TargetType> : NSObject{
    
    /// 1. 通过EPAPIClient发出请求
    public init(_ target : A)
    {
        self.target = target
        provider = APIMgr.cacheProvider(target)
        // 缓存的加密对象 清除
//        let key = target.baseURL.absoluteString+target.path+String(target.method.hashValue)
    }
    
    /// 目标
    private var target : A
    /// Moya 发起请求模型
    private var provider : MoyaProvider<A>
    
    /// 发起请求的序列. 包含联网后自动重试
    private var requestOB : Observable<Response> {
        return provider.rx.request(target)
            .retryWhen({ (errorOb) -> Observable<Response> in
                return errorOb.flatMap({ err -> Observable<Response> in
                    if let err = err as? Moya.MoyaError , err.isOffline {
                        // 断网情况下等待连网通知
                        return ZFNotiType.ConnectToNetwork.observer.take(1).flatMap{ _ -> Observable<Response> in
                            // 重试网络
                            return self.provider.rx.request(self.target).asObservable()
                        }
                    }
                    throw err
                })
            })
            .asObservable()
    }
    
    /// 2. 用不同的方法设置解析
    public func model<T: Mapable>(_ type: T.Type,showHud:Bool = false , disposeOldRequest:Bool = false) -> ModelHandler<T>
    {
        let handler = ModelHandler<T>.init(target)
        var ob = requestOB
            .mapObject(type: type)
        if showHud {
            ob = ob.showHUD()
        }
        let sub = ob.subscribe(onNext: {[weak handler] model in
            handler?._successClosure?(model)
            }, onError: {[weak handler] error in
                handler?._failClosure?(error)
            },onCompleted: {[weak handler] in
                handler?._completed(handler!.target)
            }, onDisposed: {
                handler._disposed(handler.target)
                Alert.hideProgress()
        })
        
        let oldRequest = APIMgr.subscribeCache.updateValue(sub, forKey: target.path)
        if disposeOldRequest {
            oldRequest?.dispose()
        }
        sub.disposed(by: APIMgr.disposeBag)
        return handler
    }
    
    
    public func array<T: Mapable>(_ type: T.Type,showHud:Bool = false , disposeOldRequest:Bool = false) -> ModelHandler<[T]>
    {
        let handler = ModelHandler<[T]>(target)
        var ob = requestOB.mapArray(type: type)
        if showHud {
            ob = ob.showHUD()
        }
        let sub = ob.subscribe(onNext: {[weak handler] modelArr in
            handler?._successClosure?(modelArr)
            }, onError: {[weak handler] error in
                handler?._failClosure?(error)
            },onCompleted: {[weak handler] in
                handler?._completed(handler!.target)
            }, onDisposed: {
                handler._disposed(handler.target)
        })
        let oldRequest = APIMgr.subscribeCache.updateValue(sub, forKey: target.path)
        if disposeOldRequest {
            oldRequest?.dispose()
        }
        sub.disposed(by: APIMgr.disposeBag)
        return handler
    }
    
    public func json(showHud:Bool = false , disposeOldRequest:Bool = false) -> JSONHandler {
        let handler = JSONHandler(target)
        var ob = requestOB
            .checkStatus()
            .mapSwiftyJSON
        if showHud {
            ob = ob.showHUD()
        }
        let sub  = ob.subscribe(onNext: {[weak handler] (data) in
                var json = JSON(data)
                handler?.target.adaptation(json: &json)
                handler?._successClosure?(json)
                }, onError: {[weak handler] (error) in
                    handler?._failClosure?(error)
                },onCompleted: {[weak handler] in
                    handler?._completed(handler!.target)
                }, onDisposed: {
                    handler._disposed(handler.target)
            })
        let oldRequest = APIMgr.subscribeCache.updateValue(sub, forKey: target.path)
        if disposeOldRequest {
            oldRequest?.dispose()
        }
        sub.disposed(by: APIMgr.disposeBag) // 添加到垃圾袋 可以单独取消
        return handler
    }
    
    public var json : JSONHandler {
        return json()
    }
    
    public var upload : UploadHandler {
        let handler = UploadHandler(target)
        let cancel = provider.request(target, callbackQueue: DispatchQueue.main,
                         progress: { [weak handler] in handler?._progress?($0)},
                         completion: {[weak handler] complete in
                            complete.analysis(ifSuccess: {handler?._successClosure?(JSON($0.data))},
                                              ifFailure: {handler?._failClosure?($0)})
                            handler?._completed(handler!.target)})
        handler._cancellable = cancel
        return handler
    }
    
    public var image : ImageHandler {
        let handler = ImageHandler(target)
        let sub = requestOB
            .mapImage()
            .asObservable()
            .subscribe(onNext: {[weak handler] (image) in
                handler?._successClosure?(image)
                }, onError: {[weak handler] (error) in
                    handler?._failClosure?(error)
                }, onCompleted: { [weak handler] in
                    handler?._completed(handler!.target)
            }) {
                handler._disposed(handler.target)
        }
        sub.disposed(by: APIMgr.disposeBag)
        return handler
    }
    
    deinit {
//        logg("route die")
    }
}



public class Handler{

    /// 1. 通过EPAPIClient发出请求
    init(_ target : TargetType)
    {
        self.target = target
    }
    
    /// 目标
    var target : TargetType
    
    fileprivate var _failClosure : FailClosure?
    
    /// 完成请求的默认实现
    fileprivate var _completed : FinishClosure = {target in
        //        logurl("\(target) onCompleted")
    }
    
    /// 请求被丢弃或取消的默认实现
    fileprivate var _disposed : FinishClosure = {target in
        APIMgr.subscribeCache[target.cacheKey] = nil
        logurl("\(target) onDisposed")
    }
    
    @discardableResult public func completed(_ completedClosure : @escaping FinishClosure) -> Self {
        _completed = completedClosure
        return self
    }
    
    @discardableResult public func disposed(_ disposedClosure : @escaping FinishClosure) -> Self {
        _disposed = disposedClosure
        return self
    }
    
    @discardableResult public func faile(_ failClosure : @escaping FailClosure) -> Self {
        _failClosure = failClosure
        return self
    }
    
    deinit {
//        logg("handler die")
    }
    
}

public class JSONHandler : Handler{
    
    @discardableResult public func success(_ successClosure : @escaping (JSON) -> ()) -> Self{
        _successClosure = successClosure
        return self
    }
    
    // 保存成功的回调
    fileprivate var _successClosure : ((JSON) -> ())?
}

public class UploadHandler :JSONHandler,Cancellable{
    
    public var reupload : UploadHandler{
        let reuploadHandler = target.upload
        if _progress != nil {
            reuploadHandler.progress(_progress!)
        }
        if _successClosure != nil {
            reuploadHandler.success(_successClosure!)
        }
        if _failClosure != nil {
            reuploadHandler.faile(_failClosure!)
        }
        reuploadHandler.completed(_completed)
        
        return reuploadHandler
    }
    
    public var isCancelled: Bool {
        return _cancellable.isCancelled
    }
    
    public func cancel(){
        _cancellable.cancel()
    }
    
    fileprivate var _cancellable : Cancellable!
    
    @discardableResult public func progress(_ progress : @escaping (ProgressResponse) -> ()) -> Self{
        _progress = progress
        return self
    }
    
    fileprivate var _progress : ((ProgressResponse) -> ())?
}

public class ImageHandler: Handler {
    @discardableResult public func success(_ successClosure : @escaping (UIImage?) -> ()) -> Self{
        _successClosure = successClosure
        return self
    }
    
    // 保存成功的回调
    fileprivate var _successClosure : ((UIImage?) -> ())?
}


public class ModelHandler<T> : Handler{
    
    @discardableResult public func success(_ successClosure : @escaping (T) -> ()) -> Self{
        _successClosure = successClosure
        return self
    }
    
    // 保存成功的回调
    fileprivate var _successClosure : ((T) -> ())?
}





/// 随机字符串生成
class RandomString {
    static let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    /**
     生成随机字符串,
     
     - parameter length: 生成的字符串的长度
     
     - returns: 随机生成的字符串
     */
    class func getRandomString(length: Int) -> String {
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            let s = (characters as NSString).substring(with: NSRange.init(location: index, length: 1))
            ranStr.append(s)
        }
        return ranStr
        
    }
}
